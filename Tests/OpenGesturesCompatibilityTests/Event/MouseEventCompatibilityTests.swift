//
//  MouseEventCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import OpenCoreGraphicsShims
import Testing

struct MouseEventCompatibilityTests {
    @Test
    func initAndProperties() {
        let event = MouseEvent(
            id: EventID(rawValue: 7),
            phase: .began,
            timestamp: Timestamp(value: .seconds(1)),
            location: CGPoint(x: 10, y: 20),
            button: .primary
        )
        #expect(event.id == EventID(rawValue: 7))
        #expect(event.phase == .began)
        #expect(event.timestamp == Timestamp(value: .seconds(1)))
        #expect(event.location == CGPoint(x: 10, y: 20))
        #expect(event.button.rawValue == 1)
    }

    @Test(arguments: [
        (MouseEvent.Button.primary, 1),
        (.secondary, 2),
        (.tertiary, 3),
    ])
    func buttonRawValues(_ button: MouseEvent.Button, _ expectedRaw: Int) {
        #expect(button.rawValue == expectedRaw)
        #expect(MouseEvent.Button(rawValue: expectedRaw).rawValue == button.rawValue)
    }

    @Test(arguments: [
        (EventID(rawValue: 42), EventPhase.began, MouseEvent.Button.primary, #"""
        MouseEvent <42> { \#("")
          id: 42
          phase: began
          timestamp: 1.0 seconds
          location: (10.0, 20.0)
          button: Button(rawValue: 1)
        }
        """#),
        (EventID(rawValue: 7), .active, .secondary, #"""
        MouseEvent <7> { \#("")
          id: 7
          phase: active
          timestamp: 1.0 seconds
          location: (10.0, 20.0)
          button: Button(rawValue: 2)
        }
        """#),
        (EventID(rawValue: 100), .ended, .tertiary, #"""
        MouseEvent <100> { \#("")
          id: 100
          phase: ended
          timestamp: 1.0 seconds
          location: (10.0, 20.0)
          button: Button(rawValue: 3)
        }
        """#),
        (EventID(rawValue: -1), .failed, .primary, #"""
        MouseEvent <-1> { \#("")
          id: -1
          phase: failed
          timestamp: 1.0 seconds
          location: (10.0, 20.0)
          button: Button(rawValue: 1)
        }
        """#),
    ])
    func description(
        _ id: EventID,
        _ phase: EventPhase,
        _ button: MouseEvent.Button,
        _ expected: String
    ) {
        let event = MouseEvent(
            id: id,
            phase: phase,
            timestamp: Timestamp(value: .seconds(1)),
            location: CGPoint(x: 10, y: 20),
            button: button
        )
        #expect(String(describing: event) == expected)
    }
}
