//
//  SpatialEvent.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - SpatialEvent

/// A spatial event with a location.
public protocol SpatialEvent: Event, LocationContaining {}

// MARK: - Never + SpatialEvent

extension Never: SpatialEvent {}
