//
//  ReduceComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - ReduceComponentTests

@Suite
struct ReduceComponentTests {
    @Test
    func accumulatesValuesAndStoresState() throws {
        var component = ReduceComponent(
            upstream: ReduceStubComponent(outputs: [
                .value(2, metadata: nil),
                .finalValue(3, metadata: nil),
            ]),
            initial: 10,
            reduce: { accumulator, value in accumulator + value }
        )

        let firstOutput = try component.update(context: reduceContext())
        let finalOutput = try component.update(context: reduceContext())

        guard case let .value(firstValue, firstMetadata) = firstOutput else {
            Issue.record("Expected first reduced value")
            return
        }
        #expect(firstValue == 12)
        #expect(firstMetadata == nil)
        #expect(component.state.accumulator == 15)

        guard case let .finalValue(finalValue, finalMetadata) = finalOutput else {
            Issue.record("Expected final reduced value")
            return
        }
        #expect(finalValue == 15)
        #expect(finalMetadata == nil)
        #expect(component.state.accumulator == 15)
    }

    @Test
    func emptyOutputPassesThroughWithoutReducing() throws {
        let metadata = GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "empty"))
        var component = ReduceComponent(
            upstream: ReduceStubComponent(outputs: [
                .empty(.filtered, metadata: metadata),
            ]),
            initial: 10,
            reduce: { _, _ in
                throw ReduceTestError.unexpectedReduce
            }
        )

        let output = try component.update(context: reduceContext())

        guard case let .empty(reason, outputMetadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(outputMetadata?.traceAnnotation?.value == "empty")
        #expect(component.state.accumulator == nil)
    }

    @Test
    func throwingReduceDoesNotStoreAccumulator() throws {
        var component = ReduceComponent(
            upstream: ReduceStubComponent(outputs: [
                .value(2, metadata: nil),
            ]),
            initial: 10,
            reduce: { _, _ in
                throw ReduceTestError.unexpectedReduce
            }
        )

        #expect(throws: ReduceTestError.unexpectedReduce) {
            try component.update(context: reduceContext())
        }
        #expect(component.state.accumulator == nil)
    }
}

private enum ReduceTestError: Error {
    case unexpectedReduce
}

private func reduceContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct ReduceStubComponent: GestureComponent {
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
