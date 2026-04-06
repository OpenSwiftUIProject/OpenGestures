//
//  OGFGestureFunctionsCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

struct OGFGestureFunctionsCompatibilityTests {
    @Test(arguments: [
        (.excluded, false),
        (.failureDependency, false),
        (.customError, true),
        (.disabled, true),
        (.removedFromContainer, false),
        (.activationDenied, true),
        (.aborted, true),
        (.coordinatorChanged, false),
    ] as [(OGFGestureFailureType, Bool)])
    func failureTypeIsTerminated(_ type: OGFGestureFailureType, _ expected: Bool) {
        #expect(type.isTerminated == expected)
    }
}
