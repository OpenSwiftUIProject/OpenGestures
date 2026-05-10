//
//  ExpirationTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - ExpirationTests

@Suite
struct ExpirationTests {
    @Test
    func expirablePayloadDescriptionUsesFrameworkLabels() {
        let emptyDescription = ExpirablePayload<Int>.empty(.filtered).description
        #expect(emptyDescription.contains("reason: filtered"))
        #expect(!emptyDescription.contains("empty:"))

        let valueDescription = ExpirablePayload<Int>.value(7).description
        #expect(valueDescription.contains("value: 7"))
    }
}
