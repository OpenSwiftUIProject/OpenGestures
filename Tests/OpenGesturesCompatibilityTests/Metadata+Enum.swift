//
//  Metadata+Enum.swift
//  OpenGesturesCompatibilityTests

import OpenAttributeGraphShims

extension Metadata {
    @inline(__always)
    package func projectEnum(
        at ptr: UnsafeRawPointer,
        tag: Int,
        _ body: (UnsafeRawPointer) -> Void
    ) {
        projectEnumData(UnsafeMutableRawPointer(mutating: ptr))
        body(ptr)
        injectEnumTag(tag: UInt32(tag), UnsafeMutableRawPointer(mutating: ptr))
    }
}
