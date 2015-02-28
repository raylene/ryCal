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
    BOOL result = NO;
    @synchronized(self.queryNames) {
        result = (BOOL)[self.queryNames objectForKey:name];
    }
    return result;
}

- (void)removeQuery:(NSString *)name {
    NSLog(@"RecordQueryTracker, removeQuery: %@", name);
    @synchronized(self.queryNames) {
        [self.queryNames removeObjectForKey:name];
    }
}

- (void)addQuery:(NSString *)name {
    @synchronized(self.queryNames) {
        self.queryNames[name] = [NSDate date];
    }
}

- (void)updateDatastore:(NSString *)key objects:(NSArray *)objects {
//    NSLog(@"Updating LOCAL? query results for: %@ -- %@", key, objects);

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
    }
}

- (void)resetDatastore {
    @synchronized(self.queryNames) {
        for (NSString *key in self.queryNames) {
            [PFObject unpinAllObjectsInBackgroundWithName:key];
        }
        [self.queryNames removeAllObjects];
    }
}

- (BOOL)hasCachedData {
    @synchronized(self.queryNames) {
        return (BOOL)self.queryNames.count;
    }
}

@end