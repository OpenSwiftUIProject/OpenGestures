//
//  OGFGestureNodeDelegate.h
//  OpenGestures

#ifndef OGFGestureNodeDelegate_h
#define OGFGestureNodeDelegate_h

#include <OpenGestures/OGFBase.h>
#include <OpenGestures/OGFGesturePhase.h>
#include <OpenGestures/OGFGestureRelation.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeDelegate <NSObject>

@optional
- (BOOL)gestureNodeShouldActivate:(id<OGFGestureNode>)node;
- (void)gestureNodeWillUnblock:(id<OGFGestureNode>)node;
- (void)gestureNode:(id<OGFGestureNode>)node didEnqueuePhase:(struct OGFGesturePhase)phase;
- (void)gestureNode:(id<OGFGestureNode>)node didUpdatePhase:(struct OGFGesturePhase)phase;
- (struct OGFGestureRelationRole)gestureNode:(id<OGFGestureNode>)node
                       roleForRelationType:(struct OGFGestureRelationType)type
                               relatedNode:(id<OGFGestureNode>)relatedNode;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeDelegate_h */
