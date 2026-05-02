//
//  GestureComponent.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureComponent

/// A protocol for gesture recognition components.
public protocol GestureComponent: Sendable {
    associatedtype Value: Sendable
    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value>
    mutating func reset()
    func traits() -> GestureTraitCollection?
    func capacity<E: Event>(for eventType: E.Type) -> Int
}

// MARK: - GestureComponent + Tracing

extension GestureComponent {
    package mutating func tracingUpdate(context: GestureComponentContext) throws -> GestureOutput<Value> {
        try update(context: context)
    }
}

// MARK: - GestureComponentContext

/// Context passed to gesture components during update cycles.
public struct GestureComponentContext: @unchecked Sendable {
    public var startTime: Timestamp
    public var currentTime: Timestamp
    package var updateSource: GestureUpdateSource
    package var updateTracer: UpdateTracer?
    package var eventStore: AnyEventStore

    public var durationSinceStart: Duration {
        startTime.duration(to: currentTime)
    }
}

// MARK: - GestureUpdateSource

/// Source that caused a gesture component update cycle.
package enum GestureUpdateSource: Equatable, Sendable {
    /// Scheduler-driven update carrying the scheduled request identifiers.
    case scheduler(Set<UInt32>)

    /// Event-driven update.
    case event
}
