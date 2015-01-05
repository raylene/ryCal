//
//  MenuViewController.h
//  ryCal
//
//  Created by Raylene Yung on 12/30/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingMenuMainViewController.h"

@interface MenuViewController : UIViewController<SlidingMenuProtocol>

- (void)setMainVC:(SlidingMenuMainViewController *)mainVC;

@end
