import Foundation

// MARK: - AnyGestureNode

/// Type-erased base class for gesture nodes.
open class AnyGestureNode: Hashable, Identifiable, @unchecked Sendable {

    // MARK: - Static ID counter

    private static let _nextID = ManagedAtomic<UInt32>(0)

    // MARK: - Stored Properties

    public let id: GestureNodeID
    public var tag: GestureTag?
    public var traits: GestureTraitCollection?
    public var options: GestureNodeOptions
    public weak var container: (any GestureNodeContainer)?
    private var _trackedEventIDs: Set<EventID> = []

    // MARK: - Init

    public init(
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

    private var _relations: [GestureRelation] = []

    public var relations: [GestureRelation] {
        _relations
    }

    open func addRelation(_ relation: GestureRelation) {
        _relations.append(relation)
    }

    open func removeRelation(_ relation: GestureRelation) {
        // TODO: Equatable-based removal
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
    open func update(someValue: Any, isFinalUpdate: Bool) throws {
        fatalError("Subclass must override")
    }

    /// Aborts the gesture, setting phase to .failed(.aborted).
    open func abort() throws {
        // Constructs .failed(.aborted) and dispatches
        fatalError("Subclass must override")
    }

    /// Fails the gesture with an error.
    open func fail(with error: Error) throws {
        fatalError("Subclass must override")
    }

    // MARK: - Debug

    public var debugLabel: String {
        "\(type(of: self))(\(id))"
    }

    // MARK: - Hashable / Equatable

    public static func == (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Comparable

extension AnyGestureNode: Comparable {
    public static func < (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs.id < rhs.id
    }
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
