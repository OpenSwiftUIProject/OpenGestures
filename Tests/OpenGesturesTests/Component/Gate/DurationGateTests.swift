//
//  DurationGateTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - DurationGateTests

@Suite
struct DurationGateTests {
    @Test
    func filtersNonFinalValuesUntilMinimumDurationIsReached() throws {
        var component = DurationGate(
            upstream: IntStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            minimumDuration: .seconds(2),
            maximumDuration: .seconds(10)
        )

        let output = try component.update(
            context: makeDurationGateContext(currentTime: .seconds(1))
        )

        guard case let .value(record, metadata) = output else {
            Issue.record("Expected wrapped value output")
            return
        }
        guard case let .empty(reason) = record.payload else {
            Issue.record("Expected empty payload")
            return
        }
        #expect(reason == .filtered)
        #expect(metadata != nil)
        #expect(metadata?.traceAnnotation == nil)
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(2)))
        #expect(record.expiration?.reason.description == "min duration expired")
    }

    @Test
    func finalValueBeforeMinimumDurationThrows() throws {
        var component = DurationGate(
            upstream: IntStubComponent(outputs: [
                .finalValue(7, metadata: nil),
            ]),
            minimumDuration: .seconds(2),
            maximumDuration: .seconds(10)
        )

        do {
            _ = try component.update(
                context: makeDurationGateContext(currentTime: .seconds(1))
            )
            Issue.record("Expected minimumDurationNotReached")
        } catch DurationGate<IntStubComponent>.Failure.minimumDurationNotReached {
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func valuesAfterMinimumDurationCarryMaximumExpiration() throws {
        var component = DurationGate(
            upstream: IntStubComponent(outputs: [
                .finalValue(9, metadata: nil),
            ]),
            minimumDuration: .seconds(2),
            maximumDuration: .seconds(10)
        )

        let output = try component.update(
            context: makeDurationGateContext(
                startTime: .seconds(3),
                currentTime: .seconds(6)
            )
        )

        guard case let .finalValue(record, metadata) = output else {
            Issue.record("Expected wrapped final value")
            return
        }
        guard case let .value(value) = record.payload else {
            Issue.record("Expected value payload")
            return
        }
        #expect(value == 9)
        #expect(metadata == nil)
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(13)))
        #expect(record.expiration?.reason.description == "max duration expired")
    }
}

private func makeDurationGateContext(
    startTime: Duration = .zero,
    currentTime: Duration
) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: startTime),
        currentTime: Timestamp(value: currentTime),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct IntStubComponent: GestureComponent {
    var outputs: [GestureOutput<Int>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
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
