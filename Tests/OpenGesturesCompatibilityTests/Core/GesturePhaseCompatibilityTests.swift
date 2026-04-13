//
//  GesturePhaseCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims
import Testing

// MARK: - GesturePhase Static Constructors to fix the link issue
// Note: we can't use package/@_spi(Private) to hide the case in swiftinterface.
// Otherwize we'll got a "Will never be executed" warning, and `ptr.load(as: GesturePhase.self)` will result a crash.

extension GesturePhase {
    @inline(__always)
    private static func make(tag: Int, _ body: (UnsafeMutableRawPointer) -> Void) -> GesturePhase {
        let layout = MemoryLayout<GesturePhase>.self
        let ptr = UnsafeMutableRawPointer.allocate(
            byteCount: layout.size,
            alignment: layout.alignment
        )
        defer { ptr.deallocate() }
        body(ptr)
        Metadata(GesturePhase.self).injectEnumTag(tag: UInt32(tag), ptr)
        return ptr.load(as: GesturePhase.self)
    }

    static func idle() -> GesturePhase {
        make(tag: 4) { $0.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<GesturePhase>.size) }
    }

    static func possible() -> GesturePhase {
        make(tag: 5) { $0.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<GesturePhase>.size) }
    }

    static func active(value: Value) -> GesturePhase {
        make(tag: 1) { $0.initializeMemory(as: Value.self, repeating: value, count: 1) }
    }

    static func blocked(value: Value, blockedBy: GestureNodeID) -> GesturePhase {
        make(tag: 0) { ptr in
            ptr.initializeMemory(as: Value.self, repeating: value, count: 1)
            (ptr + MemoryLayout<Value>.stride).initializeMemory(as: GestureNodeID.self, repeating: blockedBy, count: 1)
        }
    }

    static func ended(value: Value) -> GesturePhase {
        make(tag: 2) { $0.initializeMemory(as: Value.self, repeating: value, count: 1) }
    }

    static func failed(reason: GestureFailureReason) -> GesturePhase {
        make(tag: 3) { $0.initializeMemory(as: GestureFailureReason.self, repeating: reason, count: 1) }
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
