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
#endif

@_cdecl("OGFGestureComponentControllerSetNode")
public func ogfGestureComponentControllerSetNode(
    _ controller: AnyObject,
    _ node: (any OGFGestureNode)?
) {
    let controller = unsafeBitCast(controller, to: AnyGestureComponentController.self)
    let shim = unsafeBitCast(node, to: AnyGestureNodeShim.self)
    let newNode: AnyGestureNode?
    if let node {
        newNode = shim.node
    } else {
        newNode = nil
    }
    let previousNode = controller.node
    controller.node = newNode
    if controller.node == nil, previousNode != nil {
        controller.reset()
    }
}

@_cdecl("OGFGestureFailureTypeIsTerminated")
public func ogfGestureFailureTypeIsTerminated(
    _ type: OGFGestureFailureType
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
