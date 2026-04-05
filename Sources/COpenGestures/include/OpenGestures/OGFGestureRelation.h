//
//  OGFGestureRelation.h
//  OpenGestures

#ifndef OGFGestureRelation_h
#define OGFGestureRelation_h

#include <OpenGestures/OGFBase.h>

OGF_EXTERN_C_BEGIN

/// Gesture relation type.
/// rawValue 0: canExclude, 1: canBeExcluded, 2: failureRequirement, 4: requires, 5: requiredBy
typedef struct OGFGestureRelationType {
    NSInteger rawValue;
} OGFGestureRelationType;

/// Gesture relation role.
/// rawValue 0: regular, 1: blocking
typedef struct OGFGestureRelationRole {
    NSInteger rawValue;
} OGFGestureRelationRole;

OGF_EXTERN_C_END

#endif /* OGFGestureRelation_h */
