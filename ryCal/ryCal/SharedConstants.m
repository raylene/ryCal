//
//  SharedConstants.m
//  ryCal
//
//  Created by Raylene Yung on 12/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "SharedConstants.h"

@interface SharedConstants ()

@end

@implementation SharedConstants

// Notifications
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const ColorSelectedNotification = @"ColorSelectedNotification";

NSString * const COLOR_NOTIF_PARAM = @"colorname";

NSString * const kNoteFieldKey = @"note";
NSString * const kTypeIDFieldKey = @"typeID";
NSString * const kUserIDFieldKey = @"userID";
NSString * const kDateFieldKey = @"date";
NSString * const kArchivedFieldKey = @"archived";
NSString * const kColorFieldKey = @"color";
NSString * const kNameFieldKey = @"name";

NSString * const RECORD_COLOR_EMPTY_ENTRY = @"emptyentry";
NSString * const RECORD_COLOR_LIGHT_BLUE = @"lightblue";

NSString * const RECORD_COLOR_BLUE = @"blue";
NSString * const RECORD_COLOR_DEEP_BLUE = @"deepblue";
NSString * const RECORD_COLOR_GREEN = @"green";
NSString * const RECORD_COLOR_TEAL = @"teal";
NSString * const RECORD_COLOR_PURPLE = @"purple";
NSString * const RECORD_COLOR_PINK = @"pink";
NSString * const RECORD_COLOR_RED = @"red";
NSString * const RECORD_COLOR_ORANGE = @"orange";
NSString * const RECORD_COLOR_YELLOW = @"yellow";
NSString * const RECORD_COLOR_BROWN = @"brown";

NSString * const TEST_TYPE_RUNNING = @"CIURHHmoNZ";
NSString * const TEST_TYPE_DANCING = @"8TXojnKMZC";
NSString * const TEST_TYPE_CLIMBING = @"V6UNX3Rq3m";

int const NUM_COLORS = 10;

// Convert to singleton? http://www.galloway.me.uk/tutorials/singleton-classes/
+ (NSArray *)getColorArray {
    return @[
             RECORD_COLOR_DEEP_BLUE,
             RECORD_COLOR_BLUE,
             RECORD_COLOR_TEAL,
             RECORD_COLOR_GREEN,
             RECORD_COLOR_PURPLE,
             RECORD_COLOR_PINK,
             RECORD_COLOR_RED,
             RECORD_COLOR_ORANGE,
             RECORD_COLOR_YELLOW,
             RECORD_COLOR_BROWN
             ];
}

+ (NSString *)getDefaultColorName {
    return RECORD_COLOR_DEEP_BLUE;
}

// Hex colors from: http://www.w3schools.com/tags/ref_colorpicker.asp
+ (UIColor *)getColor:(NSString *)name {
    unsigned long int rgbValue = 0xBAE3FF;
    if ([name isEqualToString:RECORD_COLOR_EMPTY_ENTRY]) {
        rgbValue = 0xE2E2FF;
    } else if ([name isEqualToString:RECORD_COLOR_LIGHT_BLUE]) {
        rgbValue = 0xE6F0FF;
    } else if ([name isEqualToString:RECORD_COLOR_BLUE]) {
        rgbValue = 0x99CCFF;
    } else if ([name isEqualToString:RECORD_COLOR_DEEP_BLUE]) {
        rgbValue = 0x7B96E4;
    } else if ([name isEqualToString:RECORD_COLOR_GREEN]) {
        rgbValue = 0x80E680;
    } else if ([name isEqualToString:RECORD_COLOR_TEAL]) {
        rgbValue = 0x5FDFBF;
    } else if ([name isEqualToString:RECORD_COLOR_PURPLE]) {
        rgbValue = 0xBF7EFF;
    } else if ([name isEqualToString:RECORD_COLOR_PINK]) {
        rgbValue = 0xFFA3D1;
    } else if ([name isEqualToString:RECORD_COLOR_RED]) {
        rgbValue = 0xFF7171;
    } else if ([name isEqualToString:RECORD_COLOR_ORANGE]) {
        rgbValue = 0xFFAD5C;
    } else if ([name isEqualToString:RECORD_COLOR_YELLOW]) {
        rgbValue = 0xFFFF99;
    } else if ([name isEqualToString:RECORD_COLOR_BROWN]) {
        rgbValue = 0xB5916C;
    }
    // From: http://www.appcoda.com/customize-navigation-status-bar-ios-7/
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (NSInteger)getCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [[formatter stringFromDate:[NSDate date]] integerValue];
}

@end
