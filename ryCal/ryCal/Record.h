//
//  Record.h
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Month.h"
#import "Day.h"

@interface Record : PFObject<PFSubclassing>

// Creation methods
+ (Record *)createNewRecord:(NSString *)typeID withText:(NSString *)text;
+ (Record *)createNewRecord:(NSString *)typeID withText:(NSString *)text onDate:(NSDate *)date;

//+ (void)createRecord:(NSString *)typeID withText:(NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion;
//+ (void)createRecord:(NSString *)typeID withText:(NSString *)text onDate:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion;

+ (void)createTestRecordsForDate:(NSDate *)date;

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion;
+ (void)loadAllRecordsForMonth:(Month *)month completion:(void (^)(NSArray *records, NSError *error))completion;
+ (void)loadAllRecordsForDay:(Day *)day completion:(void (^)(NSArray *records, NSError *error))completion;

- (void)updateText:(NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion;

@end
