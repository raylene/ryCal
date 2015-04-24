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

// Still needed?
+ (NSInteger)getCurrentYear;

+ (NSString *)getDateStringFromDate:(NSDate *)inputDate;
+ (NSDate *)getSystemDateFromUserDate:(NSDate *)userDate;
+ (NSDate *)getDateGMTFromUserDate:(NSDate *)userDate;

@end
