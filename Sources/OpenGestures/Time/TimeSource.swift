//
//  TimeSource.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - TimeSource

public protocol TimeSource {
    var timestamp: Timestamp { get }
}

// MARK: - TimeSourceImpl

public protocol TimeSourceImpl: TimeSource {
    var _duration: Duration { get }
}

extension TimeSourceImpl {
    public var timestamp: Timestamp {
        Timestamp(value: _duration)
    }
}
