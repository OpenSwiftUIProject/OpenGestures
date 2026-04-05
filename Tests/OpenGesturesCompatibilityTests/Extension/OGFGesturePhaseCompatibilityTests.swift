//
//  OGFGesturePhaseCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct OGFGesturePhaseCompatibilityTests {
    @Test(arguments: [
        (OGFGesturePhase.idle, "idle"),
        (.possible, "possible"),
        (.began, "began"),
        (.changed, "changed"),
        (.ended, "ended"),
        (.cancelled, "cancelled"),
        (.failed, "failed"),
    ])
    func description(_ phase: OGFGesturePhase, _ expectedDescription: String) {
        #expect(phase.description == expectedDescription)
    }
}
