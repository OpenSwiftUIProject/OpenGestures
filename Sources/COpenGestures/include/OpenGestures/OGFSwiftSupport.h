//
//  OGFSwiftSupport.h
//  OpenGestures

#pragma once

#if __has_attribute(swift_name)
#define OGF_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
#define OGF_SWIFT_NAME
#endif

#if __has_attribute(swift_wrapper)
#define OGF_SWIFT_STRUCT __attribute__((swift_wrapper(struct)))
#else
#define OGF_SWIFT_STRUCT
#endif

#if __has_attribute(swift_private)
#define OGF_REFINED_FOR_SWIFT __attribute__((swift_private))
#else
#define OGF_REFINED_FOR_SWIFT
#endif

// MARK: - Call Convension

#define OGF_SWIFT_CC(CC) OGF_SWIFT_CC_##CC
// OGF_SWIFT_CC(c) is the C calling convention.
#define OGF_SWIFT_CC_c

// OGF_SWIFT_CC(swift) is the Swift calling convention.
#if __has_attribute(swiftcall)
#define OGF_SWIFT_CC_swift __attribute__((swiftcall))
#define OGF_SWIFT_CONTEXT __attribute__((swift_context))
#define OGF_SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#define OGF_SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#else
#define OGF_SWIFT_CC_swift
#define OGF_SWIFT_CONTEXT
#define OGF_SWIFT_ERROR_RESULT
#define OGF_SWIFT_INDIRECT_RESULT
#endif
