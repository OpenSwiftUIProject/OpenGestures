//
//  GestureOutputCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims
import Testing

// MARK: - GestureOutput Static Constructors

extension GestureOutput {
    // case 0: .empty(reason, metadata:)
    static func empty(_ reason: GestureOutputEmptyReason, metadata: GestureOutputMetadata?) -> GestureOutput {
        makeEnum(tag: 0, payload: (reason, metadata))
    }

    // case 1: .value(v, metadata:)
    static func value(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        makeEnum(tag: 1, payload: (v, metadata))
    }

    // case 2: .finalValue(v, metadata:)
    static func finalValue(_ v: Value, metadata: GestureOutputMetadata?) -> GestureOutput {
        makeEnum(tag: 2, payload: (v, metadata))
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

    // MARK: - Bridged payload (String Value)

    // Exercises a two-field payload `(String, GestureOutputMetadata?)` where the
    // String field carries a bridgeObject retain that must survive
    // initializeWithCopy during array construction. The previous load+deallocate
    // pattern would leak the retain initializeMemory wrote in place.

    @Test
    func valueWithStringPayload() {
        let output = GestureOutput<String>.value("bridged", metadata: nil)
        #expect(output.isEmpty == false)
        #expect(output.isFinal == false)
        #expect(output.value == "bridged")
    }

    @Test
    func finalValueWithStringPayload() {
        let output = GestureOutput<String>.finalValue("bridged-final", metadata: nil)
        #expect(output.isEmpty == false)
        #expect(output.isFinal == true)
        #expect(output.value == "bridged-final")
    }
}
