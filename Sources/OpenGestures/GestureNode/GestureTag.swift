// MARK: - GestureTag

public struct GestureTag: Hashable, Sendable, ExpressibleByStringLiteral, RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}
