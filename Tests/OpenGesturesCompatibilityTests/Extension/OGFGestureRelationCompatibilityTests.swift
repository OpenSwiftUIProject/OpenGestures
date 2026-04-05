//
//  OGFGestureRelationCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct OGFGestureRelationTypeCompatibilityTests {
    @Test(arguments: [
        (OGFGestureRelationType.canExclude, "canExclude"),
        (.canBeExcluded, "canBeExcluded"),
        (.canExcludeActive, "canExcludeActive"),
        (.canBeExcludedWhenActive, "canBeExcludedWhenActive"),
        (.requiresFailure, "requiresFailure"),
        (.requiredToFail, "requiredToFail"),
    ])
    func description(_ type: OGFGestureRelationType, _ expectedDescription: String) {
        #expect(type.description == expectedDescription)
    }
}

struct OGFGestureRelationRoleCompatibilityTests {
    @Test(arguments: [
        (OGFGestureRelationRole.regular, "regular"),
        (.blocking, "blocking"),
    ])
    func description(_ role: OGFGestureRelationRole, _ expectedDescription: String) {
        #expect(role.description == expectedDescription)
    }
}
