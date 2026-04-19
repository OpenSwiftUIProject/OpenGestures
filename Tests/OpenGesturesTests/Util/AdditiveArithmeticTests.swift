//
//  AdditiveArithmeticTests.swift
//  OpenGesturesTests

import OpenCoreGraphicsShims
import OpenGestures
import Testing

@Suite
struct AdditiveArithmeticTests {
    @Test
    func doubleOperations() {
        #expect(Double.zero == 0.0)
        #expect(3.0 + 2.0 == 5.0)
        #expect(3.0 - 2.0 == 1.0)

        var value = 4.0
        value += 1.5
        #expect(value == 5.5)
        value -= 2.5
        #expect(value == 3.0)
    }

    @Test
    func pointOperations() {
        #expect(CGPoint.zero == CGPoint(x: 0, y: 0))
        #expect(
            CGPoint(x: 3, y: 4) + CGPoint(x: 1, y: 2)
                == CGPoint(x: 4, y: 6)
        )
        #expect(
            CGPoint(x: 3, y: 4) - CGPoint(x: 1, y: 2)
                == CGPoint(x: 2, y: 2)
        )

        var point = CGPoint(x: 2, y: 3)
        point += CGPoint(x: 4, y: 5)
        #expect(point == CGPoint(x: 6, y: 8))
        point -= CGPoint(x: 1, y: 1)
        #expect(point == CGPoint(x: 5, y: 7))
    }

    @Test
    func vectorAndSizeOperations() {
        #expect(
            CGVector(dx: 5, dy: 7) + CGVector(dx: 1, dy: 2)
                == CGVector(dx: 6, dy: 9)
        )
        #expect(
            CGVector(dx: 5, dy: 7) - CGVector(dx: 1, dy: 2)
                == CGVector(dx: 4, dy: 5)
        )

        #expect(
            CGSize(width: 8, height: 6) + CGSize(width: 2, height: 1)
                == CGSize(width: 10, height: 7)
        )
        #expect(
            CGSize(width: 8, height: 6) - CGSize(width: 2, height: 1)
                == CGSize(width: 6, height: 5)
        )
    }
}
