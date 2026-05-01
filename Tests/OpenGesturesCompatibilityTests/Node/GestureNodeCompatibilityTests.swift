//
//  GestureNodeCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

// MARK: - GestureNodeCompatibilityTests

@Suite
struct GestureNodeCompatibilityTests {
    // MARK: - debugLabel

    @Test
    func debugLabelWithValue() throws {
        let node = GestureNode<Int>(traits: nil, tag: .init(rawValue: "test"), relations: [])
//        try node.update(value: 3, isFinalUpdate: false) // Link issue
//        try node.update(someValue: 3, isFinalUpdate: false)

        let label = node.debugLabel
        let regex = #/\<GestureNode<Int>: 0x[0-9a-f]+ "test"; id = \d+; phase = idle>/#
        #expect(label.wholeMatch(of: regex) != nil, "\(label) does not match regex")
    }

    @Test(
        arguments: [
            (
                GestureNode<Int>(traits: nil, tag: .init(rawValue: "test"), relations: []),
                #/\<GestureNode<Int>: 0x[0-9a-f]+ "test"; id = \d+; phase = idle>/#
            ),
            (
                GestureNode<Double>(traits: nil, tag: .init(rawValue: "test2"), relations: []),
                #/\<GestureNode<Double>: 0x[0-9a-f]+ "test2"; id = \d+; phase = idle>/#
            ),
        ] as [(AnyGestureNode, Regex<Substring>)]
    )
    func debugLabel(node: AnyGestureNode, _ regex: Regex<Substring>) throws {
        let label = node.debugLabel
        #expect(label.wholeMatch(of: regex) != nil, "\(label) does not match regex")
    }
}
