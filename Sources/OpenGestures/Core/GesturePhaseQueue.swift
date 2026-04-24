//
//  GesturePhaseQueue.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GesturePhaseQueue

/// A queue of gesture phase transitions.
package struct GesturePhaseQueue<Value: Sendable> {
    package var timeSource: (any TimeSource)?
    package var currentPhase: GesturePhase<Value>
    package var pendingPhases: RingBuffer<GesturePhase<Value>>

    package init(
        timeSource: (any TimeSource)? = nil,
        currentPhase: GesturePhase<Value> = .idle,
        pendingPhases: RingBuffer<GesturePhase<Value>> = .init(capacity: 5, emptyValue: .idle)
    ) {
        self.timeSource = timeSource
        self.currentPhase = currentPhase
        self.pendingPhases = pendingPhases
    }
}

// MARK: - GesturePhaseQueue.InvalidTransition

extension GesturePhaseQueue {
    package struct InvalidTransition: Error {
        package var phase: GesturePhase<Value>
        package var targetPhase: GesturePhase<Value>

        package init(phase: GesturePhase<Value>, targetPhase: GesturePhase<Value>) {
            self.phase = phase
            self.targetPhase = targetPhase
        }
    }
}

extension GesturePhaseQueue.InvalidTransition: NestedCustomStringConvertible {}
