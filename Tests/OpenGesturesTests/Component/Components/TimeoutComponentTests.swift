//
//  TimeoutComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - TimeoutComponentTests

@Suite
struct TimeoutComponentTests {
    @Test
    func attachesExpirationUntilPredicateIsFulfilled() throws {
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            timeout: .seconds(2),
            tag: "timeout",
            predicate: { _ in false }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .value(record, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        guard case let .value(value) = record.payload else {
            Issue.record("Expected value payload")
            return
        }
        #expect(value == 7)
        #expect(metadata == nil)
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(2)))
        #expect(record.expiration?.reason.description == "timeout")
        #expect(component.state.fulfilled == false)
    }

    @Test
    func fulfilledPredicateClearsExpiration() throws {
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .finalValue(7, metadata: nil),
            ]),
            timeout: .seconds(2),
            tag: "timeout",
            predicate: { $0.isFinal }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .finalValue(record, metadata) = output else {
            Issue.record("Expected final value output")
            return
        }
        #expect(record.expiration == nil)
        #expect(metadata == nil)
        #expect(component.state.fulfilled == true)
    }

    @Test
    func noDataEmptyOutputBypassesExpirationAndPredicate() throws {
        let probe = PredicateProbe(result: true)
        let metadata = GestureOutputMetadata(
            traceAnnotation: UpdateTraceAnnotation(value: "no event")
        )
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .empty(.noData, metadata: metadata),
            ]),
            timeout: .seconds(2),
            tag: "timeout",
            predicate: { probe.call($0) }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .empty(reason, outputMetadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .noData)
        #expect(outputMetadata?.traceAnnotation?.value == "no event")
        #expect(probe.callCount == 0)
        #expect(component.state.fulfilled == false)
    }

    @Test
    func predicateIsSkippedOnceCurrentTimeReachesDeadline() throws {
        let probe = PredicateProbe(result: true)
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            timeout: .seconds(2),
            tag: "timeout",
            predicate: { probe.call($0) }
        )

        let output = try component.update(
            context: timeoutComponentContext(currentTime: .seconds(2))
        )

        guard case let .value(record, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(record.expiration?.deadline == Timestamp(value: .seconds(2)))
        #expect(probe.callCount == 0)
        #expect(component.state.fulfilled == false)
    }

    @Test
    func zeroTimeoutStillProducesImmediateExpiration() throws {
        let probe = PredicateProbe(result: true)
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            timeout: .zero,
            tag: "timeout",
            predicate: { probe.call($0) }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .value(record, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(record.expiration?.deadline == Timestamp(value: .zero))
        #expect(record.expiration?.reason.description == "timeout")
        #expect(probe.callCount == 0)
        #expect(component.state.fulfilled == false)
    }

    @Test
    func maxTimeoutSuppressesExpirationAndPredicate() throws {
        let probe = PredicateProbe(result: true)
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            timeout: .max,
            tag: "timeout",
            predicate: { probe.call($0) }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .value(record, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(record.expiration == nil)
        #expect(probe.callCount == 0)
        #expect(component.state.fulfilled == false)
    }

    @Test
    func fulfilledStateSuppressesExpirationAndPredicate() throws {
        let probe = PredicateProbe(result: true)
        var component = TimeoutComponent(
            upstream: TimeoutStubComponent(outputs: [
                .value(7, metadata: nil),
            ]),
            state: .init(fulfilled: true),
            timeout: .seconds(2),
            tag: "timeout",
            predicate: { probe.call($0) }
        )

        let output = try component.update(context: timeoutComponentContext())

        guard case let .value(record, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(record.expiration == nil)
        #expect(probe.callCount == 0)
        #expect(component.state.fulfilled == true)
    }
}

private func timeoutComponentContext(
    startTime: Duration = .zero,
    currentTime: Duration = .zero
) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: startTime),
        currentTime: Timestamp(value: currentTime),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private final class PredicateProbe: @unchecked Sendable {
    var callCount = 0
    var result: Bool

    init(result: Bool) {
        self.result = result
    }

    func call(_ output: GestureOutput<Int>) -> Bool {
        callCount += 1
        return result
    }
}

private struct TimeoutStubComponent: GestureComponent {
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
