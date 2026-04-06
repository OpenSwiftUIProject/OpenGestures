//
//  OGFGestureFunctions.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

#ifndef OGFGestureFunctions_h
#define OGFGestureFunctions_h

#include <OpenGestures/OGFBase.h>
#include <OpenGestures/OGFGestureFailureType.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;
@protocol OGFGestureNodeCoordinator;
#endif

OGF_EXTERN_C_BEGIN

OGF_ASSUME_NONNULL_BEGIN

#if OGF_OBJC_FOUNDATION

/// Create a default gesture node with the given key.
OGF_EXPORT id<OGFGestureNode> _Nonnull OGFGestureNodeCreateDefault(NSInteger key);

/// Get the default value for a gesture node.
OGF_EXPORT id _Nonnull OGFGestureNodeDefaultValue(void);

/// Create a gesture node coordinator with lifecycle callbacks.
OGF_EXPORT id<OGFGestureNodeCoordinator> _Nonnull OGFGestureNodeCoordinatorCreate(
    void (^ _Nullable willUpdateHandler)(void),
    void (^ _Nullable didUpdateHandler)(void)
);

/// Bind a gesture component controller to a gesture node.
OGF_EXPORT void OGFGestureComponentControllerSetNode(
    id _Nonnull controller,
    id<OGFGestureNode> _Nullable node
);

#endif /* OGF_OBJC_FOUNDATION */

/// Check if a gesture failure type is terminated.
OGF_EXPORT bool OGFGestureFailureTypeIsTerminated(OGFGestureFailureType type) OGF_SWIFT_NAME(getter:OGFGestureFailureType.isTerminated(self:));

OGF_ASSUME_NONNULL_END

OGF_EXTERN_C_END

#endif /* OGFGestureFunctions_h */
