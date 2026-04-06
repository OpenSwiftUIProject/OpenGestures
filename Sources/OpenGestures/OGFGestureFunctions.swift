//
//  OGFGestureFunctions.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

#if canImport(ObjectiveC)

// MARK: - OGFGestureNodeCreateDefault

@_cdecl("OGFGestureNodeCreateDefault")
package func _OGFGestureNodeCreateDefault(_ key: Int) -> AnyObject {
    // TODO: Create AnyGestureNodeShim with key
    fatalError("TODO")
}

// MARK: - OGFGestureNodeCoordinatorCreate

@_cdecl("OGFGestureNodeCoordinatorCreate")
package func _OGFGestureNodeCoordinatorCreate(
    _ willUpdateHandler: (() -> Void)?,
    _ didUpdateHandler: (() -> Void)?
) -> AnyObject {
    // TODO: Create GestureNodeCoordinatorShim
    fatalError("TODO")
}

// MARK: - OGFGestureComponentControllerSetNode

@_cdecl("OGFGestureComponentControllerSetNode")
package func _OGFGestureComponentControllerSetNode(
    _ controller: AnyObject,
    _ node: AnyObject?
) {
    guard let ctrl = controller as? AnyGestureComponentController else { return }
    // TODO: Extract AnyGestureNode from the ObjC shim node and assign
    _ = ctrl
    _ = node
}

// MARK: - OGFGestureNodeDefaultValue

@_cdecl("OGFGestureNodeDefaultValue")
package func _OGFGestureNodeDefaultValue() -> AnyObject? {
    () as AnyObject
}

#endif

// MARK: - OGFGestureFailureTypeIsTerminated

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
