//
//  Event.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Event

public protocol Event: Identifiable {
    var id: EventID { get }
    var phase: EventPhase { get }
    var timestamp: Timestamp { get }
}

// MARK: - Never + Event

extension Never: Event {
    public var id: EventID { fatalError() }
    public var phase: EventPhase { fatalError() }
}

// MARK: - EventPhase

public enum EventPhase: Hashable {
    case began
    case active
    case ended
    case failed
}
