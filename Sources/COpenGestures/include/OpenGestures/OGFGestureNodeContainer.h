//
//  OGFGestureNodeContainer.h
//  OpenGestures

#ifndef OGFGestureNodeContainer_h
#define OGFGestureNodeContainer_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeContainer <NSObject>

- (NSInteger)indexOfGestureNode:(id<OGFGestureNode>)node;
- (BOOL)isDescendantOfContainer:(id<OGFGestureNodeContainer>)container
                  referenceNode:(id<OGFGestureNode>)node;
- (BOOL)isDeeperThanContainer:(id<OGFGestureNodeContainer>)container
                referenceNode:(id<OGFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeContainer_h */
