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

+ (void)createRecordType:(NSString *)typeName typeColor:(NSString *)typeColor completion:(void (^)(BOOL succeeded, NSError *error)) completion;
+ (void)loadAllTypes:(void (^)(NSArray *types, NSError *error))completion;

+ (void)createTestRecordTypes;

@end
