//
//  FLOExtensionsNSView.h
//  FlowarePopover
//
//  Created by lamnguyen on 9/20/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface NSView (FLOExtensionsNSView)

- (CALayer *)layerFromContents;

#pragma mark -
#pragma mark - Transform animator
#pragma mark -
- (void)transformAlongAxis:(NSInteger)axis scaleFactor:(CGFloat)scaleFactor startPoint:(CGFloat)startPoint endPoint:(CGFloat)endPoint onDuration:(CGFloat)duration;
- (void)transitionAlongAxis:(NSInteger)axis startPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint onDuration:(CGFloat)duration;

#pragma mark -
#pragma mark - Utilities
#pragma mark -
- (void)animatedDisplayWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)(void))handler;
- (void)animatedCloseWillBeginAtPoint:(NSPoint)beginPoint endedAtPoint:(NSPoint)endedPoint handler:(void(^)(void))handler;

- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame;
- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame source:(id)source;
- (void)showingAnimated:(BOOL)showing fromFrame:(NSRect)fromFrame toFrame:(NSRect)toFrame duration:(NSTimeInterval)duration source:(id)source;

- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition;
- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition completionHandler:(void(^)(void))complete;
- (void)showingAnimated:(BOOL)showing fromPosition:(NSPoint)fromPosition toPosition:(NSPoint)toPosition duration:(NSTimeInterval)duration completionHandler:(void(^)(void))complete;

@end
