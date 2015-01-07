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

@interface Month ()

@property (nonatomic, strong) NSDate *referenceDate;
@property (nonatomic, assign) NSInteger referenceDayIdx;

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, assign) NSRange dayRange;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSMutableDictionary *dailyRecordDictionary;

@end

@implementation Month

#pragma mark Custom Init methods

// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
- (id)initWithNSDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [self parseDateComponents:date];
        self.referenceDate = date;
    }
    return self;
}

- (void)parseDateComponents:(NSDate *)date {
    self.components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
    self.referenceDayIdx = self.components.day - 1;
    [self.components setDay:1];
    self.dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSLog(@"Day range for month: %lu, %lu", (unsigned long)self.dayRange.location, (unsigned long)self.dayRange.length);
    self.startDate = [self.calendar dateFromComponents:self.components];
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

- (NSDate *)getStartDateForDay:(int)day {
    NSDateComponents *components = [self.components copy];
    [components setDay:day];
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)getEndDateForDay:(int)day {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    return [self.calendar dateByAddingComponents:offsetComponents toDate:[self getStartDateForDay:day] options:0];
}

// TODO: fix this primary record business to use the primary record type?
// TODO: fix this to not return records that are of archived record types...
// will need to also fix loadAllRecords probably
- (Record *)getPrimaryRecordForDay:(int)day {
    NSDate *dateKey = [self getStartDateForDay:day];
    if (self.dailyRecordDictionary == nil ||
        self.dailyRecordDictionary[dateKey] == nil) {
        return nil;
    }
    NSArray *records = self.dailyRecordDictionary[dateKey];
//    NSLog(@"Records for DAY: %d, %@", day, records);
    return records[0];
}

- (void)loadAllRecords:(void (^)(NSError *error))monthCompletion {
    [Record loadAllRecordsForTimeRange:[self getStartDate] endDate:[self getEndDate] completion:^(NSArray *records, NSError *error) {
        if (error == nil) {
            NSLog(@"Loaded all records for month: %lu", (unsigned long)records.count);
            self.dailyRecordDictionary = [[NSMutableDictionary alloc] init];
            for (Record *record in records) {
                NSString *dateKey = record[kDateFieldKey];
                if (self.dailyRecordDictionary[dateKey] == nil) {
//                    self.dailyRecordDictionary[dateKey] = [[NSMutableDictionary alloc] init];
                    self.dailyRecordDictionary[dateKey] = [[NSMutableArray alloc] init];
                }
                //                [self.dailyRecordDictionary[dateKey] addObject:record forKey:record[kTypeIDFieldKey]];
                [self.dailyRecordDictionary[dateKey] addObject:record];
            }
        } else {
            NSLog(@"Error loading records for month: %@", [self getTitleString]);
        }
        monthCompletion(error);
    }];
}

// TODO: save this as a local var or static to avoid recomputing it?
- (BOOL)isCurrentMonth {
    return ([self.getStartDate compare:[NSDate date]] != NSOrderedDescending) &&
    ([self.getEndDate compare:[NSDate date]] == NSOrderedDescending);
}

#pragma mark Day manipulation

- (int)numDays {
    return (int)self.dayRange.length;
}

// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
- (NSString *)getTitleString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    if (self.components.year != [SharedConstants getCurrentYear]) {
        [dateFormatter setDateFormat:@"MMM yyyy"];
    }
    // Add the yyyy if it's not this year
    return [dateFormatter stringFromDate:[self getStartDate]];
}

@end
