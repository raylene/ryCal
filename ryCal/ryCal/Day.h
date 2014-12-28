//
//  Day.h
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Month.h"

@interface Day : NSObject

- (id)initWithMonthAndDay:(Month *)month day:(int)dayIndex;

- (NSString *)getMonthString;
- (NSString *)getDayString;
- (NSString *)getFullDateString;

- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

@end
