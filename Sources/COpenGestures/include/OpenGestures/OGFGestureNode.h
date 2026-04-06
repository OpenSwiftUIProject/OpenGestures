//
//  OGFGestureNode.h
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

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

@required

@property (nonatomic, weak, nullable) id<OGFGestureNodeDelegate> delegate;
@property (nonatomic, weak, nullable) id<OGFGestureNodeContainer> container;
@property (nonatomic, nullable) id<OGFGestureNodeCoordinator> coordinator;
@property (nonatomic, readonly) OGFGesturePhase phase;
@property (nonatomic, getter=isBlocked, readonly) BOOL blocked;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *tag;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL disallowExclusionWithUnresolvedFailureRequirements;
@property (nonatomic, readonly) NSInteger platformKey;
@property (nonatomic, readonly, nullable) NSError *failureReason;

- (void)setDelegate:(nullable id<OGFGestureNodeDelegate>)delegate;
- (void)setContainer:(nullable id<OGFGestureNodeContainer>)container;
- (void)setCoordinator:(nullable id<OGFGestureNodeCoordinator>)coordinator;
- (void)setTag:(nullable NSString *)tag;
- (BOOL)abort:(NSError * _Nullable *)error;
- (void)addRelationWithType:(OGFGestureRelationType)type role:(OGFGestureRelationRole)role relatedNode:(id<OGFGestureNode>)relatedNode;
- (BOOL)ensureUpdated:(NSError * _Nullable *)error;
- (BOOL)failWithReason:(nullable NSNumber *)reason error:(NSError * _Nullable *)error;
- (void)removeRelationWithType:(OGFGestureRelationType)type role:(OGFGestureRelationRole)role relatedNode:(id<OGFGestureNode>)relatedNode;
- (void)setDisabled:(BOOL)disabled;
- (void)setDisallowExclusionWithUnresolvedFailureRequirements:(BOOL)unresolvedFailureRequirements;
- (void)setTracking:(BOOL)tracking eventsWithIdentifiers:(NSArray *)identifiers;
- (BOOL)updateWithValue:(nullable id)value isFinal:(BOOL)isFinal error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNode_h */
