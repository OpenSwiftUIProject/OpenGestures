//
//  GestureTagCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct GestureTagCompatibilityTests {
    @Test
    func initWithRawValue() {
        let tag = GestureTag(rawValue: "tap")
        #expect(tag.rawValue == "tap")
    }

    @Test
    func stringLiteral() {
        let tag: GestureTag = "pan"
        #expect(tag.rawValue == "pan")
    }

    @Test
    func equality() {
        let a: GestureTag = "tap"
        let b = GestureTag(rawValue: "tap")
        let c: GestureTag = "pan"
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func hashable() {
        var set: Set<GestureTag> = []
        set.insert("tap")
        set.insert("tap")
        set.insert("pan")
        #expect(set.count == 2)
    }

    @Test(arguments: [
        (GestureTag(rawValue: "tap"), "\"tap\""),
        (GestureTag(rawValue: "longPress"), "\"longPress\""),
    ])
    func description(_ tag: GestureTag, _ expected: String) {
        #expect(tag.description == expected)
    }
}
