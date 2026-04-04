// MARK: - GestureRelationType

/// The type of relationship between gesture nodes.
public enum GestureRelationType: Hashable, Sendable {
    case exclusion
    case activeExclusion
    case failureRequirement
}

extension GestureRelationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .exclusion: "exclusion"
        case .activeExclusion: "activeExclusion"
        case .failureRequirement: "failureRequirement"
        }
    }
}

// MARK: - GestureRelationRole

/// The role a gesture node plays in a relation.
public enum GestureRelationRole: Hashable, Sendable {
    case regular
    case blocking
}

extension GestureRelationRole: CustomStringConvertible {
    public var description: String {
        switch self {
        case .regular: "regular"
        case .blocking: "blocking"
        }
    }
}

// MARK: - GestureRelationDirection

/// The direction of a gesture relation.
public enum GestureRelationDirection: Hashable, Sendable {
    case outgoing
    case incoming
}
