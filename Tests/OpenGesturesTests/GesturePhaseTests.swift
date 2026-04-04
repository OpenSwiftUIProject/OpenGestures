import Testing
@testable import OpenGestures

struct GesturePhaseTests {
    @Test func testIdlePhase() {
        let phase: GesturePhase<Int> = .idle
        #expect(phase.isIdle)
        #expect(!phase.isActive)
        #expect(!phase.isTerminal)
        #expect(!phase.isBlocked)
        #expect(!phase.isRecognized)
        #expect(phase.value == nil)
    }

    @Test func testActivePhase() {
        let phase: GesturePhase<Int> = .active(42)
        #expect(phase.isActive)
        #expect(phase.isRecognized)
        #expect(!phase.isTerminal)
        #expect(!phase.isIdle)
        #expect(phase.value == 42)
    }

    @Test func testBlockedPhase() {
        let id = GestureNodeID(rawValue: 7 as UInt32)
        let phase: GesturePhase<Int> = .blocked(value: 99, blockedBy: id)
        #expect(phase.isBlocked)
        #expect(phase.isRecognized)
        #expect(!phase.isTerminal)
        #expect(!phase.isActive)
        #expect(phase.value == 99)
    }

    @Test func testEndedPhase() {
        let phase: GesturePhase<Int> = .ended(100)
        #expect(phase.isEnded)
        #expect(phase.isTerminal)
        #expect(!phase.isRecognized)
        #expect(!phase.isActive)
        #expect(phase.value == 100)
    }

    @Test func testFailedPhase() {
        let phase: GesturePhase<Int> = .failed(.disabled)
        #expect(phase.isFailed)
        #expect(phase.isTerminal)
        #expect(!phase.isRecognized)
        #expect(phase.failureReason == .disabled)
        #expect(phase.value == nil)
    }

    @Test func testPossiblePhase() {
        let phase: GesturePhase<Int> = .possible
        #expect(phase.isPossible)
        #expect(!phase.isIdle)
        #expect(!phase.isActive)
        #expect(!phase.isTerminal)
    }

    @Test func testMapValue() {
        let phase: GesturePhase<Int> = .active(10)
        let mapped = phase.mapValue { String($0) }
        #expect(mapped.value == "10")
    }

    @Test func testMapValueBlocked() {
        let id = GestureNodeID(rawValue: 3 as UInt32)
        let phase: GesturePhase<Int> = .blocked(value: 5, blockedBy: id)
        let mapped = phase.mapValue { $0 * 2 }
        #expect(mapped.value == 10)
        if case .blocked(_, let blockedBy) = mapped {
            #expect(blockedBy == id)
        }
    }

    @Test func testGestureFailureReasonEquality() {
        let id = GestureNodeID(rawValue: 1 as UInt32)
        #expect(GestureFailureReason.excluded(by: id) == .excluded(by: id))
        #expect(GestureFailureReason.disabled == .disabled)
        #expect(GestureFailureReason.disabled != .aborted)
    }

    @Test func testGestureOutputCases() {
        let empty: GestureOutput<Int> = .empty(.noData, metadata: nil)
        #expect(empty.isEmpty)
        #expect(!empty.isFinal)
        #expect(empty.value == nil)

        let value: GestureOutput<Int> = .value(42, metadata: GestureOutputMetadata())
        #expect(!value.isEmpty)
        #expect(!value.isFinal)
        #expect(value.value == 42)

        let final: GestureOutput<Int> = .final(99, metadata: GestureOutputMetadata())
        #expect(!final.isEmpty)
        #expect(final.isFinal)
        #expect(final.value == 99)
    }
}
