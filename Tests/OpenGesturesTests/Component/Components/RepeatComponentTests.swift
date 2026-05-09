//
//  RepeatComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - RepeatComponentTests

@Suite
struct RepeatComponentTests {
    @Test
    func finalValueBeforeRequiredCountProducesRepeatExpiration() throws {
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .finalValue(7, metadata: nil),
            ]),
            count: 2,
            delay: .seconds(1)
        )

        let output = try component.update(
            context: repeatComponentContext(currentTime: .seconds(3))
        )

        guard case let .value(record, metadata) = output else {
            Issue.record("Expected repeat value output")
            return
        }
        guard case let .value(value) = record.payload else {
            Issue.record("Expected value repeat payload")
            return
        }
        #expect(value == 7)
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(4)))
        #expect(record.expiration?.reason.description == "Repeat deadline expired")
        #expect(component.state.currentCount == 1)
        #expect(component.state.repeatDeadline == Timestamp(value: .seconds(4)))
        #expect(component.state.repeatStartTime == nil)
        #expect(component.upstream.resetCount == 1)
        #expect(metadata != nil)
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func finalValueAtRequiredCountCompletes() throws {
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .finalValue(7, metadata: nil),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 1,
                repeatDeadline: Timestamp(value: .seconds(4)),
                repeatStartTime: Timestamp(value: .seconds(3))
            ),
            count: 2,
            delay: .seconds(1)
        )

        let output = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        guard case let .finalValue(record, metadata) = output else {
            Issue.record("Expected final repeat output")
            return
        }
        guard case let .value(value) = record.payload else {
            Issue.record("Expected value payload")
            return
        }
        #expect(value == 7)
        #expect(record.expiration == nil)
        #expect(component.state.currentCount == 2)
        #expect(component.state.repeatDeadline == Timestamp(value: .seconds(4)))
        #expect(component.state.repeatStartTime == Timestamp(value: .seconds(3)))
        #expect(metadata != nil)
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func emptyOutputPassesThroughWithoutExpirationRecord() throws {
        let metadata = GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "empty"))
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .empty(.filtered, metadata: metadata),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 1,
                repeatDeadline: Timestamp(value: .seconds(5)),
                repeatStartTime: Timestamp(value: .seconds(3))
            ),
            count: 2,
            delay: .seconds(1)
        )

        let output = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        guard case let .empty(reason, outputMetadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(outputMetadata?.traceAnnotation?.value == "empty")
    }

    @Test
    func nonFinalValueCarriesRepeatExpiration() throws {
        let metadata = GestureOutputMetadata(traceAnnotation: UpdateTraceAnnotation(value: "value"))
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .value(9, metadata: metadata),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 1,
                repeatDeadline: Timestamp(value: .seconds(5)),
                repeatStartTime: Timestamp(value: .seconds(3))
            ),
            count: 2,
            delay: .seconds(1)
        )

        let output = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        guard case let .value(record, outputMetadata) = output else {
            Issue.record("Expected value output")
            return
        }
        guard case let .value(value) = record.payload else {
            Issue.record("Expected value payload")
            return
        }
        #expect(value == 9)
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(5)))
        #expect(outputMetadata != nil)
        #expect(outputMetadata?.traceAnnotation == nil)
        #expect(component.upstream.contexts.first?.startTime == Timestamp(value: .seconds(3)))
    }

    @Test
    func nonFinalValueUsesRepeatDeadlineWhenPresent() throws {
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .value(9, metadata: nil),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 0,
                repeatDeadline: Timestamp(value: .seconds(5)),
                repeatStartTime: nil
            ),
            count: 2,
            delay: .seconds(1)
        )

        let output = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        guard case let .value(record, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(5)))
        #expect(record.expiration?.reason.description == "Repeat deadline expired")
        #expect(metadata != nil)
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func existingRepeatStartTimeAdjustsContextWhenCurrentCountIsZero() throws {
        let repeatStartTime = Timestamp(value: .seconds(2))
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .value(9, metadata: nil),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 0,
                repeatDeadline: nil,
                repeatStartTime: repeatStartTime
            ),
            count: 2,
            delay: .seconds(1)
        )

        _ = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        #expect(component.state.repeatStartTime == repeatStartTime)
        #expect(component.upstream.contexts.first?.startTime == repeatStartTime)
    }

    @Test
    func firstEventAfterRepeatCapturesRepeatStartTime() throws {
        var component = RepeatComponent(
            upstream: RepeatStubComponent(outputs: [
                .value(9, metadata: nil),
            ]),
            state: RepeatComponent<RepeatStubComponent>.State(
                currentCount: 1,
                repeatDeadline: Timestamp(value: .seconds(5)),
                repeatStartTime: nil
            ),
            count: 2,
            delay: .seconds(1)
        )

        _ = try component.update(
            context: repeatComponentContext(currentTime: .seconds(4))
        )

        #expect(component.state.repeatStartTime == Timestamp(value: .seconds(4)))
        #expect(component.upstream.contexts.first?.startTime == Timestamp(value: .seconds(4)))
    }
}

private func repeatComponentContext(currentTime: Duration) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: currentTime),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct RepeatStubComponent: GestureComponent {
    var outputs: [GestureOutput<Int>]
    var contexts: [GestureComponentContext] = []
    var resetCount = 0

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
        contexts.append(context)
        return outputs.removeFirst()
    }

    mutating func reset() {
        resetCount += 1
    }

    func traits() -> GestureTraitCollection? {
        nil
    }

    func capacity<E: Event>(for eventType: E.Type) -> Int {
        0
    }
}
