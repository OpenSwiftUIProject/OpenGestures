//
//  TimeSchedulerCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

@Suite
struct TimeSchedulerCompatibilityTests {
    @Test
    func tokenStartsAtOne() {
        let scheduler = DispatchTimeScheduler(
            queue: .main,
            timeSource: UptimeTimeSource()
        )
        let t1 = scheduler.schedule(after: .seconds(999), handler: {})
        let t2 = scheduler.schedule(after: .seconds(999), handler: {})
        #expect(t1.rawValue == 1)
        #expect(t2.rawValue == 2)
        scheduler.cancel(token: t1)
        scheduler.cancel(token: t2)
    }
}
