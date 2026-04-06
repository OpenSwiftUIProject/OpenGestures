//
//  OGFShims.swift
//  OpenGesturesCompatibilityTests

#if OPENGESTURES
@_exported public import OpenGestures

let compatibilityTestEnabled = false
#else
@_exported public import Gestures
#if os(iOS) && !targetEnvironment(simulator)
public import _GesturesDeviceSwiftShims
#endif

public typealias OGFGesturePhase = GFGesturePhase
public typealias OGFGestureRelationType = GFGestureRelationType
public typealias OGFGestureRelationRole = GFGestureRelationRole
public typealias OGFGestureFailureType = GFGestureFailureType

public let OGFGestureNodeCreateDefault = GFGestureNodeCreateDefault
public let OGFGestureNodeDefaultValue = GFGestureNodeDefaultValue
public let OGFGestureNodeCoordinatorCreate = GFGestureNodeCoordinatorCreate
public let OGFGestureComponentControllerSetNode = GFGestureComponentControllerSetNode
public let OGFGestureFailureTypeIsTerminated = GFGestureFailureTypeIsTerminated

public let compatibilityTestEnabled = true
#endif
