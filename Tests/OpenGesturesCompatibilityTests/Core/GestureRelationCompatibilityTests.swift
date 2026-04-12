//
//  GestureRelationCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct GestureRelationCompatibilityTests {
    @Test
    func initAndProperties() {
        let r = GestureRelation(
            type: .exclusion,
            direction: .outgoing,
            role: .regular,
            target: .any(position: .any)
        )
        #expect(r.type == .exclusion)
        #expect(r.direction == .outgoing)
        #expect(r.role == .regular)
        #expect(r.target == .any(position: .any))
    }

    @Test
    func nilRole() {
        let r = GestureRelation(
            type: .failureRequirement,
            direction: .incoming,
            role: nil,
            target: .tag("x")
        )
        #expect(r.role == nil)
    }

    @Test
    func equality() {
        let a = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any))
        let b = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any))
        let c = GestureRelation(type: .exclusion, direction: .incoming, role: .regular, target: .any(position: .any))
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func equalityDifferentTarget() {
        let a = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any))
        let b = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .tag("x"))
        #expect(a != b)
    }

    @Test
    func defaultRelations() {
        let defaults: [GestureRelation] = .default
        #expect(defaults.count == 3)
        #expect(defaults[0].type == .exclusion)
        #expect(defaults[0].direction == .outgoing)
        #expect(defaults[0].role == .regular)
        #expect(defaults[1].type == .activeExclusion)
        #expect(defaults[1].direction == .outgoing)
        #expect(defaults[2].type == .activeExclusion)
        #expect(defaults[2].direction == .incoming)
        #expect(defaults[2].role == .blocking)
    }
}
