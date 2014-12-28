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

// From: http://www.appcoda.com/customize-navigation-status-bar-ios-7/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

extern NSString * const RECORD_COLOR_EMPTY_ENTRY;
extern NSString * const RECORD_COLOR_LIGHT_BLUE;
extern NSString * const RECORD_COLOR_BLUE;
extern NSString * const RECORD_COLOR_GREEN;
extern NSString * const RECORD_COLOR_PURPLE;
extern NSString * const RECORD_COLOR_PINK;
extern NSString * const RECORD_COLOR_YELLOW;

extern NSString * const TEST_TYPE_RUNNING;
extern NSString * const TEST_TYPE_DANCING;
extern NSString * const TEST_TYPE_CLIMBING;

+ (UIColor *)getColor:(NSString *)name;

@end
