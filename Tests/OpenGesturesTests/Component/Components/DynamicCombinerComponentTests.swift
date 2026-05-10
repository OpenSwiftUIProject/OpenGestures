//
//  DynamicCombinerComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - DynamicCombinerComponentTests

@Suite
struct DynamicCombinerComponentTests {
    @Test
    func combinesReplicatedOutputsUsingStatusCombiner() throws {
        var upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(outputs: [
                    .empty(.noData, metadata: nil),
                ])
            ),
            count: 2
        )
        upstreams[0] = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [
                .value(1, metadata: nil),
            ])
        )
        upstreams[1] = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [
                .finalValue(2, metadata: nil),
            ])
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { statuses in
                    statuses.contains(.finalValue) ? .finalValue : .value
                }
            ),
            initialCount: 0,
            limit: 2,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        let output = try component.update(context: dynamicCombinerContext())

        guard case let .finalValue(values, metadata) = output else {
            Issue.record("Expected final combined output")
            return
        }
        #expect(values == [1, 2])
        #expect(metadata == nil)
    }

    @Test
    func emptyListReturnsFilteredNoUpstreamsTrace() throws {
        var component = DynamicCombinerComponent(
            upstream: DynamicCombinerStubComponent(outputs: [
                .value(1, metadata: nil),
            ]),
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { _ in .value }
            ),
            initialCount: 0,
            limit: 2,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        let output = try component.update(context: dynamicCombinerContext())

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(metadata?.traceAnnotation?.value == "no upstreams")
    }

    @Test
    func combinerElementReplaysCachedValueWhenUpstreamHasNoData() throws {
        var element = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [
                .value(5, metadata: nil),
                .empty(
                    .noData,
                    metadata: GestureOutputMetadata(
                        traceAnnotation: UpdateTraceAnnotation(value: "tick")
                    )
                ),
            ])
        )

        _ = try element.update(context: dynamicCombinerContext())
        let output = try element.update(context: dynamicCombinerContext())

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected cached value output")
            return
        }
        #expect(value == 5)
        #expect(metadata != nil)
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func combinerElementReplaysCachedValueWithEmptyMetadataWhenUpstreamHasNoMetadata() throws {
        var element = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [
                .value(5, metadata: nil),
                .empty(.noData, metadata: nil),
            ])
        )

        _ = try element.update(context: dynamicCombinerContext())
        let output = try element.update(context: dynamicCombinerContext())

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected cached value output")
            return
        }
        #expect(value == 5)
        #expect(metadata != nil)
        #expect(metadata?.updatesToSchedule.isEmpty == true)
        #expect(metadata?.updatesToCancel.isEmpty == true)
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func combinerElementReplaysCachedFinalWithoutUpdatingUpstream() throws {
        var element = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [
                .finalValue(5, metadata: nil),
                .value(9, metadata: nil),
            ])
        )

        _ = try element.update(context: dynamicCombinerContext())
        let output = try element.update(context: dynamicCombinerContext())

        guard case let .finalValue(value, _) = output else {
            Issue.record("Expected cached final output")
            return
        }
        #expect(value == 5)
        #expect(element.upstream.updateCount == 1)
    }

    @Test
    func dynamicExpansionStopsOnlyAtNoDataEmpty() throws {
        let sharedOutputs = SharedOutputBox(outputs: [
            .value(1, metadata: nil),
            .empty(.filtered, metadata: nil),
            .empty(.noData, metadata: nil),
        ])
        let statusProbe = StatusProbe(result: .value)
        let upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(
                    outputs: [],
                    sharedOutputs: sharedOutputs
                )
            ),
            count: 1
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { try statusProbe.combine($0) }
            ),
            initialCount: 0,
            limit: 4,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        let output = try component.update(context: dynamicCombinerContext())

        guard case let .value(values, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(values == [1])
        #expect(statusProbe.statuses == [[.value, .empty]])
        #expect(component.upstreams.count == 2)
    }

    @Test
    func schedulerUpdateDoesNotDynamicallyExpand() throws {
        let sharedOutputs = SharedOutputBox(outputs: [
            .value(1, metadata: nil),
            .value(2, metadata: nil),
        ])
        let statusProbe = StatusProbe(result: .value)
        let upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(
                    outputs: [],
                    sharedOutputs: sharedOutputs
                )
            ),
            count: 1
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { try statusProbe.combine($0) }
            ),
            initialCount: 0,
            limit: 4,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        let output = try component.update(context: dynamicCombinerContext(updateSource: .scheduler([1])))

        guard case let .value(values, _) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(values == [1])
        #expect(statusProbe.statuses == [[.value]])
        #expect(component.upstreams.count == 1)
        #expect(sharedOutputs.outputs.count == 1)
    }

    @Test
    func limitProbeThrowsAfterAppendingExceededElement() throws {
        let sharedOutputs = SharedOutputBox(outputs: [
            .value(1, metadata: nil),
            .value(2, metadata: nil),
        ])
        let upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(
                    outputs: [],
                    sharedOutputs: sharedOutputs
                )
            ),
            count: 1
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { _ in .value }
            ),
            initialCount: 0,
            limit: 1,
            failOnExceedingLimit: true,
            resetComponentsOnCompletion: false
        )

        #expect(throws: DynamicCombinerComponent<DynamicCombinerStubComponent>.Failure.limitExceeded) {
            _ = try component.update(context: dynamicCombinerContext())
        }
        #expect(component.upstreams.count == 2)
    }

    @Test
    func finalOutputsResetOrRemoveTheirOwnUpstreams() throws {
        let upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(outputs: [
                    .finalValue(2, metadata: nil),
                ])
            ),
            count: 1
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { _ in .finalValue }
            ),
            initialCount: 1,
            limit: 1,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: true
        )

        _ = try component.update(context: dynamicCombinerContext())

        #expect(component.upstreams.count == 1)
        #expect(component.upstreams[0].state.cachedOutput == nil)
        #expect(component.upstreams[0].state.isDirty == false)
        #expect(component.upstreams[0].upstream.resetCount == 1)
    }

    @Test
    func resetResizesToInitialCountAndResetsRemainingElements() {
        var upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(outputs: [])
            ),
            count: 2
        )
        upstreams[0].state.isDirty = true
        upstreams[1].state.isDirty = true
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { _ in .value }
            ),
            initialCount: 1,
            limit: 2,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        component.reset()

        #expect(component.upstreams.count == 1)
        #expect(component.upstreams[0].upstream.resetCount == 1)
        #expect(component.upstreams[0].state.isDirty == false)
    }

    @Test
    func capacityIncludesOnePotentialReplicationSlot() {
        let upstreams = ReplicatingList(
            prototype: CombinerElement(
                upstream: DynamicCombinerStubComponent(outputs: [], capacityValue: 2)
            ),
            count: 2
        )
        var component = DynamicCombinerComponent(
            upstreams: upstreams,
            outputCombiner: GestureOutputArrayCombiner(
                statusCombiner: GestureOutputStatusCombiner { _ in .value }
            ),
            initialCount: 0,
            limit: 5,
            failOnExceedingLimit: false,
            resetComponentsOnCompletion: false
        )

        #expect(component.capacity(for: TouchEvent.self) == 5)
    }

    @Test
    func combinerElementCapacityIsZeroAfterCachedFinalOutput() {
        var state = CombinerElement<DynamicCombinerStubComponent>.State()
        state.cachedOutput = .finalValue(1, metadata: nil)
        var element = CombinerElement(
            upstream: DynamicCombinerStubComponent(outputs: [], capacityValue: 3),
            state: state
        )

        #expect(element.capacity(for: TouchEvent.self) == 0)
    }
}

private func dynamicCombinerContext(
    updateSource: GestureUpdateSource = .event
) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: updateSource,
        eventStore: EventStore<Never>()
    )
}

private final class SharedOutputBox: @unchecked Sendable {
    var outputs: [GestureOutput<Int>]

    init(outputs: [GestureOutput<Int>]) {
        self.outputs = outputs
    }
}

private final class StatusProbe: @unchecked Sendable {
    var statuses: [[GestureOutputStatus]] = []
    var result: GestureOutputStatus

    init(result: GestureOutputStatus) {
        self.result = result
    }

    func combine(_ statuses: [GestureOutputStatus]) throws -> GestureOutputStatus {
        self.statuses.append(statuses)
        return result
    }
}

private struct DynamicCombinerStubComponent: GestureComponent {
    var outputs: [GestureOutput<Int>]
    var sharedOutputs: SharedOutputBox?
    var capacityValue: Int
    var updateCount: Int
    var resetCount: Int

    init(
        outputs: [GestureOutput<Int>],
        sharedOutputs: SharedOutputBox? = nil,
        capacityValue: Int = 0,
        updateCount: Int = 0,
        resetCount: Int = 0
    ) {
        self.outputs = outputs
        self.sharedOutputs = sharedOutputs
        self.capacityValue = capacityValue
        self.updateCount = updateCount
        self.resetCount = resetCount
    }

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
        updateCount += 1
        if let sharedOutputs {
            return sharedOutputs.outputs.removeFirst()
        }
        return outputs.removeFirst()
    }

    mutating func reset() {
        resetCount += 1
    }

    func traits() -> GestureTraitCollection? {
        nil
    }

    func capacity<E: Event>(for eventType: E.Type) -> Int {
        capacityValue
    }
}
