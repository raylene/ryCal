//
//  Month.h
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"

@interface Month : NSObject

@property (nonatomic, strong) NSDateComponents *components;

- (id)initWithNSDate:(NSDate *)date;
- (int)numDays;
- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

- (NSDate *)getStartDateForPrevMonth;
- (NSDate *)getStartDateForNextMonth;

// TODO: fix this, weird pattern
- (NSInteger)getReferenceDayIdx;

- (NSDate *)getStartDateForDay:(int)day;
- (NSDate *)getEndDateForDay:(int)day;

- (NSString *)getTitleString;

- (BOOL)isCurrentMonth;

- (void)loadAllRecords:(void (^)(NSError *error))monthCompletion;
- (Record *)getPrimaryRecordForDay:(int)day;

@end
