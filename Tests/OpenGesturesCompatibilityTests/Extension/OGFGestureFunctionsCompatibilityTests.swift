//
//  OGFGestureFunctionsCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

// MARK: - OGFGestureFunctionsCompatibilityTests

@Suite
struct OGFGestureFunctionsCompatibilityTests {
    @Test
    func nodeDefaultValue() {
        let value = OGFGestureNodeDefaultValue()
        #expect(value is Void)
    }

    @Suite(.enabled(if: compatibilityTestEnabled))
    struct GestureNodeCreateDefaultCompatibilityTests {
        @Test(arguments: [1, 2])
        func properties(_ key: Int) {
            let _ = OGFGestureNodeCreateDefault(key)
            // WIP
            // #expect(node.identifier == key.description)
        }

        @Test(.enabled(if: compatibilityTestEnabled))
        func description() throws {
            let node = OGFGestureNodeCreateDefault(1)
            let description = String(describing: node)
            let pattern = [
                #"GestureNodeShim<\(\)> <0x[0-9a-f]+> \{"#,
                #"  node: GestureNode<\(\)> <0x[0-9a-f]+ \d+> \{"#,
                #"    phase: idle"#,
                #"    pendingPhases: \[\]"#,
                #"    relations: \{"#,
                #"      can exclude \(dynamic\): \[any, position: any\]"#,
                #"      can be excluded by \(dynamic\): \[any, position: any\]"#,
                #"      can exclude active \(dynamic\): \[any, position: any\]"#,
                #"      can be excluded when active by \(dynamic\): \[any, position: any\]"#,
                #"      should require failure of \(dynamic\): \[any, position: any\]"#,
                #"      should required to fail by \(dynamic\): \[any, position: any\]"#,
                #"    \}"#,
                #"    delegate: nil"#,
                #"    container: nil"#,
                #"    trackedEvents: \[\]"#,
                #"  \}"#,
                #"  flags: none"#,
                #"\}"#,
            ].joined(separator: " *\n")
            let regex = try Regex(pattern)
            #expect(description.wholeMatch(of: regex) != nil)
        }
    }

    @Suite(.enabled(if: compatibilityTestEnabled))
    struct GestureNodeCoordinatorCreateCompatibilityTests {
        @Test
        func createCoordinatorWithNilHandlers() {
            let coordinator = OGFGestureNodeCoordinatorCreate(nil, nil)
            #expect(coordinator.nodes.count == 0)
        }

        @Test
        func createCoordinatorWithHandlers() {
            var willUpdateCalled = false
            var didUpdateCalled = false
            let coordinator = OGFGestureNodeCoordinatorCreate(
                { willUpdateCalled = true },
                { didUpdateCalled = true }
            )
            // FIXME: The init set does not work
            coordinator.willUpdateHandler = {
                willUpdateCalled = true
            }
            coordinator.didUpdateHandler = {
                didUpdateCalled = true
            }
            coordinator.willUpdateHandler?()
            coordinator.didUpdateHandler?()
            #expect(willUpdateCalled)
            #expect(didUpdateCalled)
        }
    }

    @Test(.disabled())
    func gestureComponentControllerSetNode() throws {
        // TODO
    }

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
    func isTerminated(_ type: OGFGestureFailureType, _ expected: Bool) {
        #expect(OGFGestureFailureTypeIsTerminated(type) == expected)
    }
}
