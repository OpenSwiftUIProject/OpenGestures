//
//  UpdateScheduler.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - UpdateScheduler

public final class UpdateScheduler {
    package let timeScheduler: any TimeScheduler

    package var scheduledRequests: [UpdateRequest: TimeSchedulerToken]

    package init(
        timeScheduler: any TimeScheduler,
        scheduledRequests: [UpdateRequest : TimeSchedulerToken]
    ) {
        self.timeScheduler = timeScheduler
        self.scheduledRequests = scheduledRequests
    }

    // TBA
    package func schedule(
        _ requests: [UpdateRequest],
        handler: @escaping (Set<UInt32>) -> Void
    ) {
        for request in requests {
            if let token = scheduledRequests[request] {
                timeScheduler.cancel(token: token)
            }
            let token = timeScheduler.schedule(
                after: request.targetTime - timestamp,
                handler: { handler([request.id]) },
                cancelHandler: nil
            )
            scheduledRequests[request] = token
        }
    }

    package func cancel(_ requests: [UpdateRequest]) {
        for request in requests {
            guard let token = scheduledRequests.removeValue(forKey: request) else {
                continue
            }
            timeScheduler.cancel(token: token)
        }
    }

    package func cancelAll() {
        let requests = scheduledRequests.keys
        for request in requests {
            guard let token = scheduledRequests.removeValue(forKey: request) else {
                continue
            }
            timeScheduler.cancel(token: token)
        }
    }
}

@_spi(Private)
extension UpdateScheduler: TimeSource {
    public var timestamp: Timestamp {
        timeScheduler.timestamp
    }
}

// MARK: - UpdateRequest

package struct UpdateRequest: Hashable, Identifiable, CustomStringConvertible {
    package let id: UInt32
    package let creationTime: Timestamp
    package let targetTime: Timestamp
    package let tag: String?

    package init(
        id: UInt32,
        creationTime: Timestamp,
        targetTime: Timestamp,
        tag: String?
    ) {
        self.id = id
        self.creationTime = creationTime
        self.targetTime = targetTime
        self.tag = tag
    }

    package var description: String {
        let duration = targetTime - creationTime
        var result = "{ \(id)"
        if let tag {
            result += " \"\(tag)\""
        }
        result += ", \(duration) }"
        return result
    }
}
