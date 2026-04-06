#if canImport(Darwin)
import Foundation

// MARK: - RunLoopUpdateDriver

/// Drives gesture updates via CFRunLoop observer, synced with the main run loop.
public final class RunLoopUpdateDriver: GestureUpdateDriver, @unchecked Sendable {

    private var handlers: [UInt32: () -> Void] = [:]
    private var nextToken: UInt32 = 0
    private var observer: CFRunLoopObserver?

    public init() {}

    public func register(_ handler: @escaping () -> Void) -> GestureUpdateDriverToken {
        let token = nextToken
        nextToken += 1
        handlers[token] = handler

        if observer == nil {
            setupObserver()
        }

        return GestureUpdateDriverToken(value: token)
    }

    public func unregister(token: GestureUpdateDriverToken) {
        handlers.removeValue(forKey: token.value)

        if handlers.isEmpty, let observer {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, .commonModes)
            self.observer = nil
        }
    }

    private func setupObserver() {
        observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { [weak self] _, _ in
            self?.fireHandlers()
        }
        if let observer {
            CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
        }
    }

    private func fireHandlers() {
        for handler in handlers.values {
            handler()
        }
    }

    deinit {
        if let observer {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, .commonModes)
        }
    }
}

#endif
