// MARK: - GestureRelation

public struct GestureRelation: Sendable {
    public var type: GestureRelationType
    public var direction: GestureRelationDirection
    public var role: GestureRelationRole?
    public var target: GestureNodeMatcher

    public init(
        type: GestureRelationType,
        direction: GestureRelationDirection,
        role: GestureRelationRole? = nil,
        target: GestureNodeMatcher
    ) {
        self.type = type
        self.direction = direction
        self.role = role
        self.target = target
    }
}
