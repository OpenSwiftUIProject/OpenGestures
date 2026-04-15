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

/// Builds a value of the enum type `T` by writing the case payload at offset 0
/// and injecting the enum tag. The payload is typed as a Swift value (typically
/// a tuple for multi-field cases, `Void` for no-payload cases) so the compiler
/// computes the correct field offsets and refcount handling.
@inline(__always)
package func makeEnum<T, Payload>(
    tag: Int,
    payload: Payload
) -> T {
    precondition(
        MemoryLayout<Payload>.size <= MemoryLayout<T>.size,
        "Case payload must fit inside \(T.self)'s enum payload"
    )
    let slot = UnsafeMutablePointer<T>.allocate(capacity: 1)
    defer { slot.deallocate() }
    let raw = UnsafeMutableRawPointer(slot)

    if MemoryLayout<Payload>.size > 0 {
        raw.bindMemory(to: Payload.self, capacity: 1).initialize(to: payload)
    }

    let payloadStride = MemoryLayout<Payload>.stride
    let totalStride = MemoryLayout<T>.stride
    if totalStride > payloadStride {
        (raw + payloadStride).initializeMemory(
            as: UInt8.self,
            repeating: 0,
            count: totalStride - payloadStride
        )
    }

    Metadata(T.self).injectEnumTag(tag: UInt32(tag), raw)
    return slot.move()
}
