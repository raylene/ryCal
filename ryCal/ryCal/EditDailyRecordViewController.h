//
//  EditDailyRecordViewController.h
//  ryCal
//
//  Created by Raylene Yung on 1/5/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface EditDailyRecordViewController : UIViewController

@property (nonatomic, strong) Day *dayData;

- (id)initWithDate:(NSDate *)date;

@end