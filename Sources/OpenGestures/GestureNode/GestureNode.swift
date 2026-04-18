// MARK: - GestureNode

/// A concrete gesture node with a typed Value.
public final class GestureNode<Value: Sendable>: AnyGestureNode, @unchecked Sendable {

    // MARK: - Stored Properties

    // We use a type-erased callback approach for the delegate since Swift doesn't support
    // `weak var delegate: (any GestureNodeDelegate<Value>)?` directly without primary
    // associated types on the protocol.
    private var _didUpdatePhase: ((GesturePhase<Value>, GesturePhase<Value>) -> Void)?
    private var _shouldActivate: (() -> Bool)?

    package var phaseQueue: GesturePhaseQueue<Value> = GesturePhaseQueue(
        timeSource: nil,
        currentPhase: .idle,
        pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
    )

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
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = isFinalUpdate ? .ended(value: value) : .active(value: value)
        phaseQueue.currentPhase = newPhase
        _didUpdatePhase?(newPhase, oldPhase)
    }

    public override func update(someValue: Any, isFinalUpdate: Bool) throws {
        guard let typedValue = someValue as? Value else {
            fatalError("Type mismatch: expected \(Value.self), got \(type(of: someValue))")
        }
        try update(value: typedValue, isFinalUpdate: isFinalUpdate)
    }

    // MARK: - Abort / Fail

    public override func abort() throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = .failed(reason: .aborted)
        phaseQueue.currentPhase = newPhase
        _didUpdatePhase?(newPhase, oldPhase)
    }

    public override func fail(with error: Error) throws {
        let oldPhase = phaseQueue.currentPhase
        // TODO: .error(Error) case once non-Sendable handling resolved
        let newPhase: GesturePhase<Value> = .failed(reason: .aborted)
        phaseQueue.currentPhase = newPhase
        _didUpdatePhase?(newPhase, oldPhase)
    }
}
