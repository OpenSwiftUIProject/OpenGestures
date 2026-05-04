//
//  CompositeGestureComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenGestures
import Testing

// MARK: - CompositeGestureComponentTests

@Suite
struct CompositeGestureComponentTests {
    @Test
    func statefulCompositeResetResetsUpstreamAndState() {
        var component = StatefulCompositeStub(
            upstream: ResettableStub(),
            state: StatefulCompositeStub.State(value: 42)
        )

        component.reset()

        #expect(component.upstream.resetCount == 1)
        #expect(component.state.value == 0)
    }
}

private struct StatefulCompositeStub: CompositeGestureComponent, StatefulGestureComponent {
    var upstream: ResettableStub
    var state: State

    func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
        .empty(.noData, metadata: nil)
    }

    struct State: GestureComponentState {
        var value: Int

        init() {
            value = 0
        }

        init(value: Int) {
            self.value = value
        }
    }
}

private struct ResettableStub: GestureComponent {
    var resetCount = 0

    func update(context: GestureComponentContext) throws -> GestureOutput<Int> {
        .empty(.noData, metadata: nil)
    }

    mutating func reset() {
        resetCount += 1
    }

    func traits() -> GestureTraitCollection? {
        nil
    }

    func capacity<E: Event>(for eventType: E.Type) -> Int {
        0
    }
}
