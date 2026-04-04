// MARK: - GestureNodeOptions

public struct GestureNodeOptions: OptionSet, Sendable {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let isDisabled = GestureNodeOptions(rawValue: 0x1)
    public static let disallowExclusionWithUnresolvedFailureRequirements = GestureNodeOptions(rawValue: 0x2)
    public static let isGloballyScoped = GestureNodeOptions(rawValue: 0x4)
}
