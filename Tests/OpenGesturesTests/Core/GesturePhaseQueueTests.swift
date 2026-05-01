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

    @Test
    func testTransitionRules() {
        let firstNode = GestureNodeID(rawValue: 2)
        let secondNode = GestureNodeID(rawValue: 3)
        #expect(GesturePhase<Int>.idle.canTransition(to: .possible))
        #expect(GesturePhase<Int>.possible.canTransition(to: .blocked(value: 1, blockedBy: firstNode)))
        #expect(GesturePhase<Int>.possible.canTransition(to: .active(value: 1)))
        #expect(GesturePhase<Int>.possible.canTransition(to: .ended(value: 1)))
        #expect(GesturePhase<Int>.possible.canTransition(to: .failed(reason: .aborted)))
        #expect(GesturePhase<Int>.blocked(value: 1, blockedBy: firstNode).canTransition(to: .blocked(value: 2, blockedBy: secondNode)))
        #expect(GesturePhase<Int>.blocked(value: 1, blockedBy: firstNode).canTransition(to: .active(value: 2)))
        #expect(GesturePhase<Int>.blocked(value: 1, blockedBy: firstNode).canTransition(to: .ended(value: 2)))
        #expect(GesturePhase<Int>.blocked(value: 1, blockedBy: firstNode).canTransition(to: .failed(reason: .aborted)))
        #expect(GesturePhase<Int>.active(value: 1).canTransition(to: .active(value: 2)))
        #expect(GesturePhase<Int>.active(value: 1).canTransition(to: .ended(value: 2)))
        #expect(GesturePhase<Int>.active(value: 1).canTransition(to: .failed(reason: .aborted)))
        #expect(GesturePhase<Int>.ended(value: 1).canTransition(to: .idle))
        #expect(GesturePhase<Int>.failed(reason: .aborted).canTransition(to: .idle))
        #expect(!GesturePhase<Int>.idle.canTransition(to: .active(value: 1)))
        #expect(!GesturePhase<Int>.active(value: 1).canTransition(to: .possible))
    }

    @Test
    func testEnqueueUsesLatestPendingPhase() throws {
        var queue = GesturePhaseQueue<Int>(
            timeSource: nil,
            currentPhase: .possible,
            pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
        )
        try queue.enqueue(.active(value: 1))
        try queue.enqueue(.ended(value: 2))
        #expect(queue.latestPhase.isEnded == true)

        let firstTransition = queue.processNextPhase()
        #expect(firstTransition?.oldPhase.isPossible == true)
        #expect(firstTransition?.newPhase.isActive == true)

        let secondTransition = queue.processNextPhase()
        #expect(secondTransition?.oldPhase.isActive == true)
        #expect(secondTransition?.newPhase.isEnded == true)
    }

    @Test
    func testEnqueueRejectsInvalidTransition() {
        var queue = GesturePhaseQueue<Int>(
            timeSource: nil,
            currentPhase: .idle,
            pendingPhases: RingBuffer(capacity: 5, emptyValue: .idle)
        )
        do {
            try queue.enqueue(.active(value: 1))
            Issue.record("Expected invalid transition")
        } catch let error as GesturePhaseQueue<Int>.InvalidTransition {
            #expect(error.phase.isIdle == true)
            #expect(error.targetPhase.isActive == true)
        } catch {
            Issue.record("Expected InvalidTransition, got \(error)")
        }
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
