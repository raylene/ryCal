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

+ (RecordType *)createNewDefaultRecordType {
    RecordType *newRecordType = [RecordType object];
    newRecordType[kColorFieldKey] = [SharedConstants getDefaultColorName];
    newRecordType[kUserIDFieldKey] = [[User currentUser] getUserID];
    newRecordType[kArchivedFieldKey] = @YES;
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
    [newRecordType saveInBackgroundWithBlock:completion];
}

+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading only enabled record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
    [query whereKey:kArchivedFieldKey notEqualTo:@YES];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];
}

+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion {
    NSLog(@"Loading all record types for user: %@", [[User currentUser] getUserID]);
    PFQuery *query = [PFQuery queryWithClassName:@"RecordType"];
    [query whereKey:kUserIDFieldKey equalTo:[[User currentUser] getUserID]];
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
