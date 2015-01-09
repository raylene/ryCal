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
@property (nonatomic, assign) NSInteger dayInt;

@end

@implementation Day

#pragma mark Custom Init methods

- (id)initWithMonthAndDay:(Month *)month dayIndex:(NSInteger)dayIndex {
    self = [super init];
    if (self) {
        self.monthData = month;
        self.dayInt = dayIndex + 1;
    }
    return self;
}

- (id)initWithMonthAndDate:(Month *)month date:(NSDate *)date {
    self = [super init];
    if (self) {
        // TODO: fix up the Month vs. Day init mess :/
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:date];

        self.monthData = month;
        self.dayInt = (int)components.day;
    }
    return self;
}

#pragma mark Basic accessors

- (NSInteger) getDayInt {
    return self.dayInt;
}

- (BOOL)isToday {
    return ([self.getStartDate compare:[NSDate date]] != NSOrderedDescending) &&
    ([self.getEndDate compare:[NSDate date]] == NSOrderedDescending);
}

- (NSString *)getDayString {
    return [NSString stringWithFormat:@"%ld", (long)self.dayInt];
}

// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
- (NSString *)getTitleString {
    return [self getTitleString:NO];
}

- (NSString *)getHeaderString {
    return [self getTitleString:YES];
}

- (NSString *)getTitleString:(BOOL)allCaps {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM. d"];
    NSString *result = [dateFormatter stringFromDate:[self getStartDate]];
    if (allCaps) {
        return [result uppercaseString];
    }
    return result;
}

#pragma mark Date manipulation

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
