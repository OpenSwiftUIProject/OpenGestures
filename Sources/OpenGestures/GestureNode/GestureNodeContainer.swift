// MARK: - GestureNodeContainer

/// Protocol for querying node hierarchy in the view tree.
public protocol GestureNodeContainer: AnyObject, Sendable {
    func index(of node: AnyGestureNode) -> Int?
    func isDescendant(of container: any GestureNodeContainer, referenceNode: AnyGestureNode) -> Bool
    func isDeeper(than container: any GestureNodeContainer, referenceNode: AnyGestureNode) -> Bool
}
