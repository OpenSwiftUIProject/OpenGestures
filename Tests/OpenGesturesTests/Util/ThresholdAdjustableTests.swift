//
//  ThresholdAdjustableTests.swift
//  OpenGesturesTests

import OpenGestures
import Testing

@Suite
struct ThresholdAdjustableTests {
    @Test
    func consumeThresholdForDouble() {
        var value = 10.0

        let consumed = value.consume(3.0, from: 8.0)

        #expect(consumed == 3.0)
        #expect(value == 7.0)
    }
}
