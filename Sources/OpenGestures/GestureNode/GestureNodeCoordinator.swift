// MARK: - TimeSource

/// Protocol for providing timestamps to the gesture system.
public protocol TimeSource: Sendable {
    var timestamp: Timestamp { get }
}

// MARK: - GestureUpdateDriver

/// Protocol for driving gesture update cycles.
public protocol GestureUpdateDriver: Sendable {
    func register(_ handler: @escaping () -> Void) -> GestureUpdateDriverToken
    func unregister(token: GestureUpdateDriverToken)
}

/// Token returned by GestureUpdateDriver.register.
public struct GestureUpdateDriverToken: Hashable, Sendable {
    public var value: UInt32
    public init(value: UInt32) { self.value = value }
}

// MARK: - GestureNodeCoordinator

/// Central coordinator that manages gesture node updates and conflict resolution.
public final class GestureNodeCoordinator: @unchecked Sendable {

    // MARK: - Callbacks

    public var willUpdate: (() -> Void)?
    public var willProcessUpdateQueue: (() -> Void)?
    public var didUpdate: (() -> Void)?

    // MARK: - Internal State

    private let timeSource: any TimeSource
    private let updateDriver: (any GestureUpdateDriver)?
    private let shouldTrackTransitiveDependencies: Bool
    private var nodes: Set<ObjectIdentifier> = []
    private var _nodeRefs: [AnyGestureNode] = []

    // MARK: - Init

    public init(
        timeSource: any TimeSource,
        updateDriver: (any GestureUpdateDriver)? = nil,
        shouldTrackTransitiveDependencies: Bool = false
    ) {
        self.timeSource = timeSource
        self.updateDriver = updateDriver
        self.shouldTrackTransitiveDependencies = shouldTrackTransitiveDependencies
    }

    // MARK: - Node Management

    func addNode(_ node: AnyGestureNode) {
        let oid = ObjectIdentifier(node)
        if nodes.insert(oid).inserted {
            _nodeRefs.append(node)
        }
    }

    func removeNode(_ node: AnyGestureNode) {
        let oid = ObjectIdentifier(node)
        if nodes.remove(oid) != nil {
            _nodeRefs.removeAll { $0 === node }
        }
    }

    // MARK: - Update Dispatch

    /// Enqueues updates for the given nodes.
    public func enqueueUpdates(
        nodes: [AnyGestureNode],
        reason: String,
        closure: (AnyGestureNode) -> Void
    ) {
        for node in nodes {
            guard !node.options.contains(.isDisabled),
                  node.container != nil else {
                continue
            }
            closure(node)
        }
    }

    /// Processes all queued updates.
    public func processUpdates(reason: String) {
        willProcessUpdateQueue?()
        willUpdate?()
        // TODO: Actual update processing — iterate queued phase transitions,
        //       run ExclusionPool + FailureDependencyGraph resolution
        didUpdate?()
    }

    deinit {
        // Clear coordinator back-refs on all managed nodes
        for node in _nodeRefs {
            // node's coordinator back-ref would be cleared here
        }
    }
}
