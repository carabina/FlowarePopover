//
//  FLOPopover.m
//  FlowarePopover
//
//  Created by Hung Truong on 8/20/18.
//  Copyright © 2018 Floware Inc. All rights reserved.
//

#import "FLOPopover.h"
#import "FLOViewPopup.h"
#import "FLOWindowPopup.h"

@interface FLOPopover ()

@property (nonatomic, strong) FLOWindowPopup<FLOPopoverService> *windowPopup;
@property (nonatomic, strong) FLOViewPopup<FLOPopoverService> *viewPopup;

@property (nonatomic, strong, readwrite) NSView *contentView;
@property (nonatomic, strong, readwrite) NSViewController *contentViewController;
@property (nonatomic, assign, readwrite) FLOPopoverType popupType;

@end

@implementation FLOPopover

@synthesize popupType = _popupType;

#pragma mark -
#pragma mark - Inits
#pragma mark -
- (instancetype)initWithContentView:(NSView *)contentView {
    return [self initWithContentView:contentView popoverType:FLOViewPopover];
}

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController {
    return [self initWithContentViewController:contentViewController popoverType:FLOViewPopover];
}

- (instancetype)initWithContentView:(NSView *)contentView popoverType:(FLOPopoverType)popoverType {
    if (self = [super init]) {
        self.contentView = contentView;
        self.popupType = popoverType;
        self.alwaysOnTop = NO;
        self.shouldShowArrow = NO;
        self.animated = NO;
        self.closesWhenPopoverResignsKey = NO;
        self.closesWhenApplicationBecomesInactive = NO;
        self.popoverMovable = NO;
        self.animatedWithContext = NO;
    }
    
    return self;
}

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController popoverType:(FLOPopoverType)popoverType {
    if (self = [super init]) {
        self.contentViewController = contentViewController;
        self.popupType = popoverType;
        self.alwaysOnTop = NO;
        self.shouldShowArrow = NO;
        self.animated = NO;
        self.closesWhenPopoverResignsKey = NO;
        self.closesWhenApplicationBecomesInactive = NO;
        self.popoverMovable = NO;
        self.popoverShouldDetach = NO;
        self.animatedWithContext = NO;
    }
    
    return self;
}

- (void)setupPopupView {
    if (!self.viewPopup) {
        self.viewPopup = [[FLOViewPopup alloc] initWithContentView:self.contentViewController.view];
        [self bindEventsForPopover:self.viewPopup];
    }
}

- (void)setupPopupWindow {
    if (!self.windowPopup) {
        self.windowPopup = [[FLOWindowPopup alloc] initWithContentViewController:self.contentViewController];
        [self bindEventsForPopover:self.windowPopup];
    }
}

#pragma mark -
#pragma mark - Getter/Setter
#pragma mark -
- (BOOL)isShown {
    if (self.popupType == FLOWindowPopover) {
        return [self.windowPopup isShown];
    }
    
    return [self.viewPopup isShown];
}

- (NSView *)contentView {
    return _contentView;
}

- (NSViewController *)contentViewController {
    return _contentViewController;
}

- (FLOPopoverType)popupType {
    return _popupType;
}

- (void)setPopupType:(FLOPopoverType)popupType {
    _popupType = popupType;
    
    switch (popupType) {
        case FLOWindowPopover:
            [self setupPopupWindow];
            break;
        case FLOViewPopover:
            [self setupPopupView];
            break;
        default:
            // default is FLOViewPopover
            break;
    }
}

- (void)setAlwaysOnTop:(BOOL)alwaysOnTop {
    _alwaysOnTop = alwaysOnTop;
    
    self.viewPopup.alwaysOnTop = alwaysOnTop;
    self.windowPopup.alwaysOnTop = alwaysOnTop;
}

- (void)setShouldShowArrow:(BOOL)needed {
    _shouldShowArrow = needed;
    
    self.viewPopup.shouldShowArrow = needed;
    self.windowPopup.shouldShowArrow = needed;
}

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    
    self.viewPopup.animated = animated;
    self.windowPopup.animated = animated;
}

- (void)setClosesWhenPopoverResignsKey:(BOOL)closeWhenResign {
    _closesWhenPopoverResignsKey = closeWhenResign;
    
    self.viewPopup.closesWhenPopoverResignsKey = closeWhenResign;
    self.windowPopup.closesWhenPopoverResignsKey = closeWhenResign;
}

- (void)setClosesWhenApplicationBecomesInactive:(BOOL)closeWhenInactive {
    _closesWhenApplicationBecomesInactive = closeWhenInactive;
    
    self.viewPopup.closesWhenApplicationBecomesInactive = closeWhenInactive;
    self.windowPopup.closesWhenApplicationBecomesInactive = closeWhenInactive;
}

- (void)setPopoverMovable:(BOOL)popoverMovable {
    _popoverMovable = popoverMovable;
    
    self.viewPopup.popoverMovable = popoverMovable;
    self.windowPopup.popoverMovable = popoverMovable;
}

- (void)setPopoverShouldDetach:(BOOL)popoverShouldDetach {
    if (self.popupType == FLOWindowPopover) {
        _popoverShouldDetach = popoverShouldDetach;
        
        self.windowPopup.popoverMovable = popoverShouldDetach;
        self.windowPopup.popoverShouldDetach = popoverShouldDetach;
    }
}

- (void)setAnimatedWithContext:(BOOL)animatedWithContext {
    _animatedWithContext = animatedWithContext;
    
    self.viewPopup.animatedWithContext = animatedWithContext;
    self.windowPopup.animatedWithContext = animatedWithContext;
}

#pragma mark -
#pragma mark - Binding events
#pragma mark -
- (void)bindEventsForPopover:(NSResponder<FLOPopoverService> *)popover {
    __weak typeof(self) weakSelf = self;
    
    popover.popoverDidShow = ^(NSResponder *popover) {
        if ([weakSelf.delegate respondsToSelector:@selector(popoverDidShow:)]) {
            [weakSelf.delegate popoverDidShow:popover];
        }
    };
    
    popover.popoverDidClose = ^(NSResponder *popover) {
        if([weakSelf.delegate respondsToSelector:@selector(popoverDidClose:)]) {
            [weakSelf.delegate popoverDidClose:popover];
        }
    };
}

#pragma mark -
#pragma mark - Display
#pragma mark -
/**
 * Set level for popover. Only used for FLOWindowPopover type.
 *
 * @param level the level of window popover.
 */
- (void)setPopoverLevel:(NSWindowLevel)level {
    if (self.popupType == FLOWindowPopover) {
        [self.windowPopup setPopoverLevel:level];
    }
}

- (void)setAnimationBehaviour:(FLOPopoverAnimationBehaviour)animationBehaviour type:(FLOPopoverAnimationTransition)animationType {
    [self.viewPopup setAnimationBehaviour:animationBehaviour type:animationType];
    [self.windowPopup setAnimationBehaviour:animationBehaviour type:animationType];
}

- (void)rearrangePopoverWithNewContentViewFrame:(NSRect)newFrame positioningRect:(NSRect)rect {
    if (self.popupType == FLOWindowPopover) {
        [self.windowPopup rearrangePopoverWithNewContentViewFrame:newFrame positioningRect:rect];
    } else {
        [self.viewPopup rearrangePopoverWithNewContentViewFrame:newFrame positioningRect:rect];
    }
}

/**
 * Display the popover relative to the rect of positioning view
 *
 * @param rect is the rect that popover will be displayed relatively to.
 * @param positioningView is the view that popover will be displayed relatively to.
 * @param edgeType 'position' that the popover should be displayed.
 */
- (void)showRelativeToRect:(NSRect)rect ofView:(NSView *)positioningView edgeType:(FLOPopoverEdgeType)edgeType {
    if (self.popupType == FLOWindowPopover) {
        [self.windowPopup showRelativeToRect:rect ofView:positioningView edgeType:edgeType];
    } else {
        [self.viewPopup showRelativeToRect:rect ofView:positioningView edgeType:edgeType];
    }
}

/**
 * Dipslay the popover at the given rect with selected view.
 *
 * @param positioningView the selected view that popover should be displayed at.
 * @param rect the given rect that popover should be displayed at.
 */
- (void)showRelativeToView:(NSView *)positioningView withRect:(NSRect)rect {
    if (self.popupType == FLOWindowPopover) {
        [self.windowPopup showRelativeToView:positioningView withRect:rect edgeType:FLOPopoverEdgeTypeBelowLeftEdge];
    } else {
        [self.viewPopup showRelativeToView:positioningView withRect:rect edgeType:FLOPopoverEdgeTypeBelowLeftEdge];
    }
}

#pragma mark -
#pragma mark - Utilities
#pragma mark -
- (IBAction)closePopover:(FLOPopover *)sender {
    if (self.popupType == FLOWindowPopover) {
        [self.windowPopup closePopover:sender];
    } else {
        [self.viewPopup closePopover:sender];
    }
}

- (void)closePopover:(FLOPopover *)sender completion:(void(^)(void))complete {
    // code ...
}

@end
