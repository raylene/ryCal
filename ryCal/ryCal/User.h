//
//  User.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (nonatomic, strong) PFUser *pfUser;

+ (User *)currentUser;

+ (void)logout;
+ (void)login;

- (NSString *)getUsername;
- (NSString *)getUserID;
- (NSString *)getProfileImageURL;

@end