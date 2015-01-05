//
//  Record.h
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "RecordType.h"

@interface Record : PFObject<PFSubclassing>

// Creation methods
+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text;
+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text onDate:(NSDate *)date;

+ (void)createTestRecordsForDate:(NSDate *)date;

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion;
+ (void)loadAllRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *records, NSError *error))completion;

// Fields
- (void)setNoteField:(NSString *)noteField;
- (NSString *)getNoteField;

- (void)setTypeIDField:(NSString *)typeIDField;
- (NSString *)getTypeIDField;

- (void)setTypeField:(RecordType *)typeField;
- (RecordType *)getTypeField;

- (void)setUserIDField:(NSString *)userIDField;
- (NSString *)getUserIDField;

- (void)setDateField:(NSDate *)dateField;
- (NSDate *)getDateField;

- (UIColor *)getColor;

@end
