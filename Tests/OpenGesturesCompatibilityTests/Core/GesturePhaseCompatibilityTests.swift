//
//  GesturePhaseCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims
import Testing

// MARK: - GesturePhase Static Constructors

extension GesturePhase {
    static func idle() -> GesturePhase {
        makeEnum(tag: 4, payload: ())
    }

    static func possible() -> GesturePhase {
        makeEnum(tag: 5, payload: ())
    }

    static func active(value: Value) -> GesturePhase {
        makeEnum(tag: 1, payload: value)
    }

    static func blocked(value: Value, blockedBy: GestureNodeID) -> GesturePhase {
        makeEnum(tag: 0, payload: (value, blockedBy))
    }

    static func ended(value: Value) -> GesturePhase {
        makeEnum(tag: 2, payload: value)
    }

    static func failed(reason: GestureFailureReason) -> GesturePhase {
        makeEnum(tag: 3, payload: reason)
    }
}

// MARK: - GesturePhaseCompatibilityTests

@Suite
struct GesturePhaseCompatibilityTests {
    @Test(
        arguments: [
            (GesturePhase<Int>.idle(),                           true,  false, false, false, false, false, false, false, "idle"),
            (GesturePhase<Int>.possible(),                       false, true,  false, false, false, false, false, false, "possible"),
            (GesturePhase<Int>.active(value: 42),                false, false, true,  false, false, false, false, true,  "active"),
            (GesturePhase<Int>.blocked(value: 42, blockedBy: GestureNodeID(rawValue: 1)), false, false, false, true, false, false, false, true, "blocked(by: 1)"),
            (GesturePhase<Int>.ended(value: 42),                 false, false, false, false, true,  false, true,  true,  "ended"),
            (GesturePhase<Int>.failed(reason: .disabled),        false, false, false, false, false, true,  true,  false, "failed(disabled)"),
        ]
    )
    func phaseAPI(
        _ phase: GesturePhase<Int>,
        _ isIdle: Bool,
        _ isPossible: Bool,
        _ isActive: Bool,
        _ isBlocked: Bool,
        _ isEnded: Bool,
        _ isFailed: Bool,
        _ isTerminal: Bool,
        _ isRecognized: Bool,
        _ expectedDescription: String
    ) {
        #expect(phase.isIdle == isIdle)
        #expect(phase.isPossible == isPossible)
        #expect(phase.isActive == isActive)
        #expect(phase.isBlocked == isBlocked)
        #expect(phase.isEnded == isEnded)
        #expect(phase.isFailed == isFailed)
        #expect(phase.isTerminal == isTerminal)
        #expect(phase.isRecognized == isRecognized)
        #expect(phase.description == expectedDescription)
    }

    // MARK: - mapValue

    @Test
    func mapValue() {
        let active: GesturePhase<Int> = .active(value: 5)
        let mapped = active.mapValue { String($0) }
        #expect(mapped.isActive == true)

        let idle: GesturePhase<Int> = .idle()
        let mappedIdle = idle.mapValue { String($0) }
        #expect(mappedIdle.isIdle == true)
    }

    // MARK: - Bridged payload (String Value)

    // These tests carry a refcounted Value through the fixture. The previous
    // load+deallocate pattern would leak the retain initializeMemory wrote in
    // place; correct handling round-trips the String without heap corruption.

    @Test
    func activeWithStringPayload() {
        let phase = GesturePhase<String>.active(value: "hello")
        #expect(phase.isActive == true)
        #expect(phase.mapValue { $0.count }.isActive == true)
    }

    @Test
    func blockedWithStringPayload() {
        // Exercises a two-field payload `(String, GestureNodeID)` where the
        // String field carries a bridgeObject retain that must survive
        // initializeWithCopy during array construction.
        let phase = GesturePhase<String>.blocked(
            value: "bridged",
            blockedBy: GestureNodeID(rawValue: 7)
        )
        #expect(phase.isBlocked == true)
        #expect(phase.description == "blocked(by: 7)")
    }
}

// MARK: - GestureFailureReasonCompatibilityTests

@Suite
struct GestureFailureReasonCompatibilityTests {
    @Test(arguments: [
        (GestureFailureReason.disabled, "disabled"),
        (.removedFromContainer, "removedFromContainer"),
        (.activationDenied, "activationDenied"),
        (.aborted, "aborted"),
        (.coordinatorChanged, "coordinatorChanged"),
    ])
    func description(_ reason: GestureFailureReason, _ expected: String) {
        #expect(reason.description == expected)
    }
}
