//
//  SharedConstants.h
//  ryCal
//
//  Created by Raylene Yung on 12/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedConstants : NSObject

// Notifications
extern NSString * const UserDidLogoutNotification;
extern NSString * const UserDidLoginNotification;
extern NSString * const ColorSelectedNotification;
extern NSString * const MonthDataChangedNotification;
extern NSString * const RecordTypeDataChangedNotification;

// Notif params
extern NSString * const kColorSelectedNotifParam;

extern NSString * const kNoteFieldKey;
extern NSString * const kTypeFieldKey;
extern NSString * const kTypeIDFieldKey;
extern NSString * const kUserIDFieldKey;
extern NSString * const kDateFieldKey;
extern NSString * const kArchivedFieldKey;
extern NSString * const kColorFieldKey;
extern NSString * const kNameFieldKey;

extern NSString * const RECORD_COLOR_EMPTY_ENTRY;
extern NSString * const RECORD_COLOR_LIGHT_BLUE;

extern NSString * const RECORD_COLOR_BLUE;
extern NSString * const RECORD_COLOR_DEEP_BLUE;
extern NSString * const RECORD_COLOR_GREEN;
extern NSString * const RECORD_COLOR_TEAL;
extern NSString * const RECORD_COLOR_PURPLE;
extern NSString * const RECORD_COLOR_PINK;
extern NSString * const RECORD_COLOR_RED;
extern NSString * const RECORD_COLOR_ORANGE;
extern NSString * const RECORD_COLOR_YELLOW;
extern NSString * const RECORD_COLOR_BROWN;

extern NSString * const TEST_TYPE_RUNNING;
extern NSString * const TEST_TYPE_DANCING;
extern NSString * const TEST_TYPE_CLIMBING;

extern int const NUM_COLORS;

+ (NSArray *)getColorArray;
+ (NSString *)getDefaultColorName;
+ (UIColor *)getPlaceholderRecordTypeColor;
+ (UIColor *)getColor:(NSString *)name;

+ (NSInteger)getCurrentYear;

@end
