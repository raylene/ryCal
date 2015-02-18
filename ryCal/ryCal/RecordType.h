//
//  RecordType.h
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RecordType : PFObject<PFSubclassing>

// Creation methods
+ (RecordType *)createNewDefaultRecordType;

//+ (void)loadEnabledTypes;
+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion;
+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion;
+ (void)loadFromID:(NSString *)objectID completion:(void (^)(RecordType *type, NSError *error))completion;

+ (void)createTestRecordTypes;

// Fields
//- (void)setArchivedField:(BOOL)archivedField;
//- (BOOL)getArchivedField;
//
//- (void)setColorField:(NSString *)colorField;
//- (NSString *)getColorField;
//
//- (void)setUserIDField:(NSString *)userIDField;
//- (NSString *)getUserIDField;
//
//- (void)setNameField:(NSString *)nameField;
//- (NSString *)getNameField;

@end
