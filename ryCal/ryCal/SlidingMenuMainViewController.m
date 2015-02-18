//
//  SlidingMenuMainViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/30/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "SlidingMenuMainViewController.h"

int const kMenuPeekingAmount = 100;
float const kMenuAnimationDuration = 0.3;
float const kContentSwappingDuration = 0.2;

@interface SlidingMenuMainViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, assign) CGPoint initialOffset;
@property (nonatomic, assign) BOOL menuIsOpen;

@end

@implementation SlidingMenuMainViewController

// TODO: potentially fix this strange notification model to trigger the menu
NSString * const SlidingMenuToggleStateNotification = @"SlidingMenuToggleStateNotification";

- (id)initWithViewControllers:(UIViewController<SlidingMenuProtocol> *)menuVC contentVC:(UIViewController *)contentVC {
    self = [super init];
    if (self) {
        [self setMenuVC:menuVC];
        [self setContentVC:contentVC];
        self.menuIsOpen = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenuState) name:SlidingMenuToggleStateNotification object:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

# pragma mark - Private helper functions

- (IBAction)onMenu:(id)sender {
    // Only open the menu it if it's not yet visible
    if (self.menuIsOpen) {
        [self animateMenuClosed];
    } else {
        [self animateMenuOpen];
    }
}

#pragma mark - Custom setters

@synthesize menuVC = _menuVC;
- (void)setMenuVC:(UIViewController<SlidingMenuProtocol> *)menuVC {
    _menuVC = menuVC;
    [_menuVC setMainVC:self];
    self.menuView = menuVC.view;
    [self.view addSubview:self.menuView];
}

@synthesize contentVC = _contentVC;
- (void)setContentVC:(UIViewController *)contentVC {
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    _contentVC = contentVC;
    self.contentView = contentVC.view;
    self.contentView.frame = self.view.frame;
    [self.contentView addGestureRecognizer:pgr];
    [self.view addSubview:self.contentView];
}

- (void)displayContentVC:(UIViewController *)contentVC {
    CGRect frame = self.view.frame;
    if (self.contentView != nil) {
        frame = self.contentView.frame;
    }
    UIView *newContentView = contentVC.view;
    [newContentView setFrame:frame];
    [newContentView setAlpha:0];
    [self.view addSubview:newContentView];
    [UIView animateWithDuration:kContentSwappingDuration animations:^{
        [newContentView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [newContentView removeFromSuperview];
        [self setContentVC:contentVC];
        [self animateMenuClosed];
    }];
}

# pragma mark - Gesture recognizers
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialOffset = [sender locationInView:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGRect newFrame = self.view.frame;
        float newX = location.x - self.initialOffset.x;
        if (newX < 0) {
            newX = 0;
        }
        newFrame.origin.x = newX;
        sender.view.frame = newFrame;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self animateMenuOpen];
        } else {
            [self animateMenuClosed];
        }
    }
}

- (void)toggleMenuState {
    if (self.menuIsOpen) {
        [self animateMenuClosed];
    } else {
        [self animateMenuOpen];
    }
}

- (void)animateMenuOpen {
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        CGRect newFrame = self.view.frame;
        float maxX = (newFrame.origin.x + newFrame.size.width) - kMenuPeekingAmount;
        newFrame.origin.x = maxX;
        self.contentView.frame = newFrame;
    } completion:^(BOOL finished) {
        self.menuIsOpen = YES;
    }];
}

- (void)animateMenuClosed {
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        self.contentView.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.menuIsOpen = NO;
    }];
}

@end