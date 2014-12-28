//
//  Month.m
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "Month.h"

@interface Month ()

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, assign) NSRange dayRange;
//@property (nonatomic, strong) NSDateComponents *components;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation Month

#pragma mark Custom Init methods

// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
- (id)initWithNSDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [self parseDateComponents:date];
    }
    return self;
}

- (void)parseDateComponents:(NSDate *)date {
    self.components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
    [self.components setDay:1];
    self.dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSLog(@"Day range for month: %lu, %lu", (unsigned long)self.dayRange.location, (unsigned long)self.dayRange.length);
    self.startDate = [self.calendar dateFromComponents:self.components];
}

- (NSDate *)getStartDate {
    return self.startDate;
}

- (NSDate *)getStartDateForDay:(int)day {
    NSDateComponents *components = [self.components copy];
    [components setDay:day];
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)getEndDateForDay:(int)day {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    return [self.calendar dateByAddingComponents:offsetComponents toDate: [self getStartDateForDay:day] options:0];
}

#pragma mark Day manipulation

- (int)numDays {
    return (int)self.dayRange.length;
}

@end
