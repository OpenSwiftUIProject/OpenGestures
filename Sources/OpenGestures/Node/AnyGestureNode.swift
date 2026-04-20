import Foundation

// MARK: - AnyGestureNode

/// Type-erased base class for gesture nodes.
open class AnyGestureNode: Identifiable, Hashable, @unchecked Sendable {

    // MARK: - Static ID counter

    private static let _nextID = ManagedAtomic<UInt32>(0)

    // MARK: - Stored Properties

    public let id: GestureNodeID
    public var tag: GestureTag?
    public var traits: GestureTraitCollection?
    open var options: GestureNodeOptions
    open weak var container: (any GestureNodeContainer)?
    private var _trackedEventIDs: Set<EventID> = []

    // MARK: - Init

    package init(
        traits: GestureTraitCollection? = nil,
        tag: GestureTag? = nil,
        relations: [GestureRelation] = []
    ) {
        let rawID = Self._nextID.wrappingIncrementThenLoad()
        self.id = GestureNodeID(rawValue: rawID)
        self.tag = tag
        self.traits = traits
        self.options = []
        for relation in relations {
            addRelation(relation)
        }
    }

    // MARK: - Relations

    package var relationMap = RelationMap()

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

    /// Type-erased update. Subclass (GestureNode<T>) overrides.
    open func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        fatalError("Subclass must override")
    }

    /// Aborts the gesture, setting phase to .failed(.aborted).
    open func abort() throws {
        try fail(with: _GestureAbortError())
    }

    /// Fails the gesture with an error.
    open func fail(with error: Error) throws {
        fatalError("Subclass must override")
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

// MARK: - _GestureAbortError

/// Internal sentinel error dispatched through `fail(with:)` when a gesture is
/// aborted via `AnyGestureNode.abort()`.
package struct _GestureAbortError: Error {
    package init() {}
}

// MARK: - ManagedAtomic (minimal)

/// Minimal atomic counter for node ID generation.
private final class ManagedAtomic<T: FixedWidthInteger>: @unchecked Sendable {
    private var _value: T
    private let _lock = NSLock()

    init(_ value: T) {
        _value = value
    }

    func wrappingIncrementThenLoad(ordering _: Any? = nil) -> T {
        _lock.lock()
        defer { _lock.unlock() }
        _value &+= 1
        return _value
    }
}
