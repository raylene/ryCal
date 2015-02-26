//
//  RecordQueryTracker.m
//  ryCal
//
//  Created by Raylene Yung on 2/23/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "RecordQueryTracker.h"
#import <Parse/Parse.h>

@implementation RecordQueryTracker

NSString * const kRecordTypeQueryKey = @"record_types";
//NSString * const kEnabledRecordTypeQueryKey = @"enabled_record_types";
NSString * const kRecordQueryKey = @"records";

@synthesize queryNames;

+ (id)sharedQueryTracker {
    static RecordQueryTracker *sharedQueryTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueryTracker = [[self alloc] init];
    });
    return sharedQueryTracker;
}

- (id)init {
    self = [super init];
    if (self) {
        queryNames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)hasQuery:(NSString *)name {
    return (BOOL)[self.queryNames objectForKey:name];
}

- (void)removeQuery:(NSString *)name {
    [self.queryNames removeObjectForKey:name];
}

- (void)addQuery:(NSString *)name {
    self.queryNames[name] = [NSDate date];
}

- (void)updateDatastore:(NSString *)key objects:(NSArray *)objects {
    NSLog(@"Updating LOCAL? query results for: %@ -- %@", key, objects);

    if (![self hasQuery:key]) {
        NSLog(@"RecordQueryTracker MISSING KEY: %@", key);
        // Cache the new results.
        [PFObject unpinAllObjectsInBackgroundWithName:key block:^(BOOL succeeded, NSError *error) {
            NSLog(@"unpinAllObjects: %@, %d, %@", key, succeeded, error);
            if (!error) {
                [PFObject pinAllInBackground:objects withName:key block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self addQuery:key];
                    }
                }];
            };
        }];
        //        [PFObject unpinAllObjectsInBackgroundWithName:key block:^(BOOL succeeded, NSError *error) {
        //            if (succeeded) {
        //                // Cache the new results.
        //                [PFObject pinAllInBackground:objects withName:key];
        //                [[RecordQueryTracker sharedQueryTracker] addQuery:key];
        //            }
        //        }];
    }
}

@end