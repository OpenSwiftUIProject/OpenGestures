//
//  TimeSchedulerTests.swift
//  OpenGesturesTests

@testable import OpenGestures
import Testing

@Suite
struct TimeSchedulerTests {
    @Test
    func cancelRemovesJob() {
        let scheduler = DispatchTimeScheduler(
            queue: .main,
            timeSource: UptimeTimeSource()
        )
        let token = scheduler.schedule(after: .seconds(999), handler: {})
        #expect(scheduler.scheduledJobs.count == 1)
        scheduler.cancel(token: token)
        #expect(scheduler.scheduledJobs.isEmpty)
    }
}
