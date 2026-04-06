//
//  GestureRelationTests.swift
//  OpenGesturesTests

import OpenGestures
import Testing

// MARK: - RelationMapTests

@Suite
struct RelationMapTests {
    @Test
    func relationMapEmpty() {
        let map = RelationMap()
        #expect(map.toRelations().isEmpty)
    }

    @Test
    func relationMapAddRelation() {
        var map = RelationMap()
        let relation = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any))
        map.addRelation(relation)
        let relations = map.toRelations()
        #expect(relations.count == 1)
        #expect(relations[0] == relation)
    }

    @Test
    func relationMapRemoveRelation() {
        var map = RelationMap()
        let relation = GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any))
        map.addRelation(relation)
        map.removeRelation(relation)
        #expect(map.toRelations().isEmpty)
    }

    @Test
    func relationMapAddDefinition() {
        var map = RelationMap()
        let def = RelationDefinition(type: .activeExclusion, direction: .incoming, role: .blocking)
        map.add(def, for: .any(position: .any))
        let relations = map.toRelations()
        #expect(relations.count == 1)
        #expect(relations[0].type == .activeExclusion)
        #expect(relations[0].direction == .incoming)
        #expect(relations[0].role == .blocking)
        #expect(relations[0].target == .any(position: .any))
    }

    @Test
    func relationMapRemoveDefinition() {
        var map = RelationMap()
        let def = RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular)
        map.add(def, for: .tag("a"))
        map.remove(def, for: .tag("a"))
        #expect(map.toRelations().isEmpty)
    }

    @Test
    func relationMapGroupsByMatcher() {
        var map = RelationMap()
        map.add(RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular), for: .any(position: .any))
        map.add(RelationDefinition(type: .activeExclusion, direction: .incoming, role: .blocking), for: .any(position: .any))
        let relations = map.toRelations()
        #expect(relations.count == 2)
        #expect(relations.allSatisfy { $0.target == .any(position: .any) })
    }

    @Test
    func relationMapSequence() {
        var map = RelationMap()
        map.add(RelationDefinition(type: .exclusion, direction: .outgoing), for: .any(position: .any))
        map.add(RelationDefinition(type: .failureRequirement, direction: .outgoing), for: .tag("x"))
        var count = 0
        for _ in map {
            count += 1
        }
        #expect(count == 2)
    }
}

// MARK: - RelationDefinitionTests

@Suite
struct RelationDefinitionTests {
    @Test
    func relationDefinitionInit() {
        let def = RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular)
        #expect(def.type == .exclusion)
        #expect(def.direction == .outgoing)
        #expect(def.role == .regular)
    }

    @Test
    func relationDefinitionNilRole() {
        let def = RelationDefinition(type: .failureRequirement, direction: .incoming)
        #expect(def.role == nil)
    }

    @Test
    func relationDefinitionEquality() {
        let a = RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular)
        let b = RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular)
        let c = RelationDefinition(type: .exclusion, direction: .incoming, role: .regular)
        #expect(a == b)
        #expect(a != c)
    }

    @Test
    func relationDefinitionHashable() {
        var set: Set<RelationDefinition> = []
        set.insert(RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular))
        set.insert(RelationDefinition(type: .exclusion, direction: .outgoing, role: .regular))
        set.insert(RelationDefinition(type: .exclusion, direction: .incoming, role: .blocking))
        #expect(set.count == 2)
    }
}
