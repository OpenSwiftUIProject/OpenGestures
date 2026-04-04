// MARK: - GestureTrait

/// A gesture trait describing the characteristics of a gesture.
public struct GestureTrait: Hashable, Sendable {
    public var id: GestureTraitID
    public var attributes: [AttributeKey: AttributeValue]

    public init(id: GestureTraitID, attributes: [AttributeKey: AttributeValue] = [:]) {
        self.id = id
        self.attributes = attributes
    }

    // MARK: - Factory Methods

    /// Creates a tap gesture trait with optional tap count and point count.
    public static func tap(tapCount: Int? = nil, pointCount: Int? = nil) -> GestureTrait {
        var attrs: [AttributeKey: AttributeValue] = [:]
        if let tapCount { attrs[.tapCount] = .int(tapCount) }
        if let pointCount { attrs[.pointCount] = .int(pointCount) }
        return GestureTrait(id: .tap, attributes: attrs)
    }

    /// Creates a long press gesture trait with optional parameters.
    public static func longPress(
        pointCount: Int? = nil,
        minimumDuration: Duration? = nil,
        maximumMovement: Double? = nil
    ) -> GestureTrait {
        var attrs: [AttributeKey: AttributeValue] = [:]
        if let pointCount { attrs[.pointCount] = .int(pointCount) }
        if let minimumDuration { attrs[.minimumDuration] = .duration(minimumDuration) }
        if let maximumMovement { attrs[.maximumMovement] = .double(maximumMovement) }
        return GestureTrait(id: .longPress, attributes: attrs)
    }

    /// Creates a pan gesture trait.
    public static func pan() -> GestureTrait {
        GestureTrait(id: .pan, attributes: [:])
    }

    // MARK: - AttributeKey

    /// Keys for gesture trait attributes.
    public struct AttributeKey: Hashable, Sendable {
        public var rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let pointCount = AttributeKey(rawValue: 0)
        public static let tapCount = AttributeKey(rawValue: 1)
        public static let minimumDuration = AttributeKey(rawValue: 2)
        public static let maximumMovement = AttributeKey(rawValue: 3)
    }

    // MARK: - AttributeValue

    public enum AttributeValue: Hashable, Sendable {
        case int(Int)
        case double(Double)
        case duration(Duration)
    }
}
