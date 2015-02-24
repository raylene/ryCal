//
//  RecordQueryTracker.h
//  ryCal
//
//  Created by Raylene Yung on 2/23/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordQueryTracker : NSObject

extern NSString * const kRecordTypeQueryKey;
extern NSString * const kEnabledRecordTypeQueryKey;
extern NSString * const kRecordQueryKey;

@property (nonatomic, strong) NSMutableDictionary *queryNames;

+(id)sharedQueryTracker;

- (BOOL)hasQuery:(NSString *)name;
- (void)removeQuery:(NSString *)name;
- (void)addQuery:(NSString *)name;

// TODO: see if this should be in a better place..
- (void)updateDatastore:(NSString *)key objects:(NSArray *)objects;

@end
