public import OpenCoreGraphicsShims

// MARK: - PanComponent

/// A gesture component that recognizes pan (drag) gestures.
public struct PanComponent<Upstream: GestureComponent>: Sendable where Upstream: Sendable {
    public var hysteresis: Double
    public var maximumSeparationDistance: Double
    public var pointCountTimeout: Duration
    public var minimumPointCount: Int
    public var maximumPointCount: Int
    public var failOnExceedingMaximumPointCount: Bool
    public var invertScrollingDirection: Bool
    public var preferNonAcceleratedScrollingDelta: Bool
    public var ignoreStationaryPoints: Bool
    public var upstream: Upstream
}

// MARK: - CompositeGestureComponent

extension PanComponent: CompositeGestureComponent {
    public typealias Value = Upstream.Value

    public func traits() -> GestureTraitCollection? {
        .withTrait(.pan())
    }

    public func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        // TODO: Full pan recognition (hysteresis, translation, velocity)
        try upstream.update(context: context)
    }

    public mutating func reset() {
        upstream.reset()
    }
}

// MARK: - PanComponentValue

/// Value produced by a pan gesture, including location, translation, and velocity.
public struct PanComponentValue: Sendable {
    public var location: CGPoint
    public var translation: CGVector
    public var velocity: CGVector
    public var predictedEndLocation: CGPoint
    public var predictedEndTranslation: CGVector

    public init(
        location: CGPoint,
        translation: CGVector,
        velocity: CGVector,
        predictedEndLocation: CGPoint,
        predictedEndTranslation: CGVector
    ) {
        self.location = location
        self.translation = translation
        self.velocity = velocity
        self.predictedEndLocation = predictedEndLocation
        self.predictedEndTranslation = predictedEndTranslation
    }
}
