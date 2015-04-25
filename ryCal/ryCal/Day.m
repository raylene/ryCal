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
#import "RecordQueryTracker.h"
#import "RecordDateHelper.h"

@interface Day ()

#define USE_GMT 1

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
#if USE_GMT
        NSCalendar *calendar = [RecordDateHelper sharedGMTCalendar];
#else
        NSCalendar *calendar = [RecordDateHelper sharedLocalCalendar];
#endif
        
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
#if USE_GMT
    // GMT
    NSDate *today = [RecordDateHelper getGMTStartOfToday];
#else
    // LOCAL
    NSDate *today = [RecordDateHelper getLocalStartOfToday];
#endif
    return ([self.getStartDate compare:today] != NSOrderedDescending) &&
    ([self.getEndDate compare:today] == NSOrderedDescending);
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
#if USE_GMT
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedGMTDateFormatter];
#else
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedLocalDateFormatter];
#endif

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

- (Record *)getSecondaryRecord {
    return [self.monthData getSecondaryRecordForDay:self.dayInt];
}

#pragma mark Query tracking / caching helper

- (NSString *)getDayCacheKey {
#if USE_GMT
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedGMTDateFormatter];
#else
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedLocalDateFormatter];
#endif

    [dateFormatter setDateFormat:@"MM_yyyy_dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[self getStartDate]];
    NSString *key = [NSString stringWithFormat:@"%@_%@", kRecordQueryKey, dateStr];
    return key;
}

- (NSString *)getMonthCacheKey {
    return [self.monthData getCacheKey];
}

@end
