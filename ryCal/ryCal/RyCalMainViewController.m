//
//  RyCalMainViewController.m
//  ryCal
//
//  Created by Raylene Yung on 1/5/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "RyCalMainViewController.h"
#import "HomeViewController.h"
#import "MonthHomeViewController.h"
#import "MenuViewController.h"
#import "SharedConstants.h"

@interface RyCalMainViewController ()

@property (nonatomic, strong) UIViewController *contentVC;
@property (nonatomic, strong) UIViewController<SlidingMenuProtocol> *menuVC;

@end

@implementation RyCalMainViewController

- (id)init {
    self.contentVC = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] initWithDate:[NSDate date]]];
    
//    self.contentVC = [[UINavigationController alloc] initWithRootViewController:[[MonthHomeViewController alloc] initWithDate:[NSDate date]]];
    
    self.menuVC = [[MenuViewController alloc] init];
    self = [super initWithViewControllers:self.menuVC contentVC:self.contentVC];
    
    [[UINavigationBar appearance] setBarTintColor:[SharedConstants getNavigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    return self;
}

@end
