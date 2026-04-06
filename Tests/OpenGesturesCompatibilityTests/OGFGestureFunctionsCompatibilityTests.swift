//
//  OGFGestureFunctionsCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import COpenGestures
import Testing

struct OGFGestureFailureTypeIsTerminatedTests {
    @Test(arguments: [
        (OGFGestureFailureType.excluded, false),
        (.failureDependency, false),
        (.customError, true),
        (.disabled, true),
        (.removedFromContainer, false),
        (.activationDenied, true),
        (.aborted, true),
        (.coordinatorChanged, false),
    ])
    func isTerminated(_ type: OGFGestureFailureType, _ expected: Bool) {
        #expect(type.isTerminated == expected)
    }
}
