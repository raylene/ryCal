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

NSString * const RECORD_COLOR_EMPTY_ENTRY = @"emptyentry";
NSString * const RECORD_COLOR_LIGHT_BLUE = @"lightblue";
NSString * const RECORD_COLOR_BLUE = @"blue";
NSString * const RECORD_COLOR_GREEN = @"green";
NSString * const RECORD_COLOR_PURPLE = @"purple";
NSString * const RECORD_COLOR_PINK = @"pink";
NSString * const RECORD_COLOR_YELLOW = @"yellow";

NSString * const TEST_TYPE_RUNNING = @"CIURHHmoNZ";
NSString * const TEST_TYPE_DANCING = @"8TXojnKMZC";
NSString * const TEST_TYPE_CLIMBING = @"V6UNX3Rq3m";

// Hex colors from: http://www.w3schools.com/tags/ref_colorpicker.asp
+ (UIColor *)getColor:(NSString *)name {
    unsigned long int rgbValue = 0xBAE3FF;
    if ([name isEqualToString:RECORD_COLOR_EMPTY_ENTRY]) {
        rgbValue = 0xE2E2FF;
    } else if ([name isEqualToString:RECORD_COLOR_LIGHT_BLUE]) {
        rgbValue = 0xE6F0FF;
    } else if ([name isEqualToString:RECORD_COLOR_BLUE]) {
        rgbValue = 0x99CCFF;
    } else if ([name isEqualToString:RECORD_COLOR_GREEN]) {
        rgbValue = 0x5CDE9D;
    } else if ([name isEqualToString:RECORD_COLOR_PURPLE]) {
        rgbValue = 0xD685FF;
    } else if ([name isEqualToString:RECORD_COLOR_PINK]) {
        rgbValue = 0xFF9BE6;
    } else if ([name isEqualToString:RECORD_COLOR_YELLOW]) {
        rgbValue = 0xFFFF66;
    }
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@end
