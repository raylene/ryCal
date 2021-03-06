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
#import "RecordDateHelper.h"

@implementation Record

@dynamic note;
@dynamic typeID;
@dynamic type;
@dynamic userID;
@dynamic date;
@dynamic dateGMT;
@dynamic dateString;

+ (NSString *)parseClassName {
    return @"Record";
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

    // Don't save any new date stuff yet to be safe...
    NSString *dateString = [RecordDateHelper getGMTStringFromDate:date];
    newRecord.dateString = dateString;
    
    NSDate *dateGMT = [RecordDateHelper getDateGMTFromUserDate:date];
    
    NSLog(@"Date manipulation: (record)%@, (gmt)%@, (str)%@",
          newRecord.date,
          dateGMT,
          dateString);
    return newRecord;
}

+ (void)saveRecord:(Record *)record cacheKey:(NSString *)key completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [record pinInBackgroundWithName:key block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [record saveInBackground];
        }
        completion(succeeded, error);
    }];
}

+ (void)deleteRecord:(Record *)record cacheKey:(NSString *)key completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [record unpinInBackgroundWithName:key block:^(BOOL succeeded, NSError *error) {
        // TODO: see if the completion logic should be changed here
        if (succeeded) {
            [record deleteInBackground];
        }
        completion(succeeded, error);
    }];
}

// TODO: This currently still loads all records vs. only enabled ones
+ (void)loadAllEnabledRecordsForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate cacheKey:(NSString *)key completion:(void (^)(NSArray *records, NSError *error))completion {
    NSLog(@"Loading all ENABLED records for time range: %@, %@", startDate, endDate);
    PFQuery *query = [self createBasicRecordQuery:key];
    // Date comparison: https://www.parse.com/questions/cloud-code-querying-objects-by-creation-date
    [query whereKey:kDateFieldKey greaterThanOrEqualTo:startDate];
    [query whereKey:kDateFieldKey lessThan:endDate];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Loaded %ld ENABLED records for time range: %@, %@", (unsigned long)objects.count, startDate, endDate);
        if (!error) {
            [[RecordQueryTracker sharedQueryTracker] updateDatastore:key objects:objects];
        }
        completion(objects, error);
    }];
}

// TODO: add pinnable key
+ (void)loadRecordDictionaryForTimeRange:(NSDate *)startDate endDate:(NSDate *)endDate cacheKey:(NSString *)key completion:(void (^)(NSDictionary *recordDict, NSError *error))completion {
    [self loadAllEnabledRecordsForTimeRange:startDate endDate:endDate cacheKey:key completion:^(NSArray *records, NSError *error) {
        NSMutableDictionary *recordDict = [[NSMutableDictionary alloc] init];
        if (!error) {
            for (Record *record in records) {
                NSString *recordTypeID = record.typeID;
                [recordDict setObject:record forKey:recordTypeID];
            }
        }
        completion(recordDict, error);
    }];
}

// Parse: base query used for fetching any records
+ (PFQuery *)createBasicRecordQuery:(NSString *)queryKey {
    PFQuery *query = [PFQuery queryWithClassName:@"Record"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByAscending:@"date"];
    [query addDescendingOrder:@"updatedAt"];
    [query includeKey:kTypeFieldKey];
    
    if ([[RecordQueryTracker sharedQueryTracker] hasQuery:queryKey]) {
        [query fromLocalDatastore];
    }
    return query;
}

#pragma mark Helper getters

- (UIColor *)getColor {
    if (self.type == nil) {
        // TODO: this should only be needed to deal with my old data created for december
        return [SharedConstants getPlaceholderRecordTypeColor];
    } else {
        return [SharedConstants getColor:self.type[kColorFieldKey]];
    }
}

- (NSString *)getDateStringKey {
#if USE_GMT
    return [RecordDateHelper getGMTStringFromDate:self.date];
#else
    return [RecordDateHelper getLocalStringFromDate:self.date];
#endif
}

+ (void)forceReloadAllRecords:(void (^)(NSArray *records, NSError *error))completion {
    
}

@end
