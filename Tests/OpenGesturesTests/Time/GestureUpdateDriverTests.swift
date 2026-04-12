//
//  GestureUpdateDriverTests.swift
//  OpenGesturesTests

#if canImport(Darwin)
@testable import OpenGestures
import Testing

@Suite
struct GestureUpdateDriverTests {
    @Test
    func registerAndUnregister() {
        let driver = RunLoopUpdateDriver()
        var called = false
        let token = driver.register { called = true }
        #expect(called == false)
        #expect(driver.listeners.count == 1)
        driver.unregister(token: token)
        #expect(driver.listeners.isEmpty)
    }

    @Test
    func tokenStartsAtOne() {
        let driver = RunLoopUpdateDriver()
        let t1 = driver.register {}
        let t2 = driver.register {}
        #expect(t1.value > 0)
        #expect(t2.value > t1.value)
        driver.unregister(token: t1)
        driver.unregister(token: t2)
    }

    @Test
    func multipleListeners() {
        let driver = RunLoopUpdateDriver()
        let t1 = driver.register {}
        let t2 = driver.register {}
        let t3 = driver.register {}
        #expect(driver.listeners.count == 3)
        driver.unregister(token: t2)
        #expect(driver.listeners.count == 2)
        driver.unregister(token: t1)
        driver.unregister(token: t3)
        #expect(driver.listeners.isEmpty)
    }
}
#endif
