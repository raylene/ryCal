//
//  DayViewController.h
//  ryCal
//
//  Permalink / details view for a single day and its records
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface DayViewController : UIViewController

@property (nonatomic, strong) Day *dayData;

- (id)initWithDay:(Day *)dayData;

@end
