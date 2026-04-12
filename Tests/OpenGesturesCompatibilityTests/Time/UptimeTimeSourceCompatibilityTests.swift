//
//  UptimeTimeSourceCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

@Suite
struct UptimeTimeSourceCompatibilityTests {
    @Test
    func durationIsPositive() {
        let source = UptimeTimeSource()
        let d = source._duration
        #expect(d > .zero)
    }

    @Test
    func durationIsMonotonicallyIncreasing() {
        let source = UptimeTimeSource()
        let d1 = source._duration
        let d2 = source._duration
        #expect(d2 >= d1)
    }
}
