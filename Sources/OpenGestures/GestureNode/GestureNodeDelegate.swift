// MARK: - GestureNodeDelegate

/// Protocol for receiving gesture node state change notifications.
public protocol GestureNodeDelegate<Value>: AnyObject, Sendable {
    associatedtype Value: Sendable

    func gestureNodeShouldActivate(_ node: GestureNode<Value>) -> Bool
    func gestureNode(_ node: GestureNode<Value>, didEnqueuePhase phase: GesturePhase<Value>)
    func gestureNode(_ node: GestureNode<Value>, didUpdatePhase newPhase: GesturePhase<Value>, oldPhase: GesturePhase<Value>)
    func gestureNode(
        _ node: GestureNode<Value>,
        roleForRelationType type: GestureRelationType,
        direction: GestureRelationDirection,
        relatedNode: AnyGestureNode
    ) -> GestureRelationRole?
}

// MARK: - Default implementations

extension GestureNodeDelegate {
    public func gestureNodeShouldActivate(_ node: GestureNode<Value>) -> Bool { true }
    public func gestureNode(_ node: GestureNode<Value>, didEnqueuePhase phase: GesturePhase<Value>) {}
    public func gestureNode(_ node: GestureNode<Value>, didUpdatePhase newPhase: GesturePhase<Value>, oldPhase: GesturePhase<Value>) {}
    public func gestureNode(
        _ node: GestureNode<Value>,
        roleForRelationType type: GestureRelationType,
        direction: GestureRelationDirection,
        relatedNode: AnyGestureNode
    ) -> GestureRelationRole? { nil }
}
