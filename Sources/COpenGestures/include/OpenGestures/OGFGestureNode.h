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

@property (nonatomic, weak) id<OGFGestureNodeDelegate> delegate;
@property (nonatomic, weak) id<OGFGestureNodeContainer> container;
@property (nonatomic) id<OGFGestureNodeCoordinator> coordinator;
@property (nonatomic, readonly) OGFGesturePhase phase;
@property (nonatomic, getter=isBlocked, readonly) BOOL blocked;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, getter=isDisabled) BOOL disabled;
@property (nonatomic) BOOL disallowExclusionWithUnresolvedFailureRequirements;
@property (nonatomic, readonly) NSInteger platformKey;
@property (nonatomic, readonly) NSError *failureReason;

- (void)setDelegate:(id)delegate;
- (void)setContainer:(id)container;
- (void)setCoordinator:(id)coordinator;
- (void)setTag:(id)tag;
- (BOOL)abort:(id _Nullable *)abort;
- (void)addRelationWithType:(OGFGestureRelationType)type role:(OGFGestureRelationRole)role relatedNode:(id)relatedNode;
- (BOOL)ensureUpdated:(id _Nullable *)ensureUpdated;
- (BOOL)failWithReason:(id)reason error:(id _Nullable *)error;
- (void)removeRelationWithType:(OGFGestureRelationType)type role:(OGFGestureRelationRole)role relatedNode:(id)relatedNode;
- (void)setDisabled:(BOOL)disabled;
- (void)setDisallowExclusionWithUnresolvedFailureRequirements:(BOOL)unresolvedFailureRequirements;
- (void)setTracking:(BOOL)tracking eventsWithIdentifiers:(id)identifiers;
- (BOOL)updateWithValue:(id)value isFinal:(BOOL)isFinal error:(id _Nullable *)error;

@end

NS_ASSUME_NONNULL_END

#endif /* OGF_OBJC_FOUNDATION */

#endif /* OGFGestureNode_h */
