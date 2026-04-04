// MARK: - GestureTraitID

public struct GestureTraitID: Hashable, Sendable {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let tap = GestureTraitID(rawValue: 0)
    public static let longPress = GestureTraitID(rawValue: 1)
    public static let pan = GestureTraitID(rawValue: 2)
}
