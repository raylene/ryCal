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
#import "RecordQueryTracker.h"

@implementation Record

@dynamic note;
@dynamic typeID;
@dynamic type;
@dynamic userID;
@dynamic date;

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
    newRecord.type = type;
    newRecord.typeID = type.objectId;
    if (text != nil) {
        newRecord.note = text;
    }
    newRecord.userID = [[User currentUser] getUserID];
    newRecord.date = date;
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
    newRecord.type = type;
    newRecord.typeID = type.objectId;
    if (text != nil) {
        newRecord.note = text;
    }
    newRecord.userID = [[User currentUser] getUserID];
    newRecord.date = date;
    [newRecord saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dirtyQueryCache];
            // TODO: figure out why this isn't working?
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
            // TODO: clean up duplicate Month + Day notifs being sent out
            [[NSNotificationCenter defaultCenter] postNotificationName:DayDataChangedNotification object:nil];
        }
        completion(succeeded, error);
    }];
}

+ (void)deleteRecord:(Record *)record completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [record deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dirtyQueryCache];
        completion(succeeded, error);
    }];
}

//+ (void)loadAllRecords:(void (^)(NSArray *records, NSError *error))completion {
//    NSLog(@"Loading all records");
//    PFQuery *query = [self createBasicRecordQuery];
//    [query findObjectsInBackgroundWithBlock:completion];
//}

// TODO: may not need this unless we support stats for both enabled/archived records
//+ (void)loadAllRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *records, NSError *error))completion {
//    NSLog(@"Loading all records for time range: %@, %@", startDate, endDate);
//    PFQuery *query = [self createTimeRangeRecordQuery:startDate endDate:endDate];
//    [query findObjectsInBackgroundWithBlock:completion];
//}

+ (void)loadAllEnabledRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all ENABLED records for time range: %@, %@", startDate, endDate);
    PFQuery *query = [self createTimeRangeRecordQuery:startDate endDate:endDate];
//    [query whereKey:kArchivedFieldKey notEqualTo:[NSNumber numberWithBool:YES]];
    // TODO: FIX FIX - this needs to actually check that the type still exists / is enabled
    [query includeKey:kTypeFieldKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self updateQueryTrackerAndDatastore:kRecordTypeQueryKey objects:objects];
        completion(objects, error);
    }];
}

+ (PFQuery *)createTimeRangeRecordQuery:(NSDate *)startDate endDate:(NSDate *)endDate {
    PFQuery *query = [self createBasicRecordQuery:kRecordQueryKey];
    // Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
    [query whereKey:kDateFieldKey greaterThanOrEqualTo:startDate];
    [query whereKey:kDateFieldKey lessThan:endDate];
    return query;
}

// Parse: base query used for fetching any records
+ (PFQuery *)createBasicRecordQuery:(NSString *)queryKey {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
//    [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByAscending:@"date"];
    [query addDescendingOrder:@"updatedAt"];
    [query includeKey:kTypeFieldKey];
    
    // Query is already cached, use local datastore
    if ([[RecordQueryTracker sharedQueryTracker] hasQuery:queryKey]) {
        [query fromLocalDatastore];
    }
    return query;
}

- (UIColor *)getColor {
    if (self.type == nil) {
        // TODO: this should only be needed to deal with my old data created for december
        return [SharedConstants getPlaceholderRecordTypeColor];
    } else {
        return [SharedConstants getColor:self.type[kColorFieldKey]];
    }
}

- (NSString *)getDateStringKey {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    return [dateFormatter stringFromDate:self.date];
}

#pragma mark Query tracking helper methods

+ (void)dirtyQueryCache {
    NSLog(@"dirty");
    [[RecordQueryTracker sharedQueryTracker] removeQuery:kRecordQueryKey];
}

// TODO: share code with Record.m? move this into RecordQueryTracker?
+ (void)updateQueryTrackerAndDatastore:(NSString *)key objects:(NSArray *)objects{
    if (![[RecordQueryTracker sharedQueryTracker] hasQuery:key]) {
        [PFObject unpinAllObjectsInBackgroundWithName:key block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // Cache the new results.
                [PFObject pinAllInBackground:objects
                                    withName:key
                                       block:^(BOOL succeeded, NSError *error) {
                                           [[RecordQueryTracker sharedQueryTracker] addQuery:key];
                                       }];
            }
        }];
    }
}

@end
