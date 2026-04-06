//
//  OGFShims.swift
//  OpenGesturesShims

public struct GesturesFrameworkVendor: RawRepresentable, Hashable, CaseIterable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.rawValue = value }

    public static let openGestures: GesturesFrameworkVendor = "org.OpenSwiftUIProject.OpenGestures"
    public static let gestures: GesturesFrameworkVendor = "com.apple.Gestures"

    public static var allCases: [GesturesFrameworkVendor] { [.openGestures, .gestures] }
}

#if OPENGESTURES_GESTURES
@_exported import Gestures

public typealias OGFGesturePhase = GFGesturePhase
public typealias OGFGestureRelationType = GFGestureRelationType
public typealias OGFGestureRelationRole = GFGestureRelationRole
public typealias OGFGestureFailureType = GFGestureFailureType

public let OGFGestureNodeCreateDefault = GFGestureNodeCreateDefault
public let OGFGestureNodeDefaultValue = GFGestureNodeDefaultValue
public let OGFGestureNodeCoordinatorCreate = GFGestureNodeCoordinatorCreate
public let OGFGestureComponentControllerSetNode = GFGestureComponentControllerSetNode
public let OGFGestureFailureTypeIsTerminated = GFGestureFailureTypeIsTerminated

public let gesturesVendor: GesturesFrameworkVendor = .gestures
#else
@_exported import OpenGestures
public let gesturesVendor: GesturesFrameworkVendor = .openGestures
#endif
