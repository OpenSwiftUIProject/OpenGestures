//
//  GestureNodeIDCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

#if !OPENGESTURES
extension GestureNodeID {
    init(rawValue: UInt32) {
        self = unsafeBitCast(rawValue, to: GestureNodeID.self)
    }
}
#endif

struct GestureNodeIDCompatibilityTests {
    @Test
    func equality() {
        let a = GestureNodeID(rawValue: 1)
        let b = GestureNodeID(rawValue: 1)
        let c = GestureNodeID(rawValue: 2)
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func comparable() {
        let a = GestureNodeID(rawValue: 1)
        let b = GestureNodeID(rawValue: 2)
        #expect(a < b)
        #expect(!(b < a))
    }

    @Test
    func hashable() {
        var set: Set<GestureNodeID> = []
        set.insert(GestureNodeID(rawValue: 1))
        set.insert(GestureNodeID(rawValue: 1))
        set.insert(GestureNodeID(rawValue: 2))
        #expect(set.count == 2)
    }

    @Test(arguments: [
        (GestureNodeID(rawValue: 0), "0"),
        (GestureNodeID(rawValue: 42), "42"),
    ])
    func description(_ id: GestureNodeID, _ expected: String) {
        #expect(id.description == expected)
    }
}
