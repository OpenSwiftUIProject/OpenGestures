// MARK: - GestureNodeMatcher

public enum GestureNodeMatcher: Hashable, Sendable {
    case any
    case id(GestureNodeID)
    case tag(GestureTag)
    case traits(GestureTraitCollection, RelativePosition)

    public enum RelativePosition: Hashable, Sendable {
        case any
        case above
        case below
    }
}
