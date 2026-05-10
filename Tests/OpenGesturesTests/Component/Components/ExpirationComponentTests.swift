//
//  ExpirationComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - ExpirationComponentTests

@Suite
struct ExpirationComponentTests {
    @Test
    func schedulesExpirationAndUnwrapsValuePayload() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    expirationRecord(
                        value: 7,
                        deadline: .seconds(5),
                        reason: "timeout"
                    ),
                    metadata: nil
                ),
            ])
        )

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 7)

        guard let metadata, let request = metadata.updatesToSchedule.first else {
            Issue.record("Expected scheduled request metadata")
            return
        }
        #expect(metadata.updatesToSchedule.count == 1)
        #expect(metadata.updatesToCancel.isEmpty)
        #expect(request.creationTime == Timestamp(value: .seconds(2)))
        #expect(request.targetTime == Timestamp(value: .seconds(5)))
        #expect(request.tag == "timeout")
        #expect(component.state.request == request)
    }

    @Test
    func reschedulesWhenExpirationDeadlineChanges() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    expirationRecord(
                        value: 7,
                        deadline: .seconds(5),
                        reason: "first"
                    ),
                    metadata: nil
                ),
                .value(
                    expirationRecord(
                        value: 8,
                        deadline: .seconds(7),
                        reason: "second"
                    ),
                    metadata: nil
                ),
            ])
        )

        _ = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )
        guard let firstRequest = component.state.request else {
            Issue.record("Expected first request")
            return
        }

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(3))
        )

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 8)

        guard let metadata, let scheduledRequest = metadata.updatesToSchedule.first else {
            Issue.record("Expected reschedule metadata")
            return
        }
        #expect(metadata.updatesToSchedule.count == 1)
        #expect(metadata.updatesToCancel == [firstRequest])
        #expect(scheduledRequest.targetTime == Timestamp(value: .seconds(7)))
        #expect(component.state.request == scheduledRequest)
    }

    @Test
    func unchangedExpirationDeadlineDoesNotReschedule() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    expirationRecord(
                        value: 7,
                        deadline: .seconds(5),
                        reason: "first"
                    ),
                    metadata: nil
                ),
                .value(
                    expirationRecord(
                        value: 8,
                        deadline: .seconds(5),
                        reason: "second"
                    ),
                    metadata: nil
                ),
            ])
        )

        _ = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )
        let firstRequest = component.state.request

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(3))
        )

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 8)
        guard let metadata else {
            Issue.record("Expected empty metadata")
            return
        }
        #expect(metadata.updatesToSchedule.isEmpty)
        #expect(metadata.updatesToCancel.isEmpty)
        #expect(component.state.request == firstRequest)
    }

    @Test
    func nilExpirationWithoutStoredRequestReturnsEmptyMetadata() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    ExpirationRecord(
                        payload: .value(7),
                        expiration: nil
                    ),
                    metadata: nil
                ),
            ])
        )

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 7)

        guard let metadata else {
            Issue.record("Expected empty metadata")
            return
        }
        #expect(metadata.updatesToSchedule.isEmpty)
        #expect(metadata.updatesToCancel.isEmpty)
        #expect(component.state.request == nil)
    }

    @Test
    func cancelsRequestWhenExpirationClears() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    expirationRecord(
                        value: 7,
                        deadline: .seconds(5),
                        reason: "timeout"
                    ),
                    metadata: nil
                ),
                .value(
                    ExpirationRecord(
                        payload: .value(8),
                        expiration: nil
                    ),
                    metadata: nil
                ),
            ])
        )

        _ = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )
        guard let firstRequest = component.state.request else {
            Issue.record("Expected first request")
            return
        }

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(3))
        )

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 8)

        guard let metadata else {
            Issue.record("Expected cancel metadata")
            return
        }
        #expect(metadata.updatesToSchedule.isEmpty)
        #expect(metadata.updatesToCancel == [firstRequest])
        #expect(component.state.request == nil)
    }

    @Test
    func emptyPayloadPreservesReasonAndSchedulesExpiration() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    ExpirationRecord(
                        payload: .empty(.filtered),
                        expiration: Expiration(
                            deadline: Timestamp(value: .seconds(5)),
                            reason: "filtered timeout"
                        )
                    ),
                    metadata: nil
                ),
            ])
        )

        let output = try component.update(
            context: makeExpirationComponentContext(currentTime: .seconds(2))
        )

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(metadata?.updatesToSchedule.count == 1)
    }

    @Test
    func timeoutThrowsWhenCurrentTimeReachesDeadline() throws {
        var component = ExpirationComponent(
            upstream: ExpirationRecordStubComponent(outputs: [
                .value(
                    expirationRecord(
                        value: 7,
                        deadline: .seconds(5),
                        reason: "expired"
                    ),
                    metadata: nil
                ),
            ])
        )

        do {
            _ = try component.update(
                context: makeExpirationComponentContext(currentTime: .seconds(5))
            )
            Issue.record("Expected timeout failure")
        } catch ExpirationComponent<ExpirationRecordStubComponent>.Failure.timeout(let reason) {
            #expect(reason.description == "expired")
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

private func expirationRecord(
    value: Int,
    deadline: Duration,
    reason: ExpirationReason
) -> ExpirationRecord<Int> {
    ExpirationRecord(
        payload: .value(value),
        expiration: Expiration(
            deadline: Timestamp(value: deadline),
            reason: reason
        )
    )
}

private func makeExpirationComponentContext(
    currentTime: Duration
) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: currentTime),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct ExpirationRecordStubComponent: GestureComponent {
    var outputs: [GestureOutput<ExpirationRecord<Int>>]

    mutating func update(
        context: GestureComponentContext
    ) throws -> GestureOutput<ExpirationRecord<Int>> {
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
