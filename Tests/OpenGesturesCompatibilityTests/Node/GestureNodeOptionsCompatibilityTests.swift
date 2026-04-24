//
//  GestureNodeOptionsCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct GestureNodeOptionsCompatibilityTests {
    @Test(arguments: [
        (GestureNodeOptions(), "none"),
        (GestureNodeOptions.isDisabled, "{ isDisabled }"),
        (GestureNodeOptions.disallowExclusionWithUnresolvedFailureRequirements, "{ disallowExclusionWithUnresolvedFailureRequirements }"),
        (GestureNodeOptions.isGloballyScoped, "{ isGloballyScoped }"),
        (GestureNodeOptions([.isDisabled, .isGloballyScoped]), "{ isDisabled | isGloballyScoped }"),
        (GestureNodeOptions([.isDisabled, .disallowExclusionWithUnresolvedFailureRequirements, .isGloballyScoped]), "{ isDisabled | disallowExclusionWithUnresolvedFailureRequirements | isGloballyScoped }"),
    ])
    func description(_ options: GestureNodeOptions, _ expectedDescription: String) {
        #expect(options.description == expectedDescription)
    }
}
