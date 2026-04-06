//
//  OGFGestureFailureType.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef OGFGestureFailureType_h
#define OGFGestureFailureType_h

#include <OpenGestures/OGFBase.h>

/// Corresponds to Gestures.GestureFailureReason cases.
/// Cases 2 (custom), 3 (disabled), 5 (activationDenied), 6 (aborted) are terminated.
typedef OGF_ENUM(NSInteger, OGFGestureFailureType) {
    OGFGestureFailureTypeExcluded = 0,
    OGFGestureFailureTypeFailureDependency = 1,
    OGFGestureFailureTypeCustomError = 2,
    OGFGestureFailureTypeDisabled = 3,
    OGFGestureFailureTypeRemovedFromContainer = 4,
    OGFGestureFailureTypeActivationDenied = 5,
    OGFGestureFailureTypeAborted = 6,
    OGFGestureFailureTypeCoordinatorChanged = 7,
};

#endif /* OGFGestureFailureType_h */
