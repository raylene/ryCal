//
//  Record.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "Record.h"
#import "User.h"
#import "Month.h"
#import "Day.h"
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "SharedConstants.h"

@implementation Record

+ (NSString *)parseClassName {
    return @"Record";
}

+ (Record *)createNewRecord:(NSString *)typeID withText:(NSString *)text {
    return [Record createNewRecord:typeID withText:text onDate:[NSDate date]];
}

+ (Record *)createNewRecord:(NSString *)typeID withText:(NSString *)text onDate:(NSDate *)date {
    NSLog(@"Creating record: %@, %@", text,
          [NSDateFormatter localizedStringFromDate:date
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterFullStyle]);
    Record *newRecord = [Record object];
    newRecord[kTypeIDFieldKey] = typeID;
    if (text != nil) {
        newRecord[kNoteFieldKey] = text;
    }
    newRecord[kUserIDFieldKey] = [[User currentUser] getUserID];
    newRecord[kDateFieldKey] = date;
    return newRecord;
}

+ (void)createRecord:(NSString *)typeID withText:(NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [self createRecord:typeID withText:text onDate:[NSDate date] completion:completion];
}

+ (void)createRecord:(NSString *)typeID withText:(NSString *)text onDate:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    NSLog(@"Creating record: %@, %@", text,
        [NSDateFormatter localizedStringFromDate:date
                                        dateStyle:NSDateFormatterShortStyle
                                        timeStyle:NSDateFormatterFullStyle]);
    [self saveRecord:typeID withText:text onDate:date completion:completion];
}

+ (void)saveRecord:(NSString *)typeID withText:(NSString *)text onDate:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    Record *newRecord = [Record object];
    [newRecord setTypeIDField:typeID];
    if (text != nil) {
        [newRecord setNoteField:text];
    }
    [newRecord setUserIDField:[[User currentUser] getUserID]];
    [newRecord setDateField:date];
    [newRecord saveInBackgroundWithBlock:completion];
}

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records");
    PFQuery *query = [self createBasicRecordQuery];
    [query findObjectsInBackgroundWithBlock:completion];
}

// Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
+ (void)loadAllRecordsForMonth:(Month *)month completion:(void (^)(NSArray *records, NSError *error))completion {
    PFQuery *query = [self createBasicRecordQuery];
    [query whereKey:kDateFieldKey greaterThanOrEqualTo:[month getStartDate]];
    [query whereKey:kDateFieldKey lessThan:[month getEndDate]];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (void)loadAllRecordsForDay:(Day *)day completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records for day: ");
    PFQuery *query = [self createBasicRecordQuery];
    [query whereKey:kDateFieldKey greaterThanOrEqualTo:[day getStartDate]];
    [query whereKey:kDateFieldKey lessThan:[day getEndDate]];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (PFQuery *)createBasicRecordQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByDescending:@"createdAt"];
    return query;
}

+ (void)createTestRecordsForDate:(NSDate *)date {
    [self createRecord:TEST_TYPE_RUNNING withText:@"bernal heights loop" onDate:date completion:nil];
    [self createRecord:TEST_TYPE_RUNNING withText:nil onDate:date completion:nil];
    [self createRecord:TEST_TYPE_DANCING withText:@"monday bhangra!" onDate:date completion:nil];
    [self createRecord:TEST_TYPE_CLIMBING withText:@"climbed my first v2!" onDate:date completion:nil];
}

#pragma mark Field accessors

- (void)setNoteField:(NSString *)noteField {
    self[kNoteFieldKey] = noteField;
}

- (NSString *)getNoteField {
    return self[kNoteFieldKey];
}

- (void)setTypeIDField:(NSString *)typeIDField {
    self[kTypeIDFieldKey] = typeIDField;
}

- (NSString *)getTypeIDField {
    return self[kTypeIDFieldKey];
}

- (void)setUserIDField:(NSString *)userIDField {
    self[kUserIDFieldKey] = userIDField;
}

- (NSString *)getUserIDField {
    return self[kUserIDFieldKey];
}

- (void)setDateField:(NSDate *)dateField {
    self[kDateFieldKey] = dateField;
}

- (NSDate *)getDateField {
    return self[kDateFieldKey];
}

@end
