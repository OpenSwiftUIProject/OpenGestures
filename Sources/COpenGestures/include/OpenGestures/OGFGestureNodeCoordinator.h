//
//  OGFGestureNodeCoordinator.h
//  OpenGestures

#ifndef OGFGestureNodeCoordinator_h
#define OGFGestureNodeCoordinator_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeCoordinator <NSObject>

@property (nonatomic, readonly) NSArray<id<OGFGestureNode>> *nodes;
@property (nonatomic, copy, nullable) void (^willUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^didUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^willProcessUpdateQueueHandler)(void);

- (void)enqueueUpdatesForNodes:(NSArray<id<OGFGestureNode>> *)nodes
                       inBlock:(void (^)(NSArray<id<OGFGestureNode>> *))block
                        reason:(NSString *)reason;
- (void)processUpdatesWithReason:(NSString *)reason;
- (void)updateWithNodes:(NSArray<id<OGFGestureNode>> *)nodes
                 reason:(NSString *)reason
          updateHandler:(void (^)(NSArray<id<OGFGestureNode>> *))handler;
- (NSArray<id<OGFGestureNode>> *)failureDependentsForNode:(id<OGFGestureNode>)node;
- (BOOL)hasUnresolvedFailureDependenciesForNode:(id<OGFGestureNode>)node;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeCoordinator_h */
