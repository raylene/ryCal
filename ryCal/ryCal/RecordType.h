//
//  RecordType.h
//  ryCal
//
//  Represents a single PFObject record type for a given user. (E.g. "Running")
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

@end
