//
//  GestureOutputCombinerTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - GestureOutputArrayCombinerTests

@Suite
struct GestureOutputArrayCombinerTests {
    @Test
    func arrayCombinerUsesFilteredReasonForMultiOutputEmptyStatus() throws {
        let combiner = GestureOutputArrayCombiner<Int>(
            statusCombiner: GestureOutputStatusCombiner { _ in .empty }
        )

        let output = try combiner.combine([
            .value(1, metadata: nil),
            .value(2, metadata: nil),
        ])

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(metadata == nil)
    }

    @Test
    func arrayCombinerUsesNoDataReasonForSingleNonEmptyOutputWhenStatusIsEmpty() throws {
        let combiner = GestureOutputArrayCombiner<Int>(
            statusCombiner: GestureOutputStatusCombiner { _ in .empty }
        )

        let output = try combiner.combine([
            .value(1, metadata: nil),
        ])

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .noData)
        #expect(metadata == nil)
    }

    @Test(arguments: [
        GestureOutputEmptyReason.noData,
        .filtered,
        .timeUpdate,
    ])
    func arrayCombinerUsesFilteredReasonForSingleEmptyOutputWhenStatusIsEmpty(
        _ sourceReason: GestureOutputEmptyReason
    ) throws {
        let combiner = GestureOutputArrayCombiner<Int>(
            statusCombiner: GestureOutputStatusCombiner { _ in .empty }
        )

        let output = try combiner.combine([
            .empty(sourceReason, metadata: nil),
        ])

        guard case let .empty(reason, metadata) = output else {
            Issue.record("Expected empty output")
            return
        }
        #expect(reason == .filtered)
        #expect(metadata == nil)
    }

    @Test
    func arrayCombinerCombinesUpdateRequestMetadataAndDropsTraceAnnotations() throws {
        let updateToSchedule = UpdateRequest(
            id: 1,
            creationTime: Timestamp(value: .seconds(1)),
            targetTime: Timestamp(value: .seconds(2)),
            tag: "schedule"
        )
        let updateToCancel = UpdateRequest(
            id: 2,
            creationTime: Timestamp(value: .seconds(3)),
            targetTime: Timestamp(value: .seconds(4)),
            tag: "cancel"
        )
        let combiner = GestureOutputArrayCombiner<Int>(
            statusCombiner: GestureOutputStatusCombiner { _ in .value }
        )

        let output = try combiner.combine([
            .value(
                1,
                metadata: GestureOutputMetadata(
                    updatesToSchedule: [updateToSchedule],
                    traceAnnotation: UpdateTraceAnnotation(value: "first")
                )
            ),
            .empty(
                .filtered,
                metadata: GestureOutputMetadata(
                    updatesToCancel: [updateToCancel],
                    traceAnnotation: UpdateTraceAnnotation(value: "second")
                )
            ),
        ])

        guard case let .value(values, metadata) = output else {
            Issue.record("Expected value output")
            return
        }
        #expect(values == [1])
        #expect(metadata?.updatesToSchedule == [updateToSchedule])
        #expect(metadata?.updatesToCancel == [updateToCancel])
        #expect(metadata?.traceAnnotation == nil)
    }
}
