//
//  RecordType.h
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface RecordType : PFObject<PFSubclassing>

// Creation methods
+ (RecordType *)createNewDefaultRecordType;

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor completion:(void (^)(BOOL succeeded, NSError *error)) completion;
+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor archived:(BOOL)archived completion:(void (^)(BOOL succeeded, NSError *error)) completion;

+ (void)loadEnabledTypes:(void (^)(NSArray *types, NSError *error))completion;
+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion;

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
