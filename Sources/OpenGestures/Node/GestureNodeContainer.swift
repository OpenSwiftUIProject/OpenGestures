//
//  GestureNodeContainer.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Blocked by GestureNodeListener

// MARK: - GestureNodeContainer

/// Protocol for querying node hierarchy in the view tree.
public protocol GestureNodeContainer: AnyObject, Sendable {
    func index(of node: AnyGestureNode) -> Int?
    func isDescendant(of container: any GestureNodeContainer, referenceNode: AnyGestureNode) -> Bool
    func isDeeper(than container: any GestureNodeContainer, referenceNode: AnyGestureNode) -> Bool
}

// MARK: - GestureNodeListener [WIP]

package protocol GestureNodeListener: AnyObject {
//    func gestureNode(
//        _ node: AnyGestureNode,
//        didAddRelation relation: GestureRelation,
//        target matcher: GestureNodeMatcher
//    )
//
//    func gestureNode(
//        _ node: AnyGestureNode,
//        didRemoveRelation relation: GestureRelation,
//        target matcher: GestureNodeMatcher
//    )

    func gestureNode(
        _ node: AnyGestureNode,
        didEnqueuePhaseWithSynchronousUpdate synchronous: Bool
    )

    // func syncPhaseChange(for node: AnyGestureNode)
}

extension GestureNodeCoordinator: GestureNodeListener {
}
