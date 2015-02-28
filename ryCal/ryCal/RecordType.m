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

+ (void)saveType:(RecordType *)type completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [type pinInBackgroundWithName:kRecordTypeQueryKey block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saving type... %@, %@", type.name, type.color);
            // TODO: see if the completion logic should be changed here
            [type saveInBackground];
        }
        completion(succeeded, error);
    }];
}

+ (void)deleteType:(RecordType *)type completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [type unpinInBackgroundWithName:kRecordTypeQueryKey block:^(BOOL succeeded, NSError *error) {
        // TODO: see if the completion logic should be changed here
        if (succeeded || !error) {
            [type deleteEventually];
        }
        completion(succeeded, error);
    }];
}

// Parse: base query used for fetching any record types
+ (PFQuery *)createBasicRecordTypeQuery:(NSString *)queryKey {
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByAscending:@"archived"];
    [query addDescendingOrder:@"updatedAt"];
    
    if ([[RecordQueryTracker sharedQueryTracker] hasQuery:queryKey]) {
       [query fromLocalDatastore];
    }
    return query;
}

+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading only enabled record types for user: %@", [[User currentUser] getUserID]);
    [self loadAllTypes:^(NSArray *types, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (RecordType *type in types) {
            if (!type.archived) {
                [results addObject:type];
            }
        }
        completion(results, error);
    }];
}

+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading all record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [self createBasicRecordTypeQuery:kRecordTypeQueryKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [[RecordQueryTracker sharedQueryTracker] updateDatastore:kRecordTypeQueryKey objects:objects];
        }
        completion(objects, error);
    }];
}

+ (void)forceReloadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"forceReloadAllTypes...");
    [self loadAllTypes:^(NSArray *types, NSError *error) {
        NSLog(@"forceReloadAllTypes COMPLETION: %ld, %@", types.count, error);
        if (!error) {
            [[RecordQueryTracker sharedQueryTracker] removeQuery:kRecordTypeQueryKey];
        }
        completion(types, error);
    }];
}

#pragma mark Private methods to test creation of record types
+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor archived:(BOOL)archived completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    RecordType *newRecordType = [RecordType object];
    newRecordType.name = typeName;
    newRecordType.color = typeColor;
    newRecordType.userID = [[User currentUser] getUserID];
    newRecordType.archived = archived;
    [newRecordType saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(succeeded, error);
    }];
}

+ (void)createTestRecordTypes {
    [RecordType createRecordType:@"climbing" typeColor:RECORD_COLOR_BLUE archived:NO completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
    [RecordType createRecordType:@"running" typeColor:RECORD_COLOR_GREEN archived:NO completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
    [RecordType createRecordType:@"dancing" typeColor:RECORD_COLOR_PURPLE archived:NO completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Created new record type!");
        }
    }];
}

@end
