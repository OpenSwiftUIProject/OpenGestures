//
//  TimestampCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

#if !OPENGESTURES
extension Timestamp {
    init(value: Duration) {
        self = unsafeBitCast(value, to: Timestamp.self)
    }

    var value: Duration {
        unsafeBitCast(self, to: Duration.self)
    }
}
#endif

@Suite
struct TimestampCompatibilityTests {
    @Test
    func arithmetic() {
        let t = Timestamp(value: .seconds(10))
        let t2 = t + .seconds(5)
        #expect(t2.value == .seconds(15))
        #expect((t2 - .seconds(3)).value == .seconds(12))
        #expect((t2 - t) == .seconds(5))
    }

    @Test
    func compoundAssignment() {
        var t = Timestamp(value: .seconds(10))
        t += .seconds(5)
        #expect(t.value == .seconds(15))
        t -= .seconds(3)
        #expect(t.value == .seconds(12))
    }

    @Test
    func comparable() {
        let a = Timestamp(value: .seconds(1))
        let b = Timestamp(value: .seconds(2))
        #expect(a < b)
        #expect(!(b < a))
        #expect(a == a)
    }

    @Test
    func advancedAndDuration() {
        let t = Timestamp(value: .seconds(5))
        let t2 = t.advanced(by: .seconds(3))
        #expect(t.duration(to: t2) == .seconds(3))
    }

    @Test
    func description() {
        let t = Timestamp(value: .seconds(1))
        #expect(t.description == "1.0 seconds")
    }
}
