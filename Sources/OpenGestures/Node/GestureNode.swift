// MARK: - GestureNode

/// A concrete gesture node with a typed Value.
///
/// Non-final so application code can subclass. Apple's symbol table exposes
/// dispatch thunks and a method-lookup function, confirming the class is
/// designed to be subclassed.
public class GestureNode<Value: Sendable>: AnyGestureNode, @unchecked Sendable {

    // MARK: - Stored Properties

    /// Weak reference to the typed delegate. Primary associated type on
    /// `GestureNodeDelegate<Value>` lets us spell this directly.
    public weak var delegate: (any GestureNodeDelegate<Value>)?

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

    /// Zero-arg convenience init. Apple exposes `__allocating_init()` on
    /// `GestureNode<A>`.
    public convenience init() {
        self.init(traits: nil, tag: nil, relations: [])
    }

    // MARK: - Phase

    /// The currently committed phase, as observed after the last
    /// `processUpdates` drain.
    public var phase: GesturePhase<Value> {
        phaseQueue.currentPhase
    }

    /// The most recently enqueued phase. May differ from `phase` between
    /// `enqueueUpdates` and the next `processUpdates` drain.
    ///
    /// TODO: track the pending tail separately once the coordinator's resolve
    /// logic splits committed and pending phases.
    public var latestPhase: GesturePhase<Value> {
        phaseQueue.currentPhase
    }

    // MARK: - Update

    public func update(value: Value, isFinalUpdate: Bool) throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = isFinalUpdate ? .ended(value: value) : .active(value: value)
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }

    public override func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        guard let typedValue = someValue as? Value else {
            fatalError("Type mismatch: expected \(Value.self), got \(type(of: someValue))")
        }
        try update(value: typedValue, isFinalUpdate: isFinalUpdate)
    }

    // MARK: - Fail

    public override func fail(with error: Error) throws {
        let oldPhase = phaseQueue.currentPhase
        // TODO: .error(Error) case once non-Sendable handling resolved
        let newPhase: GesturePhase<Value> = .failed(reason: .aborted)
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }
}
