//
//  RecordDateHelper.m
//  ryCal
//
//  Created by Raylene Yung on 4/24/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "RecordDateHelper.h"

@implementation RecordDateHelper

// Shared date formatting helper classes
+ (NSDateFormatter *)sharedGMTDateFormatter {
    static NSDateFormatter *_sharedGMTDateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGMTDateFormatter = [[NSDateFormatter alloc] init];\
        [_sharedGMTDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [_sharedGMTDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return _sharedGMTDateFormatter;
}

+ (NSDateFormatter *)sharedLocalDateFormatter {
    static NSDateFormatter *_sharedLocalDateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocalDateFormatter = [[NSDateFormatter alloc] init];
        [_sharedLocalDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [_sharedLocalDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return _sharedLocalDateFormatter;
}

+ (NSCalendar *)sharedGMTCalendar {
    static NSCalendar *_sharedGMTCalendar = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGMTCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_sharedGMTCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    });
    return _sharedGMTCalendar;
}

+ (NSCalendar *)sharedLocalCalendar {
    static NSCalendar *_sharedLocalCalendar = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocalCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_sharedLocalCalendar setTimeZone:[NSTimeZone localTimeZone]];
    });
    return _sharedLocalCalendar;
}

// End shared classes

// Now / Today
+ (NSDate *)getLocalStartOfToday {
    return [NSDate date];
}

+ (NSDate *)getGMTStartOfToday {
    NSDate *today = [NSDate date];
    return [self getGMTDayStartFromLocalDate:today];
}

//////

+ (NSInteger)getCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [[formatter stringFromDate:[NSDate date]] integerValue];
}

+ (NSString *)getGMTStringFromDate:(NSDate *)inputDate {
    return [[self sharedGMTDateFormatter] stringFromDate:inputDate];
}

+ (NSString *)getLocalStringFromDate:(NSDate *)inputDate {
    return [[self sharedLocalDateFormatter] stringFromDate:inputDate];
}

+ (NSDate *)getSystemDateFromUserDate:(NSDate *)userDate {
    return userDate;
}

+ (NSDate *)getDateGMTFromUserDate:(NSDate *)userDate {
    // Get date string using local timezone
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:userDate];
    
    // Now switch to GMT time (midnight / start of day) for same date string
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

#pragma Local helper methods

+ (NSDateComponents *)parseComponents:(NSDate *)date calendar:(NSCalendar *)calendar {
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: date];
}

+ (NSDate *)getGMTDayStartFromLocalDate:(NSDate *)localDate {
    // Get components using local time
    NSCalendar *localCal = [RecordDateHelper sharedLocalCalendar];
    NSDateComponents *localComponents = [self parseComponents:localDate calendar:localCal];
    
    // Convert components back to the same m/d/y in GMT
    NSCalendar *gmtCal = [RecordDateHelper sharedGMTCalendar];
    NSDate *gmtDate = [gmtCal dateFromComponents:localComponents];
    
    NSLog(@"Local<=>GMT: %@, %@", [localDate description], [gmtDate description]);
    return gmtDate;
}

@end
