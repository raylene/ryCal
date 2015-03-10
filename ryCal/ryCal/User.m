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
    [PFUser logOut];
    [User setCurrentUser:nil];
    // TODO: figure out why logging out does not seem to reset the fb session info
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

+ (void)login {
    // Facebook user permissions
    // https://www.parse.com/tutorials/integrating-facebook-in-ios

    // Login PFUser using Facebook
    NSArray *fbPermissions = nil;//@[@"user_about_me"];
    [PFFacebookUtils logInWithPermissions:fbPermissions block:^(PFUser *pfuser, NSError *error) {
        NSString *errorMessage = nil;
        if (error != nil) {
            errorMessage = [error localizedDescription];
        } else if (pfuser) {
            NSLog(@"Loaded user: %@", pfuser);

            if (pfuser.isNew) {
                NSLog(@"Created new user!");
                [pfuser saveEventually];
            }
            
            [User setCurrentUser:[[User alloc] initWithPFUser:pfuser]];
            [User loadFacebookDataForCurrentUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
        }
        if (!pfuser && !error) {
            errorMessage = @"The user cancelled their Facebook login";
        }
        if (errorMessage) {
            [self showLoginErrorAlert:errorMessage];
        }
    }];
}

+ (void)showLoginErrorAlert:(NSString *)errorMessage {
    [[NSNotificationCenter defaultCenter] postNotificationName:UserFailedLoginNotification object:nil];
    NSString *displayedErrorMessage = [NSString stringWithFormat:@"There was an issue logging into your Facebook account. Error: %@", errorMessage];
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"Login Error"
                                        message:displayedErrorMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    
    // NOTE: this seems like a huge hack. there must be a better way to present this
    // from a view...
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)loadFacebookDataForCurrentUser {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"FBRequest error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Loaded fb user data: %@", result);
            NSDictionary *userData = (NSDictionary *)result;
            User *user = [User currentUser];
            [user setDictionary:userData];
            [User setCurrentUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
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
        self.pfUser = pfUser;
    }
    return self;
}

- (NSString *)getUsername {
    return self.pfUser.username;
}

- (NSString *)getName {
    NSString *name = [self.dictionary objectForKey:@"name"];
    if (name && name.length) {
        return name;
    }
    return self.pfUser.username;
}

- (PFUser *)getPFUser {
    return self.pfUser;
}

- (NSString *)getUserID {
    return self.pfUser.objectId;
}

- (NSString *)getProfileImageURL {
    NSString *fbID = self.dictionary[@"id"];
    if (fbID) {
        return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", self.dictionary[@"id"]];
    }
    return nil;
}

@end
