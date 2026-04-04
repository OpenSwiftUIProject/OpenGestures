public import CoreGraphics

// MARK: - Event

/// A protocol representing an input event.
public protocol Event: Sendable {
    var id: EventID { get }
    var phase: EventPhase { get }
}

/// A spatial event with a location.
public protocol SpatialEvent: Event {
    var location: CGPoint { get }
}

/// A scroll event with delta values.
public protocol ScrollEvent: Event {
    var delta: CGVector { get }
    var acceleratedDelta: CGVector { get }
}

// MARK: - EventID

public struct EventID: Hashable, Sendable, CustomStringConvertible {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public var description: String {
        "EventID(\(rawValue))"
    }
}

// MARK: - Timestamp

public struct Timestamp: Hashable, Comparable, Sendable, CustomStringConvertible {
    public var value: Duration

    public init(value: Duration) {
        self.value = value
    }

    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.value < rhs.value
    }

    public var description: String {
        "\(value)"
    }

    public func advanced(by duration: Duration) -> Timestamp {
        Timestamp(value: value + duration)
    }

    public func duration(to other: Timestamp) -> Duration {
        other.value - value
    }
}
