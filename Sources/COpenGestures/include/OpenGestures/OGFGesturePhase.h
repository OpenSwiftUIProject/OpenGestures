//
//  OGFGesturePhase.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef OGFGesturePhase_h
#define OGFGesturePhase_h

#include <OpenGestures/OGFBase.h>

typedef OGF_ENUM(NSInteger, OGFGesturePhase) {
    OGFGesturePhaseIdle = 0,
    OGFGesturePhasePossible = 1,
    OGFGesturePhaseBegan = 2,
    OGFGesturePhaseChanged = 3,
    OGFGesturePhaseEnded = 4,
    OGFGesturePhaseCancelled = 5,
    OGFGesturePhaseFailed = 6,
};

#endif /* OGFGesturePhase_h */
