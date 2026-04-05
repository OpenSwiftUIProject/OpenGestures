//
//  OGFGestureRelation.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef OGFGestureRelation_h
#define OGFGestureRelation_h

#include <OpenGestures/OGFBase.h>

typedef OGF_ENUM(NSInteger, OGFGestureRelationType) {
    OGFGestureRelationTypeCanExclude = 0,
    OGFGestureRelationTypeCanBeExcluded = 1,
    OGFGestureRelationTypeCanExcludeActive = 2,
    OGFGestureRelationTypeCanBeExcludedWhenActive = 3,
    OGFGestureRelationTypeRequiresFailure = 4,
    OGFGestureRelationTypeRequiredToFail = 5,
};

typedef OGF_ENUM(NSInteger, OGFGestureRelationRole) {
    OGFGestureRelationRoleRegular = 0,
    OGFGestureRelationRoleBlocking = 1,
};

#endif /* OGFGestureRelation_h */
