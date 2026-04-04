public import CoreGraphics

// MARK: - MouseEvent

public struct MouseEvent: SpatialEvent, Sendable {
    public var id: EventID
    public var phase: EventPhase
    public var timestamp: Timestamp
    public var location: CGPoint
    public var button: Button

    public init(id: EventID, phase: EventPhase, timestamp: Timestamp, location: CGPoint, button: Button) {
        self.id = id
        self.phase = phase
        self.timestamp = timestamp
        self.location = location
        self.button = button
    }

    public enum Button: Hashable, Sendable {
        case primary
        case secondary
        case tertiary
    }
}
