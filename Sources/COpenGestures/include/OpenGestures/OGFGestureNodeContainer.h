//
//  OGFGestureNodeContainer.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef OGFGestureNodeContainer_h
#define OGFGestureNodeContainer_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeContainer <NSObject>

@required

- (NSInteger)indexOfGestureNode:(id)gestureNode;
- (BOOL)isDeeperThanContainer:(id)isDeeperThanContainer referenceNode:(id)referenceNode;
- (BOOL)isDescendantOfContainer:(id)container referenceNode:(id)referenceNode;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeContainer_h */
