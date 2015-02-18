//
//  User.m
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "User.h"
#import "Parse.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "SharedConstants.h"

@interface User ()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

NSString * const kCurrentUserKey = @"kCurrentUserKey";

static User *_currentUser;
+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        PFUser *curUser = [PFUser currentUser];
        if (data != nil && curUser != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionaryAndPFUser:dictionary pfUser:curUser];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = nil;
        if (currentUser.dictionary != nil) {
            data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        }
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

+ (void)login {
    NSLog(@"User - Login");

    // Facebook user permissions
    NSArray *fbPermissions = @[@"user_about_me"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *pfuser, NSError *error) {
        NSString *errorMessage = nil;
        if (error != nil) {
            errorMessage = [error localizedDescription];
        } else if (pfuser) {
            NSLog(@"Loaded user: %@", pfuser);

            if (pfuser.isNew) {
                NSLog(@"Created new user!");
                [pfuser saveInBackground];
            }
            
            [User setCurrentUser:[[User alloc] initWithPFUser:pfuser]];
            [User loadFacebookDataForCurrentUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
        }
        if (!pfuser && !error) {
            errorMessage = @"The user cancelled their Facebook login";
        }
        if (errorMessage) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }];
}

+ (void)loadFacebookDataForCurrentUser {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"FBRequest error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Loaded fb user data: %@", result);
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            User *user = [User currentUser];
            [user setDictionary:userData];
            [User setCurrentUser:user];
        }
    }];
}

#pragma mark Custom Init methods

- (id)initWithPFUser:(PFUser *)pfUser {
    self = [super init];
    if (self) {
        [self setPfUser:pfUser];
    }
    return self;
}

- (id)initWithDictionaryAndPFUser:(NSDictionary *)dictionary pfUser:(PFUser *)pfUser {
    self = [super init];
    if (self) {
        [self setDictionary:dictionary];
//        user.username = userData[@"name"];
//        NSString *facebookID = userData[@"id"];
//        NSString *profileImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
//        user[@"profileImageUrl"] = profileImageUrl;
        self.pfUser = pfUser;
    }
    return self;
}

- (NSString *)getUsername {
    return self.pfUser.username;
}

- (PFUser *)getPFUser {
    return self.pfUser;
}

- (NSString *)getUserID {
    return self.pfUser.objectId;
}

- (NSString *)getProfileImageURL {
    return self.pfUser[@"profileImageUrl"];
}

@end
