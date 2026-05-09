//
//  GestureOutputTests.swift
//  OpenGesturesTests

import OpenGestures
import Testing

// MARK: - GestureOutputTests

@Suite
struct GestureOutputTests {
    
    // MARK: - metadata setter

    @Test
    func metadataSetterCombinesMetadataAndPreservesValueCase() {
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
        let output: GestureOutput<Int> = .value(
            7,
            metadata: GestureOutputMetadata(
                updatesToSchedule: [updateToSchedule],
                traceAnnotation: UpdateTraceAnnotation(value: "existing")
            )
        )

        var replaced = output
        replaced.metadata = GestureOutputMetadata(
            updatesToCancel: [updateToCancel],
            traceAnnotation: UpdateTraceAnnotation(value: "replacement")
        )

        guard case let .value(value, metadata) = replaced else {
            Issue.record("Expected value output")
            return
        }
        #expect(value == 7)
        #expect(metadata?.updatesToSchedule == [updateToSchedule])
        #expect(metadata?.updatesToCancel == [updateToCancel])
        #expect(metadata?.traceAnnotation == nil)
    }

    @Test
    func metadataSetterPreservesEmptyAndFinalCases() {
        var emptyOutput: GestureOutput<Int> = .empty(.filtered, metadata: nil)
        var finalOutput: GestureOutput<Int> = .finalValue(9, metadata: nil)

        let replacement = GestureOutputMetadata(
            traceAnnotation: UpdateTraceAnnotation(value: "replacement")
        )
        emptyOutput.metadata = replacement
        finalOutput.metadata = replacement

        guard case let .empty(reason, emptyMetadata) = emptyOutput else {
            Issue.record("Expected empty output")
            return
        }
        guard case let .finalValue(value, finalMetadata) = finalOutput else {
            Issue.record("Expected final value output")
            return
        }
        #expect(reason == .filtered)
        #expect(emptyMetadata != nil)
        #expect(emptyMetadata?.traceAnnotation == nil)
        #expect(value == 9)
        #expect(finalMetadata != nil)
        #expect(finalMetadata?.traceAnnotation == nil)
    }

    @Test
    func metadataSetterKeepsNilWhenBothSidesAreNil() {
        var output: GestureOutput<Int> = .value(3, metadata: nil)

        output.metadata = nil

        #expect(output.metadata == nil)
    }
}
