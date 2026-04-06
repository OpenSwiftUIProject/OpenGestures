//
//  OGFGestureFunctions.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

#if canImport(ObjectiveC)

@_cdecl("OGFGestureNodeDefaultValue")
public func ogfGestureNodeDefaultValue() -> Any {
    ()
}

@_cdecl("OGFGestureNodeCreateDefault")
public func ogfGestureNodeCreateDefault(key: Int) -> any OGFGestureNode {
    // TODO: Create AnyGestureNodeShim with key
    preconditionFailure("")
}

@_cdecl("OGFGestureNodeCoordinatorCreate")
public func ogfGestureNodeCoordinatorCreate(
    _ willUpdateHandler: (() -> Void)?,
    _ didUpdateHandler: (() -> Void)?
) -> any OGFGestureNodeCoordinator {
    // TODO: Create GestureNodeCoordinatorShim
    preconditionFailure("")
}

@_cdecl("OGFGestureComponentControllerSetNode")
public func ogfGestureComponentControllerSetNode(
    _ controller: AnyObject,
    _ node: (any OGFGestureNode)?
) {
    guard let _ = controller as? AnyGestureComponentController else { return }
    preconditionFailure("")
}

#else

public func OGFGestureNodeDefaultValue() -> Any {
    ()
}

public func OGFGestureNodeCreateDefault(_ key: Int) -> any OGFGestureNode {
    _openGesturesPlatformUnimplementedFailure()
}

public func OGFGestureNodeCoordinatorCreate(
    _ willUpdateHandler: (() -> Void)?,
    _ didUpdateHandler: (() -> Void)?
) -> any OGFGestureNodeCoordinator {
    _openGesturesPlatformUnimplementedFailure()
}

public func OGFGestureComponentControllerSetNode(
    _ controller: AnyObject,
    _ node: (any OGFGestureNode)?
) {
    _openGesturesPlatformUnimplementedFailure()
}

public func OGFGestureFailureTypeIsTerminated(_ type: OGFGestureFailureType) -> Bool {
    ogfGestureFailureTypeIsTerminated(type: type)
}

#endif

@_cdecl("OGFGestureFailureTypeIsTerminated")
public func ogfGestureFailureTypeIsTerminated(
    type: OGFGestureFailureType
) -> Bool {
    switch type {
    case .customError, .disabled, .activationDenied, .aborted:
        return true
    case .excluded, .failureDependency, .removedFromContainer, .coordinatorChanged:
        return false
    @unknown default:
        return false
    }
}
