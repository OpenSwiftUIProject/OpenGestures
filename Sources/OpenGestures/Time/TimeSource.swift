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

extension Never: TimeSource {
    public var timestamp: Timestamp {
        _openGesturesUnreachableCode()
    }
}

// MARK: - TimeSourceImpl

public protocol TimeSourceImpl: TimeSource {
    var _duration: Duration { get }
}

extension TimeSourceImpl {
    @_spi(Private)
    public var timestamp: Timestamp {
        Timestamp(value: _duration)
    }
}
