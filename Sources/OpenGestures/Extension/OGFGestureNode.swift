//
//  OGFGestureNode.swift
//  OpenGestures
//
//  Created by Kyle on 4/19/26.
//

#if canImport(ObjectiveC)

import Foundation

@objc
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

#endif
