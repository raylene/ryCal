//
//  MonthViewController.h
//  ryCal
//
//  A calendar grid view for a single month
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthViewController : UIViewController

@property (nonatomic, assign) CGFloat monthFrameWidth;

- (id)initWithDate:(NSDate *)date;

- (CGFloat)getCellWidth;
- (CGFloat)getEstimatedHeight;

@end
