//
//  SeparationDistanceGateTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenCoreGraphicsShims
import OpenGestures
import Testing

// MARK: - SeparationDistanceGateTests

@Suite
struct SeparationDistanceGateTests {
    @Test
    func passesWhenBoundingDistanceIsWithinLimit() throws {
        var component = SeparationDistanceGate(
            upstream: LocationArrayStubComponent(outputs: [
                .value([
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 3, y: 4),
                ], metadata: nil),
            ]),
            distance: 5
        )

        let output = try component.update(context: makeSeparationDistanceGateContext())

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == [CGPoint(x: 0, y: 0), CGPoint(x: 3, y: 4)])
        #expect(metadata == nil)
    }

    @Test
    func throwsWhenBoundingDistanceExceedsLimit() throws {
        var component = SeparationDistanceGate(
            upstream: LocationArrayStubComponent(outputs: [
                .value([
                    CGPoint(x: -3, y: -4),
                    CGPoint(x: 3, y: 4),
                ], metadata: nil),
            ]),
            distance: 9
        )

        do {
            _ = try component.update(context: makeSeparationDistanceGateContext())
            Issue.record("Expected exceedsAllowedDistance")
        } catch SeparationDistanceGate<LocationArrayStubComponent>.Failure.exceedsAllowedDistance {
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func greatestFiniteDistanceDisablesTheGate() throws {
        var component = SeparationDistanceGate(
            upstream: LocationArrayStubComponent(outputs: [
                .finalValue([
                    CGPoint(x: -1_000, y: -1_000),
                    CGPoint(x: 1_000, y: 1_000),
                ], metadata: nil),
            ]),
            distance: .greatestFiniteMagnitude
        )

        let output = try component.update(context: makeSeparationDistanceGateContext())

        guard case let .finalValue(value, metadata) = output else {
            Issue.record("Expected final value output")
            return
        }
        #expect(value.count == 2)
        #expect(metadata == nil)
    }
}

private func makeSeparationDistanceGateContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct LocationArrayStubComponent: GestureComponent {
    var outputs: [GestureOutput<[CGPoint]>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<[CGPoint]> {
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
