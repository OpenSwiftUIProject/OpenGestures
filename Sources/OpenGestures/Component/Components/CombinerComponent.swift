//
//  CombinerComponent.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - CombinerElement

package struct CombinerElement<Upstream>: Sendable where Upstream: GestureComponent {
    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var cachedOutput: GestureOutput<Upstream.Value>?
        package var isDirty: Bool

        package init() {
            cachedOutput = nil
            isDirty = false
        }
    }

    package var upstream: Upstream
    package var state: State

    package init(
        upstream: Upstream,
        state: State = State()
    ) {
        self.upstream = upstream
        self.state = state
    }
}

extension CombinerElement: ReplicatingValue {
    package func replicated() -> Self {
        var copy = self
        copy.reset()
        return copy
    }
}

extension CombinerElement: GestureComponent {
    package typealias Value = Upstream.Value

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        state.isDirty = true
        guard let cachedOutput = state.cachedOutput, cachedOutput.isFinal else {
            let output = try upstream.tracingUpdate(context: context)
            guard !output.isEmpty else {
                guard let cachedOutput = state.cachedOutput else {
                    return output
                }
                return cachedOutput.copyWithCombinedMetadata(
                    output.metadata ?? GestureOutputMetadata()
                )
            }
            state.cachedOutput = output.copyClearingMetadata()
            return output
        }
        return cachedOutput
    }

    package mutating func reset() {
        guard state.isDirty else {
            return
        }
        state = State()
        upstream.reset()
    }

    package mutating func traits() -> GestureTraitCollection? {
        state.isDirty = true
        return upstream.traits()
    }

    package mutating func capacity<EventType: Event>(for eventType: EventType.Type) -> Int {
        state.isDirty = true
        guard let cachedOutput = state.cachedOutput, cachedOutput.isFinal else {
            return upstream.capacity(for: eventType)
        }
        return 0
    }
}

extension CombinerElement: StatefulGestureComponent {}

extension CombinerElement: CompositeGestureComponent {}
