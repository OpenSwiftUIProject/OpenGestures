//
//  OGFGestureNode.h
//  OpenGestures

#ifndef OGFGestureNode_h
#define OGFGestureNode_h

#include <OpenGestures/OGFBase.h>
#include <OpenGestures/OGFGesturePhase.h>
#include <OpenGestures/OGFGestureRelation.h>

#if OGF_OBJC_FOUNDATION
#import <Foundation/Foundation.h>

@protocol OGFGestureNodeDelegate;
@protocol OGFGestureNodeContainer;
@protocol OGFGestureNodeCoordinator;

NS_ASSUME_NONNULL_BEGIN

@protocol OGFGestureNode <NSObject>

@property (nonatomic, readonly) struct OGFGesturePhase phase;
@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, copy, nullable) NSString *tag;
@property (nonatomic, readonly, getter=isBlocked) BOOL blocked;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic, readonly, nullable) NSString *platformKey;
@property (nonatomic, readonly, nullable) NSNumber *failureReason;

@property (nonatomic, weak, nullable) id<OGFGestureNodeDelegate> delegate;
@property (nonatomic, weak, nullable) id<OGFGestureNodeContainer> container;
@property (nonatomic, weak, nullable) id<OGFGestureNodeCoordinator> coordinator;

- (BOOL)updateWithValue:(nullable id)value isFinal:(BOOL)isFinal error:(NSError **)error;
- (void)ensureUpdated:(NSString *)reason;
- (BOOL)abort:(NSError **)error;
- (BOOL)failWithReason:(nullable NSNumber *)reason error:(NSError **)error;

- (void)addRelationWithType:(struct OGFGestureRelationType)type
                       role:(struct OGFGestureRelationRole)role
                relatedNode:(id<OGFGestureNode>)node;
- (void)removeRelationWithType:(struct OGFGestureRelationType)type
                          role:(struct OGFGestureRelationRole)role
                   relatedNode:(id<OGFGestureNode>)node;

- (void)setTracking:(BOOL)tracking eventsWithIdentifiers:(NSArray *)identifiers;

@property (nonatomic) BOOL disallowExclusionWithUnresolvedFailureRequirements;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNode_h */
