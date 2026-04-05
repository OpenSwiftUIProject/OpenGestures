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

- (void)gestureNode:(id)gestureNode didUpdatePhase:(OGFGesturePhase)didUpdatePhase;
- (id)gestureNode:(id)gestureNode roleForRelationType:(OGFGestureRelationType)relationType relatedNode:(id)relatedNode;
- (BOOL)gestureNodeShouldActivate:(id)gestureNodeShouldActivate;
- (void)gestureNodeWillUnblock:(id)gestureNodeWillUnblock;

@optional

- (void)gestureNode:(id)gestureNode didEnqueuePhase:(OGFGesturePhase)didEnqueuePhase;
- (void)gestureNodeWillAbort:(id)gestureNodeWillAbort;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeDelegate_h */
