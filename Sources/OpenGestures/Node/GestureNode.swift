import Foundation
import Synchronization

// MARK: - AnyGestureNode [WIP]

/// Type-erased base class for gesture nodes.

open class AnyGestureNode: Identifiable, Hashable, @unchecked Sendable {

    // MARK: - Static ID counter

    /// Monotonically increasing node-ID allocator. Apple's `Gestures.framework`
    /// stores the counter in a plain static `UInt32` protected by `swift_once`
    /// and bumps it via an ARM64 CAS loop with trap-on-overflow semantics;
    /// `Synchronization.Atomic<UInt32>` reproduces that pattern directly.
    private static let _nextID = Atomic<UInt32>(0)

    package static func _allocateID() -> UInt32 {
        var current = _nextID.load(ordering: .relaxed)
        while true {
            let next = current + 1
            let (exchanged, actual) = _nextID.compareExchange(
                expected: current, desired: next, ordering: .relaxed
            )
            if exchanged { return next }
            current = actual
        }
    }

    // MARK: - Stored Properties

    public let id: GestureNodeID
    public var tag: GestureTag?
    public var traits: GestureTraitCollection?
    open var options: GestureNodeOptions
    open weak var container: (any GestureNodeContainer)?
    package var timeSource: (any TimeSource)?
    package unowned var context: AnyObject?
    package var debuglabelProvider: ((AnyGestureNode) -> String)?
    package unowned var listener: (any GestureNodeListener)?
    package var relationMap: RelationMap
    package var trackedEvents: Set<EventID> = []

    // MARK: - Init [WIP]

    package init(
        traits: GestureTraitCollection? = nil,
        tag: GestureTag? = nil,
        relations: [GestureRelation] = []
    ) {
        self.id = GestureNodeID(rawValue: Self._allocateID())
        self.tag = tag
        self.traits = traits
        self.options = []
        for relation in relations {
            addRelation(relation)
        }
    }

    // MARK: - Relations


    open var relations: [GestureRelation] {
        relationMap.toRelations()
    }

    open func addRelation(_ relation: GestureRelation) {
        relationMap.addRelation(relation)
    }

    open func removeRelation(_ relation: GestureRelation) {
        relationMap.removeRelation(relation)
    }

    open func addRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            addRelation(relation)
        }
    }

    open func removeRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            removeRelation(relation)
        }
    }

    // MARK: - Event Tracking

    public func startTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            _trackedEventIDs.insert(id)
        }
    }

    public func stopTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            _trackedEventIDs.remove(id)
        }
    }

    // MARK: - Update / Abort / Fail

    /// Type-erased update. Subclass (`GestureNode<Value>`) overrides.
    open func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Aborts the gesture, transitioning its phase to
    /// `.failed(reason: .aborted)`. Apple's `abort()` (at 0x26358) is a
    /// direct-dispatch method that invokes an overridable vtable slot rather
    /// than routing through `fail(with:)`; `GestureNode<Value>` provides the
    /// concrete override.
    open func abort() throws {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Fails the gesture with an error.
    open func fail(with error: Error) throws {
        _openGesturesBaseClassAbstractMethod()
    }

    // MARK: - Debug

    public var debugLabel: String {
        let address = String(UInt(bitPattern: ObjectIdentifier(self)), radix: 16)
        return "\(type(of: self)) <0x\(address) \(id)>"
    }

}

// MARK: - Hashable / Comparable

extension AnyGestureNode {
    public static func == (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension AnyGestureNode: Comparable {
    public static func < (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs.id < rhs.id
    }
}

// MARK: - GestureNode [WIP]

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

    // MARK: - Abort / Fail

    public override func abort() throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = .failed(reason: .aborted)
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }

    public override func fail(with error: Error) throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = .failed(reason: .custom(error))
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }
}
