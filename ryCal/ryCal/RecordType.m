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

@implementation RecordType

+ (NSString *)parseClassName {
    return @"RecordType";
}

+ (RecordType *)createNewDefaultRecordType {
    RecordType *newRecordType = [RecordType object];
    newRecordType[kColorFieldKey] = [SharedConstants getDefaultColorName];
    newRecordType[kUserIDFieldKey] = [[User currentUser] getUserID];
    newRecordType[kArchivedFieldKey] = @NO;
    return newRecordType;
}

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [self createRecordType:typeName typeColor:typeColor archived:NO completion:completion];
}

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor archived:(BOOL)archived completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    RecordType *newRecordType = [RecordType object];
    newRecordType[kNameFieldKey] = typeName;
    newRecordType[kColorFieldKey] = typeColor;
    newRecordType[kUserIDFieldKey] = [[User currentUser] getUserID];
    newRecordType[kArchivedFieldKey] = [[NSNumber alloc] initWithBool:archived];
    
    [newRecordType saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RecordTypeDataChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
        }
        completion(succeeded, error);
    }];
}

+ (PFQuery *)createBasicRecordTypeQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query orderByDescending:@"updatedAt"];
    return query;
}

// TODO: see if this singleton pattern is really the right thing to do...
static NSArray *_enabledRecordTypes;
+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading only enabled record types for user: %@", [[User currentUser] getUserID]);
    if (_enabledRecordTypes == nil) {
        PFQuery *query = [self createBasicRecordTypeQuery];
        [query whereKey:kArchivedFieldKey notEqualTo:@YES];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error != nil) {
                _enabledRecordTypes = objects;
            }
            completion(objects, error);
        }];
    } else {
        completion(_enabledRecordTypes, nil);
    }
}

+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading all record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [self createBasicRecordTypeQuery];
    [query findObjectsInBackgroundWithBlock:completion];
}

// TODO: fill this out?
+ (void)loadFromID:(NSString *)objectID completion:(void (^)(RecordType *type, NSError *error))completion {
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        for (RecordType *recordType in types) {
            if ([objectID isEqualToString:recordType.objectId]) {
                completion(recordType, error);
            }
        }
    }];
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

//#pragma mark Field accessors
//
//- (void)setNameField:(NSString *)nameField {
//    self[kNameFieldKey] = nameField;
//}
//
//- (NSString *)getNameField {
//    return self[kNameFieldKey];
//}
//
//- (void)setColorField:(NSString *)colorField {
//    self[kColorFieldKey] = colorField;
//}
//
//- (NSString *)getColorField {
//    return self[kColorFieldKey];
//}
//
//- (void)setUserIDField:(NSString *)userIDField {
//    self[kUserIDFieldKey] = userIDField;
//}
//
//- (NSString *)getUserIDField {
//    return self[kUserIDFieldKey];
//}
//
//- (void)setArchivedField:(BOOL)archivedField {
//    self[kArchivedFieldKey] = [[NSNumber alloc] initWithBool:archivedField];
//}
//
//- (BOOL)getArchivedField {
//    return self[kArchivedFieldKey];
//}

@end
