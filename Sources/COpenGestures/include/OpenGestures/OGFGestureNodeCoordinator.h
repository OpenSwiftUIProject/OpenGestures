//
//  OGFGestureNodeCoordinator.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP (handler type)

#ifndef OGFGestureNodeCoordinator_h
#define OGFGestureNodeCoordinator_h

#include <OpenGestures/OGFBase.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNode;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNodeCoordinator <NSObject>

@required

@property (nonatomic, readonly) NSArray<id<OGFGestureNode>> *nodes;
@property (nonatomic, copy, nullable) void (^willUpdateHandler)(void);
@property (nonatomic, copy, nullable) void (^willProcessUpdateQueueHandler)(void);
@property (nonatomic, copy, nullable) void (^didUpdateHandler)(void);

- (void)enqueueUpdatesForNodes:(NSArray<id<OGFGestureNode>> *)nodes
                       inBlock:(void (^)(NSArray<id<OGFGestureNode>> *))block
                        reason:(NSString *)reason;
- (BOOL)hasUnresolvedFailureDependenciesForNode:(id<OGFGestureNode>)node;
- (void)setWillProcessUpdateQueueHandler:(nullable void (^)(void))handler;
- (void)updateWithNodes:(NSArray<id<OGFGestureNode>> *)nodes
                 reason:(NSString *)reason
          updateHandler:(void (^)(NSArray<id<OGFGestureNode>> *))handler;
- (NSArray<id<OGFGestureNode>> *)failureDependentsForNode:(id<OGFGestureNode>)node;
- (void)processUpdatesWithReason:(NSString *)reason;
- (void)setDidUpdateHandler:(nullable void (^)(void))handler;
- (void)setWillUpdateHandler:(nullable void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNodeCoordinator_h */
