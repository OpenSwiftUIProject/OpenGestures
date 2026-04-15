//
//  EventIDCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct EventIDCompatibilityTests {
    @Test(arguments: [
        (EventID(rawValue: 0), "0"),
        (EventID(rawValue: 42), "42"),
        (EventID(rawValue: -1), "-1"),
    ])
    func description(_ id: EventID, _ expected: String) {
        #expect(id.description == expected)
    }
}
