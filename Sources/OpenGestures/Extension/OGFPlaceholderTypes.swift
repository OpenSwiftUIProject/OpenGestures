//
//  OGFPlaceholderTypes.swift
//  OpenGestures
//
//  Placeholder protocol definitions for non-Darwin platforms where
//  the ObjC protocols from COpenGestures are not available.

#if !canImport(ObjectiveC)

public protocol OGFGestureNode: AnyObject {
    // weak in ObjC
    // Swift protocols can't express weak without @objc,
    /*weak*/ var delegate: (any OGFGestureNodeDelegate)? { get set }
    /*weak*/ var container: (any OGFGestureNodeContainer)? { get set }
    var coordinator: (any OGFGestureNodeCoordinator)? { get set }
    var phase: OGFGesturePhase { get }
    var isBlocked: Bool { get }
    var identifier: String { get }
    var tag: String? { get set }
    var isDisabled: Bool { get set }
    var disallowExclusionWithUnresolvedFailureRequirements: Bool { get set }
    var platformKey: Int { get }
    var failureReason: (any Error)? { get }

    func abort() throws
    func addRelation(type: OGFGestureRelationType, role: OGFGestureRelationRole, relatedNode: any OGFGestureNode)
    func ensureUpdated() throws
    func fail(reason: Any?, error: inout (any Error)?) throws
    func removeRelation(type: OGFGestureRelationType, role: OGFGestureRelationRole, relatedNode: any OGFGestureNode)
    func setTracking(_ tracking: Bool, eventsWithIdentifiers identifiers: [Any])
    func update(value: Any?, isFinal: Bool) throws
}

public protocol OGFGestureNodeDelegate: AnyObject {
    func gestureNode(_ node: any OGFGestureNode, didUpdatePhase phase: OGFGesturePhase)
    func gestureNode(_ node: any OGFGestureNode, roleForRelationType type: OGFGestureRelationType, relatedNode: any OGFGestureNode) -> Any?
    func gestureNodeShouldActivate(_ node: any OGFGestureNode) -> Bool
    func gestureNodeWillUnblock(_ node: any OGFGestureNode)

    // optional in ObjC
    // Swift protocols can't express optional without @objc,
    // so we provide default empty implementations below.
    /*optional*/ func gestureNode(_ node: any OGFGestureNode, didEnqueuePhase phase: OGFGesturePhase)
    /*optional*/ func gestureNodeWillAbort(_ node: any OGFGestureNode)
}

extension OGFGestureNodeDelegate {
    public func gestureNode(_ node: any OGFGestureNode, didEnqueuePhase phase: OGFGesturePhase) {}
    public func gestureNodeWillAbort(_ node: any OGFGestureNode) {}
}

public protocol OGFGestureNodeContainer: AnyObject {
    func indexOfGestureNode(_ node: any OGFGestureNode) -> Int
    func isDeeperThanContainer(_ container: any OGFGestureNodeContainer, referenceNode: any OGFGestureNode) -> Bool
    func isDescendantOfContainer(_ container: any OGFGestureNodeContainer, referenceNode: any OGFGestureNode) -> Bool
}

public protocol OGFGestureNodeCoordinator: AnyObject {
    var nodes: [any OGFGestureNode] { get }
    var willUpdateHandler: (() -> Void)? { get set }
    var willProcessUpdateQueueHandler: (() -> Void)? { get set }
    var didUpdateHandler: (() -> Void)? { get set }

    func enqueueUpdatesForNodes(_ nodes: [any OGFGestureNode], inBlock block: ([any OGFGestureNode]) -> Void, reason: String)
    func hasUnresolvedFailureDependenciesForNode(_ node: any OGFGestureNode) -> Bool
    func updateWithNodes(_ nodes: [any OGFGestureNode], reason: String, updateHandler: ([any OGFGestureNode]) -> Void)
    func failureDependentsForNode(_ node: any OGFGestureNode) -> [any OGFGestureNode]
    func processUpdatesWithReason(_ reason: String)
}

#endif
