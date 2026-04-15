//
//  ScrollEvent.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

public import OpenCoreGraphicsShims

// MARK: - ScrollEvent

/// A scroll event with delta values.
public protocol ScrollEvent: SpatialEvent {
    var delta: CGVector { get }
    var acceleratedDelta: CGVector { get }
}

// MARK: - Never + ScrollEvent

extension Never: ScrollEvent {
    public var delta: CGVector { fatalError() }
    public var acceleratedDelta: CGVector { fatalError() }
}

// MARK: - ConcreteScrollEvent

public struct ConcreteScrollEvent: ScrollEvent {
    public var id: EventID
    public var phase: EventPhase
    public var timestamp: Timestamp
    public var location: CGPoint
    public var delta: CGVector
    public var acceleratedDelta: CGVector

    public init(
        id: EventID,
        phase: EventPhase,
        timestamp: Timestamp,
        location: CGPoint,
        delta: CGVector,
        acceleratedDelta: CGVector
    ) {
        self.id = id
        self.phase = phase
        self.timestamp = timestamp
        self.location = location
        self.delta = delta
        self.acceleratedDelta = acceleratedDelta
    }
}

extension ConcreteScrollEvent: NestedCustomStringConvertible {}
