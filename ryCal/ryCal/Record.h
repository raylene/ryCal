//
//  Record.h
//  ryCal
//
//  Represents a single PFObject record for a given day. (E.g. "(Running) Ran 5 mi")
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "RecordType.h"

@interface Record : PFObject<PFSubclassing>

// PFObject keys
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) RecordType *type;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSDate *date;

// Creation methods
+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text;
+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text onDate:(NSDate *)date;

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion;
+ (void)loadAllEnabledRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *records, NSError *error))completion;

- (UIColor *)getColor;
- (NSString *)getDateStringKey;

@end
