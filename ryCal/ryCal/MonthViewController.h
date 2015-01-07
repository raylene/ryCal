//
//  MonthViewController.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthViewController : UIViewController

@property (nonatomic, strong) UIViewController *presentingVC;

- (id)initWithDate:(NSDate *)date;

@end
