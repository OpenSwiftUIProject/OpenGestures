//
//  EventSourceTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenCoreGraphicsShims
import OpenGestures
import Testing

// MARK: - EventSourceTests

@Suite
struct EventSourceTests {
    @Test
    func bindsNextUnboundBeganEvent() throws {
        let store = EventStore<TouchEvent>()
        store.append([
            touch(id: 1, phase: .began, time: .zero),
        ])
        var source = EventSource<TouchEvent>()

        let output = try source.update(context: eventSourceContext(store: store))

        guard case let .value(event, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(event.id == EventID(rawValue: 1))
        #expect(metadata == nil)
        #expect(source.state.trackedId == EventID(rawValue: 1))
        #expect(store.boundEventIds == [EventID(rawValue: 1)])
    }

    @Test
    func endedTrackedEventProducesFinalValueAndPreservesState() throws {
        let store = EventStore<TouchEvent>(
            events: [
                touch(id: 1, phase: .ended, time: .milliseconds(100)),
            ],
            boundEventIds: [EventID(rawValue: 1)]
        )
        var source = EventSource<TouchEvent>(
            state: EventSource<TouchEvent>.State(trackedId: EventID(rawValue: 1))
        )

        let output = try source.update(context: eventSourceContext(store: store))

        guard case let .finalValue(event, metadata) = output else {
            Issue.record("Expected final value output")
            return
        }
        #expect(event.phase == .ended)
        #expect(metadata == nil)
        #expect(source.state.trackedId == EventID(rawValue: 1))
    }

    @Test
    func failedTrackedEventThrowsAndPreservesState() throws {
        let store = EventStore<TouchEvent>(
            events: [
                touch(id: 1, phase: .failed, time: .milliseconds(100)),
            ],
            boundEventIds: [EventID(rawValue: 1)]
        )
        var source = EventSource<TouchEvent>(
            state: EventSource<TouchEvent>.State(trackedId: EventID(rawValue: 1))
        )

        do {
            _ = try source.update(context: eventSourceContext(store: store))
            Issue.record("Expected eventFailed")
        } catch EventSource<TouchEvent>.Failure.eventFailed {
            #expect(source.state.trackedId == EventID(rawValue: 1))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func schedulerUpdateProducesTimeUpdateWithoutBinding() throws {
        let store = EventStore<TouchEvent>()
        store.append([
            touch(id: 1, phase: .began, time: .zero),
        ])
        var source = EventSource<TouchEvent>()

        let output = try source.update(
            context: eventSourceContext(
                store: store,
                updateSource: .scheduler([1])
            )
        )

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .timeUpdate)
        #expect(metadata == nil)
        #expect(source.state.trackedId == nil)
        #expect(store.boundEventIds == [])
    }

    @Test
    func mismatchedEventStoreProducesNoEventTrace() throws {
        var source = EventSource<TouchEvent>()

        let output = try source.update(
            context: eventSourceContext(store: EventStore<Never>())
        )

        expectEmpty(output, reason: .noData, traceAnnotation: "no event")
        #expect(source.state.trackedId == nil)
    }

    @Test
    func noUnboundEventsProducesNoUnboundEventsTrace() throws {
        let store = EventStore<TouchEvent>()
        var source = EventSource<TouchEvent>()

        let output = try source.update(context: eventSourceContext(store: store))

        expectEmpty(output, reason: .noData, traceAnnotation: "no unbound events")
        #expect(source.state.trackedId == nil)
    }

    @Test
    func missingTrackedEventProducesAlreadyBoundTraceWithoutBindingAnotherEvent() throws {
        let store = EventStore<TouchEvent>()
        store.append([
            touch(id: 2, phase: .began, time: .zero),
        ])
        var source = EventSource<TouchEvent>(
            state: EventSource<TouchEvent>.State(trackedId: EventID(rawValue: 1))
        )

        let output = try source.update(context: eventSourceContext(store: store))

        expectEmpty(output, reason: .noData, traceAnnotation: "source is already bound")
        #expect(source.state.trackedId == EventID(rawValue: 1))
        #expect(store.boundEventIds == [])
    }

    @Test
    func capacityIsOneForMatchingEventTypeOnlyWhenUnbound() {
        let unboundSource = EventSource<TouchEvent>()
        let boundSource = EventSource<TouchEvent>(
            state: EventSource<TouchEvent>.State(trackedId: EventID(rawValue: 1))
        )

        #expect(unboundSource.capacity(for: TouchEvent.self) == 1)
        #expect(unboundSource.capacity(for: MouseEvent.self) == 0)
        #expect(boundSource.capacity(for: TouchEvent.self) == 0)
    }
}

private func eventSourceContext(
    store: AnyEventStore,
    updateSource: GestureUpdateSource = .event
) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: updateSource,
        eventStore: store
    )
}

private func expectEmpty<Value>(
    _ output: GestureOutput<Value>,
    reason expectedReason: GestureOutputEmptyReason,
    traceAnnotation expectedTraceAnnotation: String
) {
    guard case let .empty(reason, metadata) = output else {
        Issue.record("Expected empty output")
        return
    }
    #expect(reason == expectedReason)
    #expect(metadata?.updatesToSchedule.isEmpty == true)
    #expect(metadata?.updatesToCancel.isEmpty == true)
    #expect(metadata?.traceAnnotation?.value == expectedTraceAnnotation)
}

private func touch(
    id rawValue: Int,
    phase: EventPhase,
    time: Duration
) -> TouchEvent {
    TouchEvent(
        id: EventID(rawValue: rawValue),
        phase: phase,
        timestamp: Timestamp(value: time),
        location: CGPoint(x: rawValue, y: rawValue)
    )
}
