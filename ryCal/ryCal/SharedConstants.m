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
NSString * const UserFailedLoginNotification = @"UserFailedLoginNotification";
NSString * const ColorSelectedNotification = @"ColorSelectedNotification";
NSString * const MonthDataChangedNotification = @"MonthDataChangedNotification";
NSString * const DayDataChangedNotification = @"DayDataChangedNotification";
NSString * const RecordTypeDataChangedNotification = @"RecordTypeDataChangedNotification";
NSString * const ViewFullDayNotification = @"ViewFullDayNotification";
NSString * const SwitchDayNotification = @"SwitchDayNotification";

NSString * const kColorSelectedNotifParam = @"colorname";
NSString * const kRecordTypeIDNotifParam = @"recordtypeid";
NSString * const kRecordTypeIDNotifParamPlaceholder = @"recordtypeid_placeholder";
NSString * const kDayNotifParam = @"day";

NSString * const kNoteFieldKey = @"note";
NSString * const kTypeFieldKey = @"type";
NSString * const kTypeIDFieldKey = @"typeID";
NSString * const kUserIDFieldKey = @"userID";
NSString * const kDateFieldKey = @"date";
NSString * const kArchivedFieldKey = @"archived";
NSString * const kColorFieldKey = @"color";
NSString * const kNameFieldKey = @"name";
NSString * const kDescriptionFieldKey = @"description";

NSString * const ENABLED_BUTTON_COLOR = @"enabledbutton";
NSString * const DISABLED_BUTTON_COLOR = @"disabledbutton";

NSString * const NAV_BAR_COLOR = @"navbar";
NSString * const MENU_BACKGROUND_COLOR = @"menubackground";
NSString * const MENU_SELECTED_BACKGROUND_COLOR = @"menuselectedbackground";
NSString * const MONTH_BACKGROUND_COLOR = @"monthbackground";
NSString * const DAY_HIGHLIGHT_COLOR = @"dayhighlight";
NSString * const RECORD_COLOR_EMPTY_ENTRY = @"emptyentry";
NSString * const RECORD_COLOR_FEATURED_ENTRY = @"featured";
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

float const NAV_BAR_ICON_SIZE = 24.0;

// TODO: convert to singleton? http://www.galloway.me.uk/tutorials/singleton-classes/
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

+ (UIColor *)getPlaceholderRecordTypeColor {
    return [UIColor whiteColor];
}

+ (UIColor *)getNavigationBarColor {
    return [self getColor:NAV_BAR_COLOR];
}

+ (UIColor *)getMenuBackgroundColor {
    return [self getColor:MENU_BACKGROUND_COLOR];
}

+ (UIColor *)getMenuSelectedBackgroundColor {
    return [self getColor:MENU_SELECTED_BACKGROUND_COLOR];
}

+ (UIColor *)getMenuTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)getMonthBackgroundColor {
    return [self getColor:MONTH_BACKGROUND_COLOR];
}

+ (UIColor *)getDayHighlightColor {
    return [self getColor:DAY_HIGHLIGHT_COLOR];
}

// Hex colors from: http://www.w3schools.com/tags/ref_colorpicker.asp
+ (UIColor *)getColor:(NSString *)name {
    unsigned long int rgbValue = 0xBAE3FF;
    if ([name isEqualToString:ENABLED_BUTTON_COLOR]) {
        rgbValue = 0x82ABFF;
    } else if ([name isEqualToString:DISABLED_BUTTON_COLOR]) {
        rgbValue = 0x686868;
    } else if ([name isEqualToString:RECORD_COLOR_EMPTY_ENTRY]) {
        rgbValue = 0xE8E8E8;
    } else if ([name isEqualToString:RECORD_COLOR_FEATURED_ENTRY]) {
        rgbValue = 0x474747;
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
        rgbValue = 0xFF6F6F;
    } else if ([name isEqualToString:RECORD_COLOR_ORANGE]) {
        rgbValue = 0xFFAD85;
    } else if ([name isEqualToString:RECORD_COLOR_YELLOW]) {
        rgbValue = 0xFFE16C;
    } else if ([name isEqualToString:RECORD_COLOR_BROWN]) {
        rgbValue = 0xB5916C;
    } else if ([name isEqualToString:NAV_BAR_COLOR]) {
        rgbValue = 0x6C91FF;
    } else if ([name isEqualToString:MENU_BACKGROUND_COLOR]) {
        rgbValue = 0x4CB299;
    } else if ([name isEqualToString:MENU_SELECTED_BACKGROUND_COLOR]) {
        rgbValue = 0x7EC7B5;
    } else if ([name isEqualToString:MONTH_BACKGROUND_COLOR]) {
        rgbValue = 0xABABAB;
    }else if ([name isEqualToString:DAY_HIGHLIGHT_COLOR]) {
        rgbValue = 0x6C6C6C;
    }

    // From: http://www.appcoda.com/customize-navigation-status-bar-ios-7/
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (NSInteger)getCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [[formatter stringFromDate:[NSDate date]] integerValue];
}

+ (NSString *)getSaveFormattedString:(NSString *)inputStr {
    NSString *result = [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!result.length) {
        // Don't bother saving the empty string
        return nil;
    }
    return result;
}

+ (void)presentDeleteConfirmation:(NSString *)msg confirmationHandler:(void (^)(void))confirmationHandler {
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Confirm Delete"
                                        message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Yes, Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        confirmationHandler();
    }];
    UIAlertAction* escapeAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAction];
    [alert addAction:escapeAction];
    
    // NOTE: this seems like a huge hack. there must be a better way to present this
    // from a view...
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
