//
//  OGFGestureFunctions.h
//  OpenGestures

#ifndef OGFGestureFunctions_h
#define OGFGestureFunctions_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;
@protocol OGFGestureNodeCoordinator;

OGF_EXTERN_C_BEGIN

/// Create a default gesture node with the given key.
OGF_EXPORT id<OGFGestureNode> _Nonnull OGFGestureNodeCreateDefault(NSInteger key);

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

/// Check if a gesture failure type is terminated.
OGF_EXPORT bool OGFGestureFailureTypeIsTerminated(struct OGFGesturePhase phase);

/// Get the default value for a gesture node.
OGF_EXPORT id _Nullable OGFGestureNodeDefaultValue(void);

OGF_EXTERN_C_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureFunctions_h */
