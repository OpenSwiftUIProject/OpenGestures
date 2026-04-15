//
//  TouchEventCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenCoreGraphicsShims
import Testing

struct TouchEventCompatibilityTests {
    @Test
    func initAndProperties() {
        let event = TouchEvent(
            id: EventID(rawValue: 3),
            phase: .active,
            timestamp: Timestamp(value: .seconds(2)),
            location: CGPoint(x: 5, y: 15)
        )
        #expect(event.id == EventID(rawValue: 3))
        #expect(event.phase == .active)
        #expect(event.timestamp == Timestamp(value: .seconds(2)))
        #expect(event.location == CGPoint(x: 5, y: 15))
    }

    @Test(arguments: [
        (EventID(rawValue: 9), EventPhase.began, #"""
        TouchEvent <9> { \#("")
          id: 9
          phase: began
          timestamp: 1.0 seconds
          location: (100.0, 200.0)
        }
        """#),
        (EventID(rawValue: 3), .active, #"""
        TouchEvent <3> { \#("")
          id: 3
          phase: active
          timestamp: 1.0 seconds
          location: (100.0, 200.0)
        }
        """#),
        (EventID(rawValue: 0), .ended, #"""
        TouchEvent <0> { \#("")
          id: 0
          phase: ended
          timestamp: 1.0 seconds
          location: (100.0, 200.0)
        }
        """#),
        (EventID(rawValue: -2), .failed, #"""
        TouchEvent <-2> { \#("")
          id: -2
          phase: failed
          timestamp: 1.0 seconds
          location: (100.0, 200.0)
        }
        """#),
    ])
    func description(
        _ id: EventID,
        _ phase: EventPhase,
        _ expected: String
    ) {
        let event = TouchEvent(
            id: id,
            phase: phase,
            timestamp: Timestamp(value: .seconds(1)),
            location: CGPoint(x: 100, y: 200)
        )
        #expect(String(describing: event) == expected)
    }
}
