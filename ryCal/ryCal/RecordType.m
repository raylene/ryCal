//
//  RecordType.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordType.h"
#import "User.h"
#import "SharedConstants.h"

@implementation RecordType

+ (NSString *)parseClassName {
    return @"RecordType";
}

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    // TODO: do I need to manually enforce that the typeName is unique per user?
    PFObject *newRecordType = [PFObject objectWithClassName:@"RecordType"];
    newRecordType[@"name"] = typeName;
    newRecordType[@"color"] = typeColor;
    newRecordType[@"userID"] = [[User currentUser] getUserID];
    [newRecordType saveInBackgroundWithBlock:completion];
}

+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading all record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query whereKey:@"userID" equalTo:[[User currentUser] getUserID]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];
}

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

@end
