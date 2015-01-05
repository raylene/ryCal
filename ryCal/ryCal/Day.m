//
//  Day.m
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "Day.h"
#import "Month.h"
#import "Record.h"

@interface Day ()

@property (nonatomic, strong) Month *monthData;
@property (nonatomic, assign) int dayInt;

@end

@implementation Day

#pragma mark Custom Init methods

- (id)initWithMonthAndDay:(Month *)month dayIndex:(int)dayIndex {
    self = [super init];
    if (self) {
        self.monthData = month;
        self.dayInt = dayIndex + 1;
    }
    return self;
}

- (NSString *)getMonthString {
    return [NSString stringWithFormat:@"%ld", self.monthData.components.month];
}

- (NSString *)getDayString {
    return [NSString stringWithFormat:@"%d", self.dayInt];
}

// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
- (NSString *)getTitleString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM. d"];
    return [dateFormatter stringFromDate:[self getStartDate]];
}

- (NSDate *)getStartDate {
   return [self.monthData getStartDateForDay:self.dayInt];
}

- (NSDate *)getEndDate {
    return [self.monthData getEndDateForDay:self.dayInt];
}

- (Record *)getPrimaryRecord {
    return [self.monthData getPrimaryRecordForDay:self.dayInt];
}

@end
