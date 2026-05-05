//
//  EventStoreTests.swift
//  OpenGesturesTests

@_spi(Private) import OpenGestures
import Testing

// MARK: - EventStoreTests

@Suite
struct EventStoreTests {
    @Test
    func appendKeepsBoundEventsAndUnboundBeganEvents() {
        let store = EventStore<TestEvent>(
            events: [
                TestEvent(id: 4, phase: .ended),
            ],
            boundEventIds: [
                EventID(rawValue: 2),
                EventID(rawValue: 4),
            ]
        )

        store.append([
            TestEvent(id: 1, phase: .active),
            TestEvent(id: 2, phase: .active),
            TestEvent(id: 3, phase: .began),
            TestEvent(id: 4, phase: .failed),
            TestEvent(id: 5, phase: .ended),
        ])

        #expect(store.events.map(\.id) == [EventID(rawValue: 2), EventID(rawValue: 3)])
        #expect(store.boundEventIds == [EventID(rawValue: 2)])
    }

    @Test
    func appendReadsPhaseEvenWhenEventIsAlreadyBound() {
        let tracker = PhaseReadTracker()
        let store = EventStore<PhaseTrackingEvent>(
            boundEventIds: [
                EventID(rawValue: 1),
            ]
        )

        store.append([
            PhaseTrackingEvent(id: 1, phase: .active, tracker: tracker),
        ])

        #expect(tracker.readCount == 1)
        #expect(store.events.map(\.id) == [EventID(rawValue: 1)])
    }

    @Test
    func bindNextUnboundEventReturnsFirstUnboundEventAndBindsIt() {
        let store = EventStore<TestEvent>(
            events: [
                TestEvent(id: 1, phase: .active),
                TestEvent(id: 2, phase: .active),
                TestEvent(id: 3, phase: .active),
            ],
            boundEventIds: [
                EventID(rawValue: 1),
            ]
        )

        let event = store.bindNextUnboundEvent()

        #expect(event?.id == EventID(rawValue: 2))
        #expect(store.boundEventIds == [EventID(rawValue: 1), EventID(rawValue: 2)])
    }

    @Test
    func bindNextUnboundEventReturnsNilWhenAllEventsAreBound() {
        let store = EventStore<TestEvent>(
            events: [
                TestEvent(id: 1, phase: .active),
                TestEvent(id: 2, phase: .active),
            ],
            boundEventIds: [
                EventID(rawValue: 1),
                EventID(rawValue: 2),
            ]
        )

        let event = store.bindNextUnboundEvent()

        #expect(event == nil)
        #expect(store.boundEventIds == [EventID(rawValue: 1), EventID(rawValue: 2)])
    }

    @Test
    func removeUnboundTerminalEventsClearsEventsAndUnbindsTerminalIds() {
        let store = EventStore<TestEvent>(
            events: [
                TestEvent(id: 1, phase: .ended),
                TestEvent(id: 2, phase: .ended),
                TestEvent(id: 3, phase: .failed),
                TestEvent(id: 4, phase: .active),
            ],
            boundEventIds: [
                EventID(rawValue: 2),
                EventID(rawValue: 3),
                EventID(rawValue: 4),
            ]
        )

        store.removeUnboundTerminalEvents()

        #expect(store.events.isEmpty)
        #expect(store.boundEventIds == [EventID(rawValue: 4)])
    }
}

// MARK: - TestEvent

private struct TestEvent: Event {
    let id: EventID
    let phase: EventPhase
    let timestamp: Timestamp

    init(id rawValue: Int, phase: EventPhase) {
        self.id = EventID(rawValue: rawValue)
        self.phase = phase
        timestamp = Timestamp(value: .zero)
    }
}

// MARK: - PhaseTrackingEvent

private final class PhaseReadTracker {
    var readCount = 0
}

private struct PhaseTrackingEvent: Event {
    let id: EventID
    private let storedPhase: EventPhase
    private let tracker: PhaseReadTracker
    let timestamp: Timestamp

    init(id rawValue: Int, phase: EventPhase, tracker: PhaseReadTracker) {
        self.id = EventID(rawValue: rawValue)
        storedPhase = phase
        self.tracker = tracker
        timestamp = Timestamp(value: .zero)
    }

    var phase: EventPhase {
        tracker.readCount += 1
        return storedPhase
    }
}
