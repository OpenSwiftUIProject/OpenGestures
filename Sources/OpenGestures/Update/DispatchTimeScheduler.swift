public import Foundation

// MARK: - DispatchTimeScheduler

/// GCD-based timer scheduler for gesture timing operations.
///
/// Used for timed gesture operations like longPress minimumDuration.
public final class DispatchTimeScheduler: @unchecked Sendable {

    private let queue: DispatchQueue
    private let timeSource: any TimeSource
    private var nextToken: Int = 0
    private var workItems: [Int: DispatchWorkItem] = [:]

    public init(queue: DispatchQueue, timeSource: any TimeSource) {
        self.queue = queue
        self.timeSource = timeSource
    }

    public var timestamp: Timestamp {
        timeSource.timestamp
    }

    /// Schedules a handler to run after `duration`.
    public func schedule(
        after duration: Duration,
        handler: @escaping () -> Void,
        cancelHandler: (() -> Void)? = nil
    ) -> TimeSchedulerToken {
        let token = nextToken
        nextToken += 1

        let workItem = DispatchWorkItem { [weak self] in
            self?.workItems.removeValue(forKey: token)
            handler()
        }
        workItems[token] = workItem

        let nanoseconds = Int(duration.components.seconds) * 1_000_000_000
            + Int(duration.components.attoseconds / 1_000_000_000)
        queue.asyncAfter(
            deadline: .now() + .nanoseconds(nanoseconds),
            execute: workItem
        )

        return TimeSchedulerToken(rawValue: token)
    }

    /// Cancels a scheduled handler.
    public func cancel(token: TimeSchedulerToken) {
        if let workItem = workItems.removeValue(forKey: token.rawValue) {
            workItem.cancel()
        }
    }
}

// MARK: - TimeSchedulerToken

public struct TimeSchedulerToken: Hashable, Sendable {
    public var rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
}
