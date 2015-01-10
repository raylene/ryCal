//
//  Record.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "Record.h"
#import "RecordType.h"
#import "User.h"
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "SharedConstants.h"

@interface Record ()

@end

@implementation Record

+ (NSString *)parseClassName {
    return @"Record";
}

+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text {
    return [Record createNewRecord:type withText:text onDate:[NSDate date]];
}

+ (Record *)createNewRecord:(RecordType *)type withText:(NSString *)text onDate:(NSDate *)date {
    NSLog(@"Creating record: %@, %@", text,
          [NSDateFormatter localizedStringFromDate:date
                                         dateStyle:NSDateFormatterShortStyle
                                         timeStyle:NSDateFormatterFullStyle]);
    Record *newRecord = [Record object];
    newRecord[kTypeFieldKey] = type;
    newRecord[kTypeIDFieldKey] = type.objectId;
    if (text != nil) {
        newRecord[kNoteFieldKey] = text;
    }
    newRecord[kUserIDFieldKey] = [[User currentUser] getUserID];
    newRecord[kDateFieldKey] = date;
    return newRecord;
}

+ (void)createRecord:(RecordType *)type withText:(NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [self createRecord:type withText:text onDate:[NSDate date] completion:completion];
}

+ (void)createRecord:(RecordType *)type withText:(NSString *)text onDate:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    NSLog(@"Creating record: %@, %@", text,
        [NSDateFormatter localizedStringFromDate:date
                                        dateStyle:NSDateFormatterShortStyle
                                        timeStyle:NSDateFormatterFullStyle]);
    [self saveRecord:type withText:text onDate:date completion:completion];
}

+ (void)saveRecord:(RecordType *)type withText:(NSString *)text onDate:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    Record *newRecord = [Record object];
    [newRecord setTypeField:type];
    [newRecord setTypeIDField:type.objectId];
    if (text != nil) {
        [newRecord setNoteField:text];
    }
    [newRecord setUserIDField:[[User currentUser] getUserID]];
    [newRecord setDateField:date];
    [newRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // TODO: figure out why this isn't working?
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
        }
        completion(succeeded, error);
    }];
}

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records");
    PFQuery *query = [self createBasicRecordQuery];
    [query findObjectsInBackgroundWithBlock:completion];
}

// Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
+ (void)loadAllRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records for time range: %@, %@", startDate, endDate);
    PFQuery *query = [self createBasicRecordQuery];
    [query whereKey:kDateFieldKey greaterThanOrEqualTo:startDate];
    [query whereKey:kDateFieldKey lessThan:endDate];
    [query includeKey:kTypeFieldKey];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (PFQuery *)createBasicRecordQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByAscending:@"date,updatedAt"];
    return query;
}

+ (void)createTestRecordsForDate:(NSDate *)date {
//    [self createRecord:TEST_TYPE_RUNNING withText:@"bernal heights loop" onDate:date completion:nil];
//    [self createRecord:TEST_TYPE_RUNNING withText:nil onDate:date completion:nil];
//    [self createRecord:TEST_TYPE_DANCING withText:@"monday bhangra!" onDate:date completion:nil];
//    [self createRecord:TEST_TYPE_CLIMBING withText:@"climbed my first v2!" onDate:date completion:nil];
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

- (void)setTypeField:(RecordType *)typeField {
    self[kTypeIDFieldKey] = typeField;
}

- (NSString *)getTypeField {
    return self[kTypeFieldKey];
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

- (UIColor *)getColor {
    if ([self getTypeField] == nil) {
        // TODO: this should only be needed to deal with my old data created for december
        return [SharedConstants getPlaceholderRecordTypeColor];
    } else {
        return [SharedConstants getColor:[self getTypeField][kColorFieldKey]];
    }
}

@end
