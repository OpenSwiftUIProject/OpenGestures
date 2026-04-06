//
//  OGFGestureNodeDelegate.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

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

@required

- (void)gestureNode:(id<OGFGestureNode>)gestureNode didUpdatePhase:(OGFGesturePhase)phase;
- (nullable id)gestureNode:(id<OGFGestureNode>)gestureNode roleForRelationType:(OGFGestureRelationType)relationType relatedNode:(id<OGFGestureNode>)relatedNode;
- (BOOL)gestureNodeShouldActivate:(id<OGFGestureNode>)node;
- (void)gestureNodeWillUnblock:(id<OGFGestureNode>)node;

@optional

- (void)gestureNode:(id<OGFGestureNode>)gestureNode didEnqueuePhase:(OGFGesturePhase)phase;
- (void)gestureNodeWillAbort:(id<OGFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeDelegate_h */
