//
//  GestureNodeOptionsCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct GestureNodeOptionsCompatibilityTests {
    @Test(arguments: [
        (GestureNodeOptions(), "none"),
        (GestureNodeOptions.isDisabled, "GestureNodeOptions { isDisabled }"),
        (GestureNodeOptions.disallowExclusionWithUnresolvedFailureRequirements, "GestureNodeOptions { disallowExclusionWithUnresolvedFailureRequirements }"),
        (GestureNodeOptions.isGloballyScoped, "GestureNodeOptions { isGloballyScoped }"),
        (GestureNodeOptions([.isDisabled, .isGloballyScoped]), "GestureNodeOptions { isDisabled, isGloballyScoped }"),
        (GestureNodeOptions([.isDisabled, .disallowExclusionWithUnresolvedFailureRequirements, .isGloballyScoped]), "GestureNodeOptions { isDisabled, disallowExclusionWithUnresolvedFailureRequirements, isGloballyScoped }"),
    ])
    func description(_ options: GestureNodeOptions, _ expectedDescription: String) {
        #expect(options.description == expectedDescription)
    }
}
