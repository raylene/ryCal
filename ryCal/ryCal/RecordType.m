//
//  RecordType.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordType.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"
#import "SharedConstants.h"
#import "RecordQueryTracker.h"

@implementation RecordType

@dynamic archived;
@dynamic color;
@dynamic userID;
@dynamic name;
@dynamic description;

+ (NSString *)parseClassName {
    return @"RecordType";
}

+ (RecordType *)createNewDefaultRecordType {
    RecordType *newRecordType = [RecordType object];
    newRecordType.color = [SharedConstants getDefaultColorName];
    newRecordType.userID = [[User currentUser] getUserID];
    newRecordType.archived = NO;
    return newRecordType;
}

// Private creation methods for testing
+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [self createRecordType:typeName typeColor:typeColor archived:NO completion:completion];
}

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor archived:(BOOL)archived completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    RecordType *newRecordType = [RecordType object];
    newRecordType.name = typeName;
    newRecordType.color = typeColor;
    newRecordType.userID = [[User currentUser] getUserID];
    newRecordType.archived = archived;
    [newRecordType saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RecordTypeDataChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
        }
        completion(succeeded, error);
    }];
}

+ (void)saveType:(RecordType *)type completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [type saveEventually:^(BOOL succeeded, NSError *error) {
        [self dirtyQueryCache];
        completion(succeeded, error);
    }];
}

+ (void)deleteType:(RecordType *)type completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [type deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dirtyQueryCache];
        completion(succeeded, error);
    }];
}

// Parse: base query used for fetching any record types
+ (PFQuery *)createBasicRecordTypeQuery:(NSString *)queryKey {
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByAscending:@"archived"];
    [query addDescendingOrder:@"updatedAt"];
    
    // TODO: FIX THIS. removing for now as the logic is all borked :/
    // if ([[RecordQueryTracker sharedQueryTracker] hasQuery:queryKey]) {
    //   [query fromLocalDatastore];
    // }

    return query;
}

+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading only enabled record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [self createBasicRecordTypeQuery:kEnabledRecordTypeQueryKey];
    [query whereKey:kArchivedFieldKey notEqualTo:@YES];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self updateQueryTrackerAndDatastore:kEnabledRecordTypeQueryKey objects:objects];
        completion(objects, error);
    }];
}

+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading all record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [self createBasicRecordTypeQuery:kRecordTypeQueryKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self updateQueryTrackerAndDatastore:kRecordTypeQueryKey objects:objects];
        completion(objects, error);
    }];
}

//+ (void)loadFromID:(NSString *)objectID completion:(void (^)(RecordType *type, NSError *error))completion {
//    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
//        for (RecordType *recordType in types) {
//            if ([objectID isEqualToString:recordType.objectId]) {
//                completion(recordType, error);
//            }
//        }
//    }];
//}

+ (void)createTestRecordTypes {
    [RecordType createRecordType:@"climbing" typeColor:RECORD_COLOR_BLUE completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
    [RecordType createRecordType:@"running" typeColor:RECORD_COLOR_GREEN completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
    [RecordType createRecordType:@"dancing" typeColor:RECORD_COLOR_PURPLE completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
}

#pragma mark Query tracking helper methods

+ (void)dirtyQueryCache {
    NSLog(@"dirty");
    [[RecordQueryTracker sharedQueryTracker] removeQuery:kRecordTypeQueryKey];
    [[RecordQueryTracker sharedQueryTracker] removeQuery:kEnabledRecordTypeQueryKey];
}

// TODO: share code with Record.m? move this into RecordQueryTracker?
+ (void)updateQueryTrackerAndDatastore:(NSString *)key objects:(NSArray *)objects{
    [[RecordQueryTracker sharedQueryTracker] updateDatastore:key objects:objects];
}

@end
