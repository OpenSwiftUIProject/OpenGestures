//
//  GesturePhaseQueueTests.swift
//  OpenGesturesTests

@_spi(Private) import OpenGestures
import Testing

// MARK: - GesturePhaseQueueTests

@Suite
struct GesturePhaseQueueTests {

    // MARK: - Init

    @Test
    func testInit() {
        let queue = GesturePhaseQueue<Int>(
            timeSource: nil,
            currentPhase: .idle,
            pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
        )
        #expect(queue.currentPhase.isIdle == true)
        #expect(queue.pendingPhases.isEmpty == true)
        #expect(queue.timeSource == nil)
    }

    // MARK: - Properties

    @Test
    func testCurrentPhaseUpdate() {
        var queue = GesturePhaseQueue<Int>(
            timeSource: nil,
            currentPhase: .idle,
            pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
        )
        queue.currentPhase = .active(value: 42)
        #expect(queue.currentPhase.isActive == true)
    }

    @Test
    func testPendingPhasesAppend() {
        var queue = GesturePhaseQueue<Int>(
            timeSource: nil,
            currentPhase: .idle,
            pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
        )
        queue.pendingPhases.append(.active(value: 1))
        #expect(queue.pendingPhases.count == 1)
    }

    // MARK: - InvalidTransition

    @Test
    func testInvalidTransitionInit() {
        let transition = GesturePhaseQueue<Int>.InvalidTransition(
            phase: .idle,
            targetPhase: .active(value: 1)
        )
        #expect(transition.phase.isIdle == true)
        #expect(transition.targetPhase.isActive == true)
    }

    @Test
    func testInvalidTransitionIsError() {
        let _: any Error = GesturePhaseQueue<Int>.InvalidTransition(
            phase: .idle,
            targetPhase: .active(value: 1)
        )
    }

    @Test
    func testInvalidTransitionDescription() {
        let transition = GesturePhaseQueue<Int>.InvalidTransition(
            phase: .idle,
            targetPhase: .active(value: 1)
        )
        #expect(transition.description == #"""
        InvalidTransition { \#("")
          phase: idle
          targetPhase: active
        }
        """#)
    }
}

