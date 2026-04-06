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
