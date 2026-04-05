//
//  OGFGestureNodeCoordinator.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

#ifndef OGFGestureNodeCoordinator_h
#define OGFGestureNodeCoordinator_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeCoordinator <NSObject>

@required

@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, copy) id /* block */ willUpdateHandler;
@property (nonatomic, copy) id /* block */ willProcessUpdateQueueHandler;
@property (nonatomic, copy) id /* block */ didUpdateHandler;

- (void)enqueueUpdatesForNodes:(id)nodes inBlock:(id /* block */)inBlock reason:(id)reason;
- (BOOL)hasUnresolvedFailureDependenciesForNode:(id)node;
- (void)setWillProcessUpdateQueueHandler:(id /* block */)willProcessUpdateQueueHandler;
- (void)updateWithNodes:(id)nodes reason:(id)reason updateHandler:(id /* block */)updateHandler;
- (id)failureDependentsForNode:(id)node;
- (void)processUpdatesWithReason:(id)reason;
- (void)setDidUpdateHandler:(id /* block */)didUpdateHandler;
- (void)setWillUpdateHandler:(id /* block */)willUpdateHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeCoordinator_h */
