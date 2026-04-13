//
//  GestureOutputCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims
import Testing

// MARK: - GestureOutput Static Constructors

extension GestureOutput {
    @inline(__always)
    private static func make(tag: Int, _ body: (UnsafeMutableRawPointer) -> Void) -> GestureOutput {
        let layout = MemoryLayout<GestureOutput>.self
        let ptr = UnsafeMutableRawPointer.allocate(
            byteCount: layout.size,
            alignment: layout.alignment
        )
        defer { ptr.deallocate() }
        body(ptr)
        Metadata(GestureOutput.self).injectEnumTag(tag: UInt32(tag), ptr)
        return ptr.load(as: GestureOutput.self)
    }

    // case 0: .empty(reason, metadata:)
    static func empty(_ reason: GestureOutputEmptyReason, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 0) { ptr in
            ptr.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<GestureOutput>.size)
            ptr.storeBytes(of: reason, as: GestureOutputEmptyReason.self)
            let metadataOffset = MemoryLayout<GestureOutputEmptyReason>.stride
            (ptr + metadataOffset).initializeMemory(as: GestureOutputMetadata?.self, repeating: metadata, count: 1)
        }
    }

    // case 1: .value(v, metadata:)
    static func value(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 1) { ptr in
            ptr.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<GestureOutput>.size)
            ptr.initializeMemory(as: Value.self, repeating: v, count: 1)
            let metadataOffset = MemoryLayout<Value>.stride
            (ptr + metadataOffset).initializeMemory(as: GestureOutputMetadata?.self, repeating: metadata, count: 1)
        }
    }

    // case 2: .finalValue(v, metadata:)
    static func finalValue(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        make(tag: 2) { ptr in
            ptr.initializeMemory(as: UInt8.self, repeating: 0, count: MemoryLayout<GestureOutput>.size)
            ptr.initializeMemory(as: Value.self, repeating: v, count: 1)
            let metadataOffset = MemoryLayout<Value>.stride
            (ptr + metadataOffset).initializeMemory(as: GestureOutputMetadata?.self, repeating: metadata, count: 1)
        }
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
