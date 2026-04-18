//
//  RingBufferTests.swift
//  OpenGesturesTests

@_spi(Private) import OpenGestures
import Testing

// MARK: - RingBufferTests

@Suite
struct RingBufferTests {

    // MARK: - Init

    @Test
    func testInit() {
        let buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        #expect(buffer.capacity == 5)
        #expect(buffer.count == 0)
        #expect(buffer.isEmpty == true)
        #expect(buffer.isFull == false)
        #expect(buffer.start == 0)
        #expect(buffer.end == 0)
        #expect(buffer.storage == [0, 0, 0, 0, 0])
    }

    // MARK: - Append

    @Test
    func testAppendSingle() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        #expect(buffer.count == 1)
        #expect(buffer.isEmpty == false)
        #expect(buffer.start == 0)
        #expect(buffer.end == 1)
    }

    @Test
    func testAppendMultiple() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        #expect(buffer.count == 3)
        #expect(buffer[0] == 1)
        #expect(buffer[1] == 2)
        #expect(buffer[2] == 3)
    }

    @Test
    func testAppendOverflow() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        for i in 1...6 {
            buffer.append(i)
        }
        #expect(buffer.count == 5)
        #expect(buffer.isFull == true)
        #expect(buffer.start == 1)
        #expect(buffer[0] == 2)
        #expect(buffer[4] == 6)
    }

    // MARK: - RemoveFirst

    @Test
    func testRemoveFirst() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        let first = buffer.removeFirst()
        #expect(first == 1)
        #expect(buffer.count == 2)
    }

    @Test
    func testRemoveFirstClearsSlot() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        buffer.removeFirst()
        #expect(buffer.storage[0] == 0)
    }

    // MARK: - Collection

    @Test
    func testStartIndexEndIndex() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        #expect(buffer.startIndex == 0)
        #expect(buffer.endIndex == buffer.count)
    }

    @Test
    func testSubscript() {
        var buffer = RingBuffer<Int>(capacity: 3, emptyValue: 0)
        for i in 1...5 {
            buffer.append(i)
        }
        #expect(buffer[0] == 3)
        #expect(buffer[1] == 4)
        #expect(buffer[2] == 5)
    }

    @Test
    func testIndexAfter() {
        let buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        #expect(buffer.index(after: 0) == 1)
    }

    @Test
    func testIndexBefore() {
        let buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        #expect(buffer.index(before: 2) == 1)
    }

    // MARK: - Sequence / Iterator

    @Test
    func testIterator() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        var collected: [Int] = []
        for element in buffer {
            collected.append(element)
        }
        #expect(collected == [1, 2, 3])
    }

    @Test
    func testIteratorAfterWrapAround() {
        var buffer = RingBuffer<Int>(capacity: 3, emptyValue: 0)
        for i in 1...5 {
            buffer.append(i)
        }
        var collected: [Int] = []
        for element in buffer {
            collected.append(element)
        }
        #expect(collected == [3, 4, 5])
    }

    @Test
    func testMap() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        let doubled = buffer.map { $0 * 2 }
        #expect(doubled == [2, 4, 6])
    }

    // MARK: - Description

    @Test
    func testDescriptionEmpty() {
        let buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        #expect(buffer.description == "[]")
    }

    @Test
    func testDescriptionWithElements() {
        var buffer = RingBuffer<Int>(capacity: 5, emptyValue: 0)
        buffer.append(1)
        buffer.append(2)
        buffer.append(3)
        #expect(buffer.description == "[1, 2, 3]")
    }
}

