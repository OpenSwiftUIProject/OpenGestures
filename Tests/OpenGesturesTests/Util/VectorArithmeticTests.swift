//
//  VectorArithmeticTests.swift
//  OpenGesturesTests

import OpenCoreGraphicsShims
import OpenGestures
import Testing

@Suite
struct VectorArithmeticTests {
    @Test
    func doubleMagnitudeAndScaling() {
        #expect(12.0.magnitude == 12.0)
        #expect((-12.0).magnitude == 12.0)
        #expect(12.0.scaled(by: 0.25) == 3.0)
    }

    @Test
    func pointMagnitudeAndScaling() {
        let point = CGPoint(x: 3, y: 4)
        #expect(point.magnitude == 5.0)
        #expect(point.scaled(by: 2) == CGPoint(x: 6, y: 8))
    }

    @Test
    func vectorMagnitudeAndScaling() {
        let vector = CGVector(dx: 5, dy: 12)
        #expect(vector.magnitude == 13.0)
        #expect(vector.scaled(by: 0.5) == CGVector(dx: 2.5, dy: 6.0))
    }
}
