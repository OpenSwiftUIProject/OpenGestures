// MARK: - GestureNodeID

/// A unique identifier for a gesture node.
public struct GestureNodeID: Hashable, Comparable, Sendable, CustomStringConvertible {
    public var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static func < (lhs: GestureNodeID, rhs: GestureNodeID) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var description: String {
        "GestureNodeID(\(rawValue))"
    }
}
