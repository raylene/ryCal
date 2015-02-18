//
//  SlidingMenuMainViewController.h
//  ryCal
//
//  Created by Raylene Yung on 12/30/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidingMenuMainViewController;

@protocol SlidingMenuProtocol <NSObject>

- (void)setMainVC:(SlidingMenuMainViewController *)mainVC;

@end

//@protocol SlidingContentProtocol <NSObject>
//
//@end

@interface SlidingMenuMainViewController : UIViewController

extern NSString * const SlidingMenuToggleStateNotification;

@property (nonatomic, strong) UIViewController *contentVC;
@property (nonatomic, strong) UIViewController<SlidingMenuProtocol> *menuVC;
//@property (nonatomic, weak) id<SlidingMenuMainViewControllerDelegate> menuDelegate;

- (id)initWithViewControllers:(UIViewController<SlidingMenuProtocol> *)menuVC contentVC:(UIViewController *)contentVC;

- (void)displayContentVC:(UIViewController *)contentVC;

@end