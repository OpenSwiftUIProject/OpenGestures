//
//  GestureOutputCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims
import Testing

// MARK: - GestureOutput Static Constructors

extension GestureOutput {
    /// Builds a `GestureOutput` by memory-writing the case payload at offset 0 and
    /// injecting the enum tag via the runtime.
    ///
    /// The payload is typed as a Swift tuple so the compiler computes the correct
    /// field offsets (including alignment padding) — in particular, `GestureOutputMetadata?`
    /// is 8-byte aligned, so `.empty(reason, metadata:)` must place the metadata at
    /// offset 8, not `stride(reason) == 1`.
    ///
    /// Uses `UnsafeMutablePointer<GestureOutput>.move()` to transfer ownership out
    /// of the scratch slot, avoiding the `load(as:)`+`deallocate()` pattern which
    /// leaks the refcounts the payload already initialized in place.
    @inline(__always)
    private static func make<Payload>(tag: Int, payload: Payload) -> GestureOutput {
        precondition(
            MemoryLayout<Payload>.size <= MemoryLayout<GestureOutput>.size,
            "Case payload must fit inside GestureOutput's enum payload"
        )
        let slot = UnsafeMutablePointer<GestureOutput>.allocate(capacity: 1)
        defer { slot.deallocate() }
        let raw = UnsafeMutableRawPointer(slot)

        // Write the case payload tuple at offset 0 using the compiler's layout.
        raw.bindMemory(to: Payload.self, capacity: 1).initialize(to: payload)

        // Zero out any bytes beyond the payload (padding + tag area) so `injectEnumTag`
        // operates on a known-clean buffer.
        let payloadStride = MemoryLayout<Payload>.stride
        let totalStride = MemoryLayout<GestureOutput>.stride
        if totalStride > payloadStride {
            (raw + payloadStride).initializeMemory(
                as: UInt8.self,
                repeating: 0,
                count: totalStride - payloadStride
            )
        }

        Metadata(GestureOutput.self).injectEnumTag(tag: UInt32(tag), raw)
        return slot.move()
    }

    // case 0: .empty(reason, metadata:)
    static func empty(_ reason: GestureOutputEmptyReason, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 0, payload: (reason, metadata))
    }

    // case 1: .value(v, metadata:)
    static func value(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 1, payload: (v, metadata))
    }

    // case 2: .finalValue(v, metadata:)
    static func finalValue(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 2, payload: (v, metadata))
    }
}

// MARK: - GestureOutputCompatibilityTests

// Arguments: (output, isEmpty, isFinal, value, descriptionContains)
@Suite
struct GestureOutputCompatibilityTests {
    @Test(
        arguments: [
            (GestureOutput<Int>.empty(.noData, metadata: nil),    true,  false, nil as Int?, "emptyReason"),
            (GestureOutput<Int>.value(42, metadata: nil),         false, false, 42,          "value"),
            (GestureOutput<Int>.finalValue(99, metadata: nil),    false, true,  99,          "finalValue"),
        ]
    )
    func outputAPI(
        _ output: GestureOutput<Int>,
        _ isEmpty: Bool,
        _ isFinal: Bool,
        _ expectedValue: Int?,
        _ descriptionContains: String
    ) {
        #expect(output.isEmpty == isEmpty)
        #expect(output.isFinal == isFinal)
        #expect(output.value == expectedValue)
        #expect("\(output)".contains(descriptionContains))
    }
}
