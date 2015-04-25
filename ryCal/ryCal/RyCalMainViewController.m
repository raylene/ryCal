//
//  RyCalMainViewController.m
//  ryCal
//
//  Created by Raylene Yung on 1/5/15.
//  Copyright (c) 2015 rayleney. All rights reserved.

#import "RyCalMainViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "RecordDateHelper.h"

#define USE_GMT 1

@implementation RyCalMainViewController

- (id)init {
#if USE_GMT
    NSDate *today = [RecordDateHelper getGMTStartOfToday];
#else
    NSDate *today = [RecordDateHelper getLocalStartOfToday];
#endif
    HomeViewController *hvc = [[HomeViewController alloc] initWithDate:today];
    self.contentVC = [[UINavigationController alloc] initWithRootViewController:hvc];
    
    self.menuVC = [[MenuViewController alloc] init];
    self = [super initWithViewControllers:self.menuVC contentVC:self.contentVC];

    // TODO: look into this resizing hack
    hvc.view.frame = self.contentVC.view.frame;
    self.menuVC.view.frame = self.contentVC.view.frame;
    
    return self;
}

@end
