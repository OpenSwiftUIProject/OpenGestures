public import Foundation

// MARK: - GestureNodeCoordinator

/// Central coordinator that manages gesture node updates and conflict resolution.
public final class GestureNodeCoordinator: NSObject, @unchecked Sendable {

    // MARK: - Callbacks

    public var willUpdate: (() -> Void)?
    public var willProcessUpdateQueue: (() -> Void)?
    public var didUpdate: (() -> Void)?

    // MARK: - Tracked Nodes

    /// All nodes this coordinator currently owns.
    private var nodes: Set<AnyGestureNode> = []

    // MARK: - Configuration

    private let timeSource: any TimeSource

    // MARK: - Conflict Resolution

    private let failureDependencyGraph = FailureDependencyGraph()
    private var exclusionPool = ExclusionPool()

    // MARK: - Pending Work

    private var nodesNeedingUpdate: Set<AnyGestureNode> = []
    private var nodesNeedingReset: Set<AnyGestureNode> = []
    private var isProcessingUpdates: Bool = false
    private var synchronousNodeUpdates: [GestureNodeID] = []

    // MARK: - Update Driver

    private let updateDriver: any GestureUpdateDriver
    private var updateDriverToken: GestureUpdateDriverToken?
    private var resetTracker: SubgraphResetTracker = SubgraphResetTracker()

    // MARK: - Init

    public init(
        timeSource: any TimeSource,
        updateDriver: (any GestureUpdateDriver)? = nil,
        shouldTrackTransitiveDependencies: Bool = false
    ) {
        // TODO
        fatalError("TODO")
    }

    // MARK: - Update Dispatch

    public func enqueueUpdates(
        nodes: [AnyGestureNode],
        reason: String,
        closure: (AnyGestureNode) -> Void
    ) {
        // TODO
        willUpdate?()
        for node in nodes {
            guard !node.options.contains(.isDisabled),
                  node.container != nil else {
                continue
            }
            closure(node)
            nodesNeedingUpdate.insert(node)
        }
    }

//    public func processUpdates(reason: String) {
//        guard !nodesNeedingUpdate.isEmpty, !isProcessingUpdates else { return }
//        isProcessingUpdates = true
//        defer {
//            synchronousNodeUpdates.removeAll()
//            isProcessingUpdates = false
//        }
//        willProcessUpdateQueue?()
//        while !nodesNeedingUpdate.isEmpty {
//            let pendingNodes = nodesNeedingUpdate.sorted()
//            nodesNeedingUpdate.removeAll()
//            for node in pendingNodes {
//                node.processPendingPhaseUpdates()
//            }
//        }
//        didUpdate?()
//    }

    package func gestureNode(
        _ node: AnyGestureNode,
        didEnqueuePhaseWithSynchronousUpdate synchronous: Bool
    ) {
        nodesNeedingUpdate.insert(node)
        guard synchronous else { return }
        // TODO
        // synchronousNodeUpdates.append(node.id)
        // syncPhaseChange(for: node)
    }

    package func syncPhaseChange(for node: AnyGestureNode) {
        // processUpdates(reason: "syncPhaseChange(for: \(node.id))")
    }
}

// TODO: SubgraphResetTracker

struct SubgraphResetTracker {}
