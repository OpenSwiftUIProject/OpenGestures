//
//  NestedCustomStringConvertibleTests.swift
//  OpenGesturesTests

@_spi(Private) import OpenGestures
import Testing

// MARK: - Test Helpers

private struct TestNode: NestedCustomStringConvertible {
    var name: String
    var children: [TestNode] = []

    func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .hideIdentity])
        if children.isEmpty {
            nested.customPrefix = name
            nested.customSuffix = ""
        } else {
            nested.customPrefix = name + " {"
            nested.customSuffix = "}"
            for child in children {
                var childNested = NestedDescription(depth: nested.depth + 1, target: child)
                child.populateNestedDescription(&childNested)
                nested.append(childNested.description)
            }
        }
    }
}

// MARK: - Tests

@Suite
struct NestedCustomStringConvertibleTests {
    @Test
    func leafDescription() {
        let leaf = TestNode(name: "tap")
        #expect(leaf.description == "tap")
    }

    @Test
    func leafDebugDescription() {
        let leaf = TestNode(name: "pan")
        #expect(leaf.debugDescription == "pan")
    }

    @Test
    func containerWithOneChild() {
        let c = TestNode(name: "Root", children: [TestNode(name: "child1")])
        #expect(c.description == #"""
        Root {
          child1
        }
        """#)
    }

    @Test
    func containerWithMultipleChildren() {
        let c = TestNode(name: "Root", children: [
            TestNode(name: "a"),
            TestNode(name: "b"),
            TestNode(name: "c"),
        ])
        #expect(c.description == #"""
        Root {
          a
          b
          c
        }
        """#)
    }

    @Test
    func emptyContainer() {
        let c = TestNode(name: "Empty")
        #expect(c.description == "Empty")
    }

    @Test
    func nestedContainers() {
        let c = TestNode(name: "L0", children: [
            TestNode(name: "L1", children: [
                TestNode(name: "leaf"),
            ]),
        ])
        #expect(c.description == #"""
        L0 {
          L1 {
            leaf
          }
        }
        """#)
    }
}
