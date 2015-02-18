//
//  Month.h
//  ryCal
//
//  Encapsulates data and rendering convenience methods for a month
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"

@interface Month : NSObject

@property (nonatomic, strong) NSDateComponents *components;

- (id)initWithNSDate:(NSDate *)date;

- (NSInteger)numDays;
// Number of days before the 1st of this month until you hit a Sunday
- (NSInteger)numBufferDays;

- (BOOL)isCurrentMonth;
// TODO: fix this, weird pattern
- (NSInteger)getReferenceDayIdx;

- (NSString *)getTitleString;

- (NSDate *)getStartDate;
- (NSDate *)getEndDate;

- (NSDate *)getStartDateForPrevMonth;
- (NSDate *)getStartDateForNextMonth;

- (NSDate *)getStartDateForDay:(NSInteger)day;
- (NSDate *)getEndDateForDay:(NSInteger)day;

- (void)loadAllRecords:(void (^)(NSError *error))monthCompletion;
- (Record *)getPrimaryRecordForDay:(NSInteger)day;

@end
