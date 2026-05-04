//
//  ValueTransformingComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - ValueTransformingComponentTests

@Suite
struct ValueTransformingComponentTests {
    @Test
    func defaultUpdatePreservesEmptyOutput() throws {
        let metadata = GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "empty"))
        var component = DiscreteGate(
            upstream: StubComponent(outputs: [
                .empty(.filtered, metadata: metadata),
            ])
        )

        let output = try component.update(context: makeContext())

        guard case let .empty(reason, outputMetadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(outputMetadata?.traceAnnotation?.value == "empty")
    }

    @Test
    func discreteGateFiltersValueAndPassesFinalValue() throws {
        var component = DiscreteGate(
            upstream: StubComponent(outputs: [
                .value(
                    3,
                    metadata: GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "value"))
                ),
                .finalValue(
                    5,
                    metadata: GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "final"))
                ),
            ])
        )

        let valueOutput = try component.update(context: makeContext())
        let finalOutput = try component.update(context: makeContext())

        guard case let .empty(reason, valueMetadata) = valueOutput else {
            Issue.record("Expected filtered empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(valueMetadata?.traceAnnotation?.value == "not final event")

        guard case let .finalValue(finalValue, finalMetadata) = finalOutput else {
            Issue.record("Expected final value output")
            return
        }
        #expect(finalValue == 5)
        #expect(finalMetadata == nil)
    }

    @Test
    func valueTrackerTransformsUpstreamValues() throws {
        var component = ValueTracker(
            upstream: StubComponent(outputs: [
                .value(2, metadata: nil),
                .value(5, metadata: nil),
                .finalValue(7, metadata: nil),
            ]),
            valueReader: { $0 * 10 }
        )

        let firstOutput = try component.update(context: makeContext())
        let secondOutput = try component.update(context: makeContext())
        let finalOutput = try component.update(context: makeContext())

        guard case let .value(first, firstMetadata) = firstOutput else {
            Issue.record("Expected first value output")
            return
        }
        #expect(first.current == 20)
        #expect(first.previous == 20)
        #expect(first.initial == 20)
        #expect(firstMetadata == nil)

        guard case let .value(second, secondMetadata) = secondOutput else {
            Issue.record("Expected second value output")
            return
        }
        #expect(second.current == 50)
        #expect(second.previous == 20)
        #expect(second.initial == 20)
        #expect(secondMetadata == nil)

        guard case let .finalValue(final, finalMetadata) = finalOutput else {
            Issue.record("Expected final value output")
            return
        }
        #expect(final.current == 70)
        #expect(final.previous == 50)
        #expect(final.initial == 20)
        #expect(finalMetadata == nil)
    }
}

private func makeContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct StubComponent: GestureComponent {
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
