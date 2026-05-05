//
//  OGFGestureNode.swift
//  OpenGestures
//
//  Created by Kyle on 4/19/26.
//

import Foundation

#if canImport(ObjectiveC)
@objc
#endif
class AnyGestureNodeShim: NSObject, @unchecked Sendable {

    package var node: AnyGestureNode {
        _openGesturesBaseClassAbstractMethod()
    }

//    override var container: (any GestureNodeContainer)? {
//        didSet {
//            // TODO
//        }
//    }
//
//    override func abort() throws {
//        _openGesturesBaseClassAbstractMethod()
//    }
}
