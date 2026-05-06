//
//  InterpolatableTests.swift
//  OpenGesturesTests

import OpenCoreGraphicsShims
import OpenGestures
import Testing

@Suite
struct InterpolatableTests {
    @Test(arguments: [
        (
            CGPoint(x: 10, y: 20),
            CGPoint(x: 2, y: 6),
            0.25,
            CGPoint(x: 4, y: 9.5)
        ),
        (
            CGPoint(x: -4, y: 8),
            CGPoint(x: 12, y: -16),
            0.5,
            CGPoint(x: 4, y: -4)
        ),
        (
            CGPoint(x: 3, y: -9),
            CGPoint(x: -5, y: 7),
            1,
            CGPoint(x: 3, y: -9)
        ),
    ])
    func pointMixWeightsFirstOperandByT(
        _ lhs: CGPoint,
        _ rhs: CGPoint,
        _ t: Double,
        _ expected: CGPoint
    ) {
        #expect(CGPoint.mix(lhs, rhs, by: t) == expected)

        var value = rhs
        value.mix(with: lhs, by: t)
        #expect(value == expected)
    }

    @Test(arguments: [
        (
            CGVector(dx: 10, dy: 20),
            CGVector(dx: 2, dy: 6),
            0.25,
            CGVector(dx: 4, dy: 9.5)
        ),
        (
            CGVector(dx: -4, dy: 8),
            CGVector(dx: 12, dy: -16),
            0.5,
            CGVector(dx: 4, dy: -4)
        ),
        (
            CGVector(dx: 3, dy: -9),
            CGVector(dx: -5, dy: 7),
            1,
            CGVector(dx: 3, dy: -9)
        ),
    ])
    func vectorMixWeightsFirstOperandByT(
        _ lhs: CGVector,
        _ rhs: CGVector,
        _ t: Double,
        _ expected: CGVector
    ) {
        #expect(CGVector.mix(lhs, rhs, by: t) == expected)

        var value = rhs
        value.mix(with: lhs, by: t)
        #expect(value == expected)
    }

    @Test(arguments: [
        (
            CGPoint(x: 10, y: 20),
            4.0,
            CGPoint(x: 2.5, y: 5)
        ),
        (
            CGPoint(x: -8, y: 12),
            2.0,
            CGPoint(x: -4, y: 6)
        ),
        (
            CGPoint(x: 3, y: -9),
            1.0,
            CGPoint(x: 3, y: -9)
        ),
    ])
    func pointScaledByInverseOfUsesReciprocalScale(
        _ value: CGPoint,
        _ scale: Double,
        _ expected: CGPoint
    ) {
        #expect(value.scaled(byInverseOf: scale) == expected)
    }

    @Test(arguments: [
        (
            CGVector(dx: 10, dy: 20),
            4.0,
            CGVector(dx: 2.5, dy: 5)
        ),
        (
            CGVector(dx: -8, dy: 12),
            2.0,
            CGVector(dx: -4, dy: 6)
        ),
        (
            CGVector(dx: 3, dy: -9),
            1.0,
            CGVector(dx: 3, dy: -9)
        ),
    ])
    func vectorScaledByInverseOfUsesReciprocalScale(
        _ value: CGVector,
        _ scale: Double,
        _ expected: CGVector
    ) {
        #expect(value.scaled(byInverseOf: scale) == expected)
    }
}
