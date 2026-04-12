//
//  GestureNodeMatcherCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct GestureNodeMatcherCompatibilityTests {
    @Test
    func equalitySameCase() {
        #expect(GestureNodeMatcher.any(position: .any) == .any(position: .any))
        #expect(GestureNodeMatcher.any(position: .above) != .any(position: .below))
        #expect(GestureNodeMatcher.tag("a") == .tag("a"))
        #expect(GestureNodeMatcher.tag("a") != .tag("b"))
    }

    @Test
    func equalityDifferentCases() {
        #expect(GestureNodeMatcher.any(position: .any) != .tag("x"))
    }

    @Test
    func hashable() {
        var set: Set<GestureNodeMatcher> = []
        set.insert(.any(position: .any))
        set.insert(.any(position: .any))
        set.insert(.tag("a"))
        #expect(set.count == 2)
    }

    @Test
    func comparable() {
        #expect(GestureNodeMatcher.id(GestureNodeID(rawValue: 0)) < .tag("x"))
        #expect(GestureNodeMatcher.tag("x") < .traits(.init(), position: .any))
        #expect(GestureNodeMatcher.traits(.init(), position: .any) < .any(position: .any))
    }

    @Test
    func relativePositionEquality() {
        #expect(GestureNodeMatcher.RelativePosition.any == .any)
        #expect(GestureNodeMatcher.RelativePosition.above != .below)
    }

    @Test(arguments: [
        (GestureNodeMatcher.id(.init(rawValue: 2)), "2"),
        (GestureNodeMatcher.tag("A"), #""A""#),
        (GestureNodeMatcher.traits(.withTrait(.pan()), position: .below), "[pan], position: below"),
        (GestureNodeMatcher.any(position: .above), "any, position: above"),
    ])
    func description(_ matcher: GestureNodeMatcher, expectedDescription: String) {
        #expect(String(describing: matcher) == expectedDescription)
    }
}
