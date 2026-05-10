//
//  ReplicatingListTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - ReplicatingListTests

@Suite
struct ReplicatingListTests {

    // MARK: - Storage

    @Test
    func testReplicationAndResizingPreservePrototypeStorage() {
        var list = ReplicatingList(prototype: ReplicatingValueProbe(id: 7, generation: 0))

        #expect(list.isEmpty == true)
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 0))

        list.appendReplications(2)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 1),
            ReplicatingValueProbe(id: 7, generation: 1),
        ])

        list.remove(at: 0)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 1),
        ])
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 2))

        list.remove(at: 0)

        #expect(list.isEmpty == true)
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 2))

        list.resize(to: 0)

        #expect(list.isEmpty == true)
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 2))

        list.resize(to: 1)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 3),
        ])

        list.appendReplications(2)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 3),
            ReplicatingValueProbe(id: 7, generation: 4),
            ReplicatingValueProbe(id: 7, generation: 4),
        ])
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 4))

        list.appendReplications(1)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 3),
            ReplicatingValueProbe(id: 7, generation: 4),
            ReplicatingValueProbe(id: 7, generation: 4),
            ReplicatingValueProbe(id: 7, generation: 4),
        ])

        list.removeLast(2)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 3),
            ReplicatingValueProbe(id: 7, generation: 4),
        ])
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 4))

        list.removeLast(1)

        #expect(Array(list) == [
            ReplicatingValueProbe(id: 7, generation: 3),
        ])
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 4))

        list.removeLast(1)

        #expect(list.isEmpty == true)
        #expect(list.prototype() == ReplicatingValueProbe(id: 7, generation: 4))

        var multipleToEmpty = ReplicatingList(prototype: ReplicatingValueProbe(id: 8, generation: 0))
        multipleToEmpty.appendReplications(2)
        multipleToEmpty.removeLast(2)

        #expect(multipleToEmpty.isEmpty == true)
        #expect(multipleToEmpty.prototype() == ReplicatingValueProbe(id: 8, generation: 2))
    }
}

// MARK: - ReplicatingValueProbe

private struct ReplicatingValueProbe: Equatable, ReplicatingValue {
    var id: Int
    var generation: Int

    func replicated() -> Self {
        Self(id: id, generation: generation + 1)
    }
}
