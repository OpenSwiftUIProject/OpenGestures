// MARK: - GestureNode

/// A concrete gesture node with a typed Value.
public final class GestureNode<Value: Sendable>: AnyGestureNode, @unchecked Sendable {

    // MARK: - Stored Properties

    // We use a type-erased callback approach for the delegate since Swift doesn't support
    // `weak var delegate: (any GestureNodeDelegate<Value>)?` directly without primary
    // associated types on the protocol.
    private var _didUpdatePhase: ((GesturePhase<Value>, GesturePhase<Value>) -> Void)?
    private var _shouldActivate: (() -> Bool)?

    public private(set) var phase: GesturePhase<Value> = .idle
    public private(set) var latestPhase: GesturePhase<Value> = .idle

    // MARK: - Init

    public override init(
        traits: GestureTraitCollection? = nil,
        tag: GestureTag? = nil,
        relations: [GestureRelation] = []
    ) {
        super.init(traits: traits, tag: tag, relations: relations)
    }

    // MARK: - Delegate

    public func setDelegate<D: GestureNodeDelegate>(_ delegate: D) where D.Value == Value {
        _shouldActivate = { [weak delegate] in
            delegate?.gestureNodeShouldActivate(self) ?? true
        }
        _didUpdatePhase = { [weak delegate, weak self] newPhase, oldPhase in
            guard let self else { return }
            delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
        }
    }

    // MARK: - Update

    public func update(value: Value, isFinalUpdate: Bool) throws {
        let oldPhase = phase
        if isFinalUpdate {
            phase = .ended(value)
        } else {
            phase = .active(value)
        }
        latestPhase = phase
        _didUpdatePhase?(phase, oldPhase)
    }

    public override func update(someValue: Any, isFinalUpdate: Bool) throws {
        guard let typedValue = someValue as? Value else {
            fatalError("Type mismatch: expected \(Value.self), got \(type(of: someValue))")
        }
        try update(value: typedValue, isFinalUpdate: isFinalUpdate)
    }

    // MARK: - Abort / Fail

    public override func abort() throws {
        let oldPhase = phase
        phase = .failed(.aborted)
        latestPhase = phase
        _didUpdatePhase?(phase, oldPhase)
    }

    public override func fail(with error: Error) throws {
        let oldPhase = phase
        // TODO: .error(Error) case once non-Sendable handling resolved
        phase = .failed(.aborted)
        latestPhase = phase
        _didUpdatePhase?(phase, oldPhase)
    }
}
