//
//  User.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// extern -- allocated elsewhere
extern NSString * const UserDidLogoutNotification;
extern NSString * const UserDidLoginNotification;

@interface User : NSObject

@property (nonatomic, strong) PFUser *pfUser;

+ (User *)currentUser;

+ (void)logout;
+ (void)login;

- (NSString *)getUsername;
//- (PFUser *)getPFUser;
- (NSString *)getUserID;

@end
