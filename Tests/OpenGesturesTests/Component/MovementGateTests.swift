//
//  MovementGateTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - MovementGateTests

@Suite
struct MovementGateTests {
    @Test
    func minRestrictionFiltersUntilMovementReachesBound() throws {
        var component = MovementGate(
            upstream: TrackedStubComponent(outputs: [
                .value(tracked(current: CGPoint(x: 3, y: 4)), metadata: nil),
                .finalValue(tracked(current: CGPoint(x: 6, y: 8)), metadata: nil),
            ]),
            bound: 6,
            restriction: .min
        )

        let filteredOutput = try component.update(context: makeMovementGateContext())
        let finalOutput = try component.update(context: makeMovementGateContext())

        guard case let .empty(reason, filteredMetadata) = filteredOutput else {
            Issue.record("Expected filtered output")
            return
        }
        #expect(reason == .filtered)
        #expect(filteredMetadata?.traceAnnotation?.value == "not enough movement")

        guard case let .finalValue(finalValue, finalMetadata) = finalOutput else {
            Issue.record("Expected final value output")
            return
        }
        #expect(finalValue.current == CGPoint(x: 6, y: 8))
        #expect(finalMetadata == nil)
    }

    @Test
    func maxRestrictionThrowsWhenMovementExceedsBound() throws {
        typealias Gate = MovementGate<TrackedStubComponent, CGPoint>

        var component = Gate(
            upstream: TrackedStubComponent(outputs: [
                .value(tracked(current: CGPoint(x: 3, y: 4)), metadata: nil),
                .value(tracked(current: CGPoint(x: 6, y: 0)), metadata: nil),
            ]),
            bound: 5,
            restriction: .max
        )

        let valueOutput = try component.update(context: makeMovementGateContext())
        guard case let .value(value, valueMetadata) = valueOutput else {
            Issue.record("Expected value output")
            return
        }
        #expect(value.current == CGPoint(x: 3, y: 4))
        #expect(valueMetadata == nil)

        do {
            _ = try component.update(context: makeMovementGateContext())
            Issue.record("Expected tooMuchMovement")
        } catch Gate.Failure.tooMuchMovement {
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private func tracked(
    current: CGPoint,
    initial: CGPoint = .zero,
    previous: CGPoint? = nil
) -> TrackedValue<CGPoint> {
    TrackedValue(current: current, previous: previous, initial: initial)
}

private func makeMovementGateContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct TrackedStubComponent: GestureComponent {
    var outputs: [GestureOutput<TrackedValue<CGPoint>>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<TrackedValue<CGPoint>> {
        outputs.removeFirst()
    }

    mutating func reset() {
        outputs.removeAll()
    }

    func traits() -> GestureTraitCollection? {
        nil
    }

    func capacity<E: Event>(for eventType: E.Type) -> Int {
        0
    }
}
