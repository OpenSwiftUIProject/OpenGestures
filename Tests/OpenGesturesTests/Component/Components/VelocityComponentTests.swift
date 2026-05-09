//
//  VelocityComponentTests.swift
//  OpenGesturesTests
//
//  Generated

import OpenCoreGraphicsShims
import OpenGestures
import Testing

// MARK: - VelocityComponentTests

@Suite
struct VelocityComponentTests {
    @Test
    func firstValueProducesZeroVelocityAndStoresState() throws {
        var component = VelocityComponent(
            upstream: PointStubComponent(outputs: [
                .value(CGPoint(x: 10, y: 0), metadata: nil),
            ]),
            interpolationWeight: 1
        )

        let output = try component.update(context: velocityContext(currentTime: .seconds(1)))

        guard case let .value(result, metadata) = output else {
            Issue.record("Expected velocity value")
            return
        }
        #expect(result.value == CGPoint(x: 10, y: 0))
        #expect(result.velocity == CGPoint.zero)
        #expect(component.state.previousValue == CGPoint(x: 10, y: 0))
        #expect(component.state.previousVelocity == CGPoint.zero)
        #expect(component.state.previousTime == Timestamp(value: .seconds(1)))
        #expect(metadata == nil)
    }

    @Test
    func computesVelocityFromElapsedTime() throws {
        var component = VelocityComponent(
            upstream: PointStubComponent(outputs: [
                .value(CGPoint(x: 10, y: 0), metadata: nil),
            ]),
            state: VelocityComponent<PointStubComponent>.State(
                previousValue: CGPoint.zero,
                previousVelocity: nil,
                previousTime: Timestamp(value: .seconds(1))
            ),
            interpolationWeight: 1
        )

        let output = try component.update(context: velocityContext(currentTime: .seconds(3)))

        guard case let .value(result, metadata) = output else {
            Issue.record("Expected velocity value")
            return
        }
        #expect(result.velocity == CGPoint(x: 5, y: 0))
        #expect(component.state.previousVelocity == CGPoint(x: 5, y: 0))
        #expect(metadata == nil)
    }

    @Test
    func interpolatesRawVelocityWithPreviousVelocity() throws {
        var component = VelocityComponent(
            upstream: PointStubComponent(outputs: [
                .value(CGPoint(x: 20, y: 0), metadata: nil),
            ]),
            state: VelocityComponent<PointStubComponent>.State(
                previousValue: CGPoint.zero,
                previousVelocity: CGPoint(x: 2, y: 0),
                previousTime: Timestamp(value: .zero)
            ),
            interpolationWeight: 0.25
        )

        let output = try component.update(context: velocityContext(currentTime: .seconds(2)))

        guard case let .value(result, _) = output else {
            Issue.record("Expected velocity value")
            return
        }
        #expect(result.velocity == CGPoint(x: 8, y: 0))
    }

    @Test
    func reusesPreviousVelocityForSubMillisecondElapsedTime() throws {
        var component = VelocityComponent(
            upstream: PointStubComponent(outputs: [
                .value(CGPoint(x: 20, y: 0), metadata: nil),
            ]),
            state: VelocityComponent<PointStubComponent>.State(
                previousValue: CGPoint.zero,
                previousVelocity: CGPoint(x: 7, y: 0),
                previousTime: Timestamp(value: .zero)
            ),
            interpolationWeight: 1
        )

        let output = try component.update(context: velocityContext(currentTime: .microseconds(500)))

        guard case let .value(result, _) = output else {
            Issue.record("Expected velocity value")
            return
        }
        #expect(result.velocity == CGPoint(x: 7, y: 0))
    }
}

private func velocityContext(currentTime: Duration) -> GestureComponentContext {
    GestureComponentContext(
        startTime: Timestamp(value: .zero),
        currentTime: Timestamp(value: currentTime),
        updateSource: .event,
        eventStore: EventStore<Never>()
    )
}

private struct PointStubComponent: GestureComponent {
    var outputs: [GestureOutput<CGPoint>]

    mutating func update(context: GestureComponentContext) throws -> GestureOutput<CGPoint> {
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
