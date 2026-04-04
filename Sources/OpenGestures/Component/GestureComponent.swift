// MARK: - GestureComponent

/// A protocol for gesture recognition components.
public protocol GestureComponent: Sendable {
    associatedtype Value: Sendable

    func update(context: GestureComponentContext) throws -> GestureOutput<Value>
    mutating func reset()
    func traits() -> GestureTraitCollection?
    func capacity<E: Event>(for eventType: E.Type) -> Int
}

// MARK: - Default capacity

extension GestureComponent {
    public func capacity<E: Event>(for eventType: E.Type) -> Int { 1 }
}

// MARK: - StatefulGestureComponent

/// A gesture component that maintains mutable state across updates.
public protocol StatefulGestureComponent: GestureComponent {
    associatedtype State: GestureComponentState
    var state: State { get set }
}

extension StatefulGestureComponent {
    public mutating func reset() {
        state = State()
    }
}

// MARK: - CompositeGestureComponent

/// A gesture component that wraps an upstream component, enabling chaining.
public protocol CompositeGestureComponent: GestureComponent {
    associatedtype Upstream: GestureComponent
    var upstream: Upstream { get set }
}

extension CompositeGestureComponent {
    /// Default: delegates to upstream.update(context:)
    public func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        fatalError("CompositeGestureComponent subtype must override update(context:)")
    }

    public mutating func reset() {
        upstream.reset()
    }

    public func traits() -> GestureTraitCollection? {
        upstream.traits()
    }
}

// MARK: - GestureComponentContext

/// Context passed to gesture components during update cycles.
public struct GestureComponentContext: Sendable {
    public var startTime: Timestamp
    public var currentTime: Timestamp

    public var durationSinceStart: Duration {
        startTime.duration(to: currentTime)
    }

    public init(startTime: Timestamp, currentTime: Timestamp) {
        self.startTime = startTime
        self.currentTime = currentTime
    }
}

// MARK: - GestureComponentState

public protocol GestureComponentState: Sendable {
    init()
}
