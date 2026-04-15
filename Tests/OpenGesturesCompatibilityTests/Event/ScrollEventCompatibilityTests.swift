//
//  ScrollEventCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenCoreGraphicsShims
import Testing

struct ScrollEventCompatibilityTests {
    @Test
    func initAndProperties() {
        let event = ConcreteScrollEvent(
            id: EventID(rawValue: 11),
            phase: .ended,
            timestamp: Timestamp(value: .seconds(4)),
            location: CGPoint(x: 50, y: 60),
            delta: CGVector(dx: 1, dy: 2),
            acceleratedDelta: CGVector(dx: 3, dy: 4)
        )
        #expect(event.id == EventID(rawValue: 11))
        #expect(event.phase == .ended)
        #expect(event.timestamp == Timestamp(value: .seconds(4)))
        #expect(event.location == CGPoint(x: 50, y: 60))
        #expect(event.delta == CGVector(dx: 1, dy: 2))
        #expect(event.acceleratedDelta == CGVector(dx: 3, dy: 4))
    }

    @Test(arguments: [
        (EventID(rawValue: 1), EventPhase.began, #"""
        ConcreteScrollEvent <1> { \#("")
          id: 1
          phase: began
          timestamp: 1.0 seconds
          location: (0.0, 0.0)
          delta: (1.0, 2.0)
          acceleratedDelta: (3.0, 4.0)
        }
        """#),
        (EventID(rawValue: 11), .active, #"""
        ConcreteScrollEvent <11> { \#("")
          id: 11
          phase: active
          timestamp: 1.0 seconds
          location: (0.0, 0.0)
          delta: (1.0, 2.0)
          acceleratedDelta: (3.0, 4.0)
        }
        """#),
        (EventID(rawValue: 0), .ended, #"""
        ConcreteScrollEvent <0> { \#("")
          id: 0
          phase: ended
          timestamp: 1.0 seconds
          location: (0.0, 0.0)
          delta: (1.0, 2.0)
          acceleratedDelta: (3.0, 4.0)
        }
        """#),
        (EventID(rawValue: -7), .failed, #"""
        ConcreteScrollEvent <-7> { \#("")
          id: -7
          phase: failed
          timestamp: 1.0 seconds
          location: (0.0, 0.0)
          delta: (1.0, 2.0)
          acceleratedDelta: (3.0, 4.0)
        }
        """#),
    ])
    func description(
        _ id: EventID,
        _ phase: EventPhase,
        _ expected: String
    ) {
        let event = ConcreteScrollEvent(
            id: id,
            phase: phase,
            timestamp: Timestamp(value: .seconds(1)),
            location: CGPoint(x: 0, y: 0),
            delta: CGVector(dx: 1, dy: 2),
            acceleratedDelta: CGVector(dx: 3, dy: 4)
        )
        #expect(String(describing: event) == expected)
    }
}
