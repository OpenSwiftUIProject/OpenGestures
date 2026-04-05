//
//  OGFGesturePhase.h
//  OpenGestures

#ifndef OGFGesturePhase_h
#define OGFGesturePhase_h

#include <OpenGestures/OGFBase.h>

OGF_EXTERN_C_BEGIN

/// Gesture phase value bridged from Swift GesturePhase enum.
typedef struct OGFGesturePhase {
    NSInteger rawValue;
} OGFGesturePhase;

OGF_EXTERN_C_END

#endif /* OGFGesturePhase_h */
