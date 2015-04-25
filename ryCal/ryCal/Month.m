//
//  Month.m
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "Month.h"
#import "SharedConstants.h"
#import "Record.h"
#import "RecordQueryTracker.h"
#import "RecordDateHelper.h"

#define USE_GMT 1

@interface Month ()

@property (nonatomic, strong) NSDate *referenceDate;
@property (nonatomic, assign) NSInteger referenceDayIdx;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, assign) NSRange dayRange;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSMutableDictionary *dailyRecordDictionary;

@end

@implementation Month

#pragma mark Custom Init methods

// Reference: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
- (id)initWithNSDate:(NSDate *)date {
    self = [super init];
    if (self) {
#if USE_GMT
        self.calendar = [RecordDateHelper sharedGMTCalendar];
#else
        self.calendar = [RecordDateHelper sharedLocalCalendar];
#endif
        [self parseDateComponents:date];
        self.referenceDate = date;
    }
    return self;
}

#pragma mark Basic accessors

- (NSInteger)numDays {
    return self.dayRange.length;
}

// Number of days preceding this month until a sunday (NSCalendarUnitWeekday 1)
- (NSInteger)numBufferDays {
    return (self.components.weekday - 1);
}

- (BOOL)isCurrentMonth {
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

// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
- (NSString *)getTitleString {
#if USE_GMT
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedGMTDateFormatter];
#else
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedLocalDateFormatter];
#endif
    
    [dateFormatter setDateFormat:@"MMMM"];
    // Add the yyyy if it's not this year
    if (self.components.year != [RecordDateHelper getCurrentYear]) {
        [dateFormatter setDateFormat:@"MMM yyyy"];
    }
    return [dateFormatter stringFromDate:[self getStartDate]];
}

#pragma mark Date manipulation

- (void)parseDateComponents:(NSDate *)date {
    self.components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
    self.referenceDayIdx = self.components.day - 1;
    
    // Get start date from 1st of the month
    [self.components setDay:1];
    self.dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    self.startDate = [self.calendar dateFromComponents:self.components];
    
    // Get all components for the first of the month
    self.components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate: self.startDate];
}

- (NSInteger)getReferenceDayIdx {
    return self.referenceDayIdx;
}

- (NSDate *)getStartDate {
    return self.startDate;
}

- (NSDate *)getEndDate {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:1];
    return [self.calendar dateByAddingComponents:offsetComponents toDate:[self getStartDate] options:0];
}

- (NSDate *)getStartDateForPrevMonth {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    return [self.calendar dateByAddingComponents:offsetComponents toDate:[self getStartDate] options:0];
}

- (NSDate *)getStartDateForNextMonth {
    return [self getEndDate];
}

- (NSDate *)getStartDateForDay:(NSInteger)day {
    NSDateComponents *components = [self.components copy];
    [components setDay:day];
    return [self.calendar dateFromComponents:components];
}

- (NSString *)getStartDateKeyForDay:(NSInteger)day {
    NSDateComponents *components = [self.components copy];
    [components setDay:day];
    NSDate *date = [self.calendar dateFromComponents:components];
#if USE_GMT
    return [RecordDateHelper getGMTStringFromDate:date];
#else 
    return [RecordDateHelper getLocalStringFromDate:date];
#endif
}

- (NSDate *)getEndDateForDay:(NSInteger)day {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    return [self.calendar dateByAddingComponents:offsetComponents toDate:[self getStartDateForDay:day] options:0];
}

#pragma mark Data-fetching related methods

- (Record *)getPrimaryRecordForDay:(NSInteger)day {
    NSString *dateKey = [self getStartDateKeyForDay:day];
    if (self.dailyRecordDictionary == nil ||
        self.dailyRecordDictionary[dateKey] == nil) {
        return nil;
    }
    NSArray *records = self.dailyRecordDictionary[dateKey];
    return records[0];
}

- (Record *)getSecondaryRecordForDay:(NSInteger)day {
    NSString *dateKey = [self getStartDateKeyForDay:day];
    if (self.dailyRecordDictionary == nil ||
        self.dailyRecordDictionary[dateKey] == nil) {
        return nil;
    }
    NSArray *records = self.dailyRecordDictionary[dateKey];
    if (records.count <= 1) {
        return nil;
    }
    return records[1];
}

- (void)loadAllRecords:(void (^)(NSError *error))monthCompletion {
    [Record loadAllEnabledRecordsForTimeRange:[self getStartDate] endDate:[self getEndDate] cacheKey:[self getCacheKey] completion:^(NSArray *records, NSError *error) {
        if (error == nil) {
            NSLog(@"Loaded all records for month: %lu", (unsigned long)records.count);
            self.dailyRecordDictionary = [[NSMutableDictionary alloc] init];
            for (Record *record in records) {
                if (!record.type || record.type.archived) {
                    // DO NOTHING
                    NSLog(@"loaded record with invalid type");
                } else {
                    NSDate *recordDate = record[kDateFieldKey];
                    NSString *dateKey = record[kDateStringFieldKey];
                    if (!dateKey || !dateKey.length) {
#if USE_GMT
                    dateKey = [RecordDateHelper getGMTStringFromDate:recordDate];
#else
                    dateKey = [RecordDateHelper getLocalStringFromDate:recordDate];
#endif
                    }
                    if (self.dailyRecordDictionary[dateKey] == nil) {
                        self.dailyRecordDictionary[dateKey] = [[NSMutableArray alloc] init];
                    }
                    [self.dailyRecordDictionary[dateKey] addObject:record];
                }
            }
        } else {
            NSLog(@"Error loading records for month: %@", [self getTitleString]);
        }
        monthCompletion(error);
    }];
}

#pragma mark Query tracking / caching helper

- (NSString *)getCacheKey {
#if USE_GMT
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedGMTDateFormatter];
#else
    NSDateFormatter *dateFormatter = [RecordDateHelper sharedLocalDateFormatter];
#endif
    [dateFormatter setDateFormat:@"MM_yyyy"];

    NSString *dateStr = [dateFormatter stringFromDate:[self getStartDate]];
    NSString *key = [NSString stringWithFormat:@"%@_%@", kRecordQueryKey, dateStr];
    return key;
}

@end
