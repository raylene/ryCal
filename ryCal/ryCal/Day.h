//
//  Day.h
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Month.h"
#import "Record.h"

@interface Day : NSObject

// TODO: cleanup weird init / interdependencies between Month/Day
- (id)initWithMonthAndDay:(Month *)month dayIndex:(int)dayIndex;
- (id)initWithMonthAndDate:(Month *)month date:(NSDate *)date;

- (NSString *)getMonthString;
- (NSString *)getDayString;

- (NSString *)getTitleString;

- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

- (Record *)getPrimaryRecord;

@end
