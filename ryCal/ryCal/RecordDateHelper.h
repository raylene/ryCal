//
//  RecordDateHelper.h
//  ryCal
//
//  Created by Raylene Yung on 4/24/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordDateHelper : NSObject

// Shared helper classes
+ (NSDateFormatter *)sharedGMTDateFormatter;
+ (NSDateFormatter *)sharedLocalDateFormatter;
+ (NSCalendar *)sharedGMTCalendar;
+ (NSCalendar *)sharedLocalCalendar;

// Now / Date
+ (NSDate *)getLocalStartOfToday;
+ (NSDate *)getGMTStartOfToday;

// Used in Month.m
+ (NSString *)getLocalStringFromDate:(NSDate *)inputDate;
+ (NSString *)getGMTStringFromDate:(NSDate *)inputDate;

// Still needed?
+ (NSInteger)getCurrentYear;

+ (NSDate *)getSystemDateFromUserDate:(NSDate *)userDate;
+ (NSDate *)getDateGMTFromUserDate:(NSDate *)userDate;

@end
