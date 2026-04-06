//
//  OGFShims.swift
//  OpenGesturesCompatibilityTests

#if OPENGESTURES
@_exported import OpenGestures
let compatibilityTestEnabled = false
#else
@_exported public import Gestures
public typealias OGFGesturePhase = GFGesturePhase
public typealias OGFGestureRelationType = GFGestureRelationType
public typealias OGFGestureRelationRole = GFGestureRelationRole
public typealias OGFGestureFailureType = GFGestureFailureType
public let compatibilityTestEnabled = true
#endif
