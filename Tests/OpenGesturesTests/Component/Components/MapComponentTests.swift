//
//  MapComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - MapComponentTests

@Suite
struct MapComponentTests {
    @Test
    func mapsWholeGestureOutput() throws {
        var component = MapComponent<MapStubComponent, String>(
            upstream: MapStubComponent(outputs: [
                .value(3, metadata: nil),
            ]),
            map: { output in
                guard case let .value(value, metadata) = output else {
                    return .empty(.filtered, metadata: nil)
                }
                return .value(String(value * 2), metadata: metadata)
            }
        )

        let output = try component.update(context: mapComponentContext())

        guard case let .value(value, metadata) = output else {
            Issue.record("Expected mapped value output")
            return
        }
        #expect(value == "6")
        #expect(metadata == nil)
    }
}

private func mapComponentContext() -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: .zero),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct MapStubComponent: GestureComponent {
    var outputs: [GestureOutput<Int>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
        outputs.removeFirst()
    }

    mutating func reset() {
        outputs.removeAll()
    }

    func traits() -> GestureTraitCollection? {
        nil
    }

    func capacity<E: Event>(for eventType: E.Type) -> Int {
        0
    }
}
