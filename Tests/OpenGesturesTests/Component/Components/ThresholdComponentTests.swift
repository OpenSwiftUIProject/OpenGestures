//
//  ThresholdComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenCoreGraphicsShims
import OpenGestures
import Testing

// MARK: - ThresholdComponentTests

@Suite
struct ThresholdComponentTests {
    @Test
    func filtersUntilMovementReachesThreshold() throws {
        var component = ThresholdComponent(
            upstream: ThresholdPointStubComponent(outputs: [
                .value(CGPoint.zero, metadata: nil),
                .value(CGPoint(x: 3, y: 4), metadata: nil),
            ]),
            threshold: { _, _ in 5 }
        )

        let filteredOutput = try component.update(context: thresholdContext())
        let valueOutput = try component.update(context: thresholdContext())

        guard case let .empty(reason, filteredMetadata) = filteredOutput else {
            Issue.record("Expected filtered output")
            return
        }
        #expect(reason == .filtered)
        #expect(filteredMetadata != nil)
        #expect(filteredMetadata?.traceAnnotation == nil)
        #expect(component.state.initialValue == CGPoint.zero)

        guard case let .value(value, valueMetadata) = valueOutput else {
            Issue.record("Expected threshold-adjusted value")
            return
        }
        #expect(value == CGPoint.zero)
        #expect(component.state.adjustmentDelta == CGPoint(x: 3, y: 4))
        #expect(valueMetadata == nil)
    }

    @Test
    func existingAdjustmentDeltaOffsetsValuesAndPreservesFinal() throws {
        var component = ThresholdComponent(
            upstream: ThresholdPointStubComponent(outputs: [
                .finalValue(CGPoint(x: 6, y: 8), metadata: nil),
            ]),
            state: ThresholdComponent<ThresholdPointStubComponent>.State(
                initialValue: CGPoint.zero,
                adjustmentDelta: CGPoint(x: 3, y: 4)
            ),
            threshold: { _, _ in 5 }
        )

        let output = try component.update(context: thresholdContext())

        guard case let .finalValue(value, metadata) = output else {
            Issue.record("Expected final adjusted value")
            return
        }
        #expect(value == CGPoint(x: 3, y: 4))
        #expect(metadata == nil)
    }

    @Test
    func thresholdClosureReceivesCurrentValueBeforeInitialValue() throws {
        var component = ThresholdComponent(
            upstream: ThresholdPointStubComponent(outputs: [
                .value(CGPoint.zero, metadata: nil),
                .value(CGPoint(x: 6, y: 8), metadata: nil),
            ]),
            threshold: { currentValue, initialValue in
                currentValue == CGPoint(x: 6, y: 8) && initialValue == .zero ? 5 : 20
            }
        )

        _ = try component.update(context: thresholdContext())
        let output = try component.update(context: thresholdContext())

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected threshold-adjusted value")
            return
        }
        #expect(value == CGPoint(x: 3, y: 4))
        #expect(metadata == nil)
    }

    @Test
    func finalBeforeThresholdThrows() throws {
        typealias Component = ThresholdComponent<ThresholdPointStubComponent>
        var component = Component(
            upstream: ThresholdPointStubComponent(outputs: [
                .finalValue(CGPoint.zero, metadata: nil),
            ]),
            threshold: { _, _ in 5 }
        )

        do {
            _ = try component.update(context: thresholdContext())
            Issue.record("Expected notEnoughMovement")
        } catch Component.Failure.notEnoughMovement {
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private func thresholdContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct ThresholdPointStubComponent: GestureComponent {
    var outputs: [GestureOutput<CGPoint>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<CGPoint> {
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
