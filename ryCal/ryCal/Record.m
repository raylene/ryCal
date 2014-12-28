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
    PFObject *newRecord = [PFObject objectWithClassName:@"Record"];
    newRecord[@"typeID"] = typeID;
    if (text != nil) {
        newRecord[@"note"] = text;
    }
    newRecord[@"userID"] = [[User currentUser] getUserID];
    newRecord[@"date"] = date;
    return (Record *)newRecord;
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
    PFObject *newRecord = [PFObject objectWithClassName:@"Record"];
    newRecord[@"typeID"] = typeID;
    if (text != nil) {
        newRecord[@"note"] = text;
    }
    newRecord[@"userID"] = [[User currentUser] getUserID];
    newRecord[@"date"] = date;
    [newRecord saveInBackgroundWithBlock:completion];
//    return (Record *)newRecord;
}

+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records");
    PFQuery *query = [self createBasicRecordQuery];
    [query findObjectsInBackgroundWithBlock:completion];
}

// Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
+ (void)loadAllRecordsForMonth:(Month *)month completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records for month: ");
    PFQuery *query = [self createBasicRecordQuery];
    [query whereKey:@"date" greaterThanOrEqualTo:[month getStartDate]];
    [query findObjectsInBackgroundWithBlock:completion];
}

// Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
+ (void)loadAllRecordsForDay:(Day *)day completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all records for day: ");
    PFQuery *query = [self createBasicRecordQuery];
    [query whereKey:@"date" greaterThanOrEqualTo:[day getStartDate]];
    [query whereKey:@"date" lessThan:[day getEndDate]];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (PFQuery *)createBasicRecordQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
    [query whereKey:@"userID" equalTo:[[User currentUser] getUserID]];
    [query orderByDescending:@"createdAt"];
    return query;
}

+ (void)createTestRecordsForDate:(NSDate *)date {
    [self createRecord:TEST_TYPE_RUNNING withText:@"bernal heights loop" onDate:date completion:nil];
    [self createRecord:TEST_TYPE_RUNNING withText:nil onDate:date completion:nil];
    [self createRecord:TEST_TYPE_DANCING withText:@"monday bhangra!" onDate:date completion:nil];
    [self createRecord:TEST_TYPE_CLIMBING withText:@"climbed my first v2!" onDate:date completion:nil];
}

- (void)updateText:(NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    NSLog(@"updateText: %@", text);
    if (text == nil) {
        return;
    }
    [self setObject:text forKey:@"note"];
    [self saveInBackgroundWithBlock:completion];
}

@end
