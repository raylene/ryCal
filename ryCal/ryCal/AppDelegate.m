//
//  AppDelegate.m
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "LoginViewController.h"
#import "RyCalMainViewController.h"
#import "SharedConstants.h"
// PFObject subclasses
#import "Record.h"
#import "RecordType.h"

#define TEST_PUSH_NOTIFS 0

static const NSString *kParseAppID = @"MXbaau75VqOWXVcGqw5WM3KOsY12MPkRlLj5J7th";
static const NSString *kParseClientKey = @"2vJqfG8gMODsZWgSGosJSsabTmhVJmTNdLLNFZFr";
static const NSString *kFacebookAppID = @"745968008790705";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Parse setup
    
#if TEST_PUSH_NOTIFS
    // Push notifications: https://parse.com/tutorials/ios-push-notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
#endif
    
    // PFObject subclasses
    // https://parse.com/docs/ios/api/Protocols/PFSubclassing.html#//api/name/registerSubclass
    [Record registerSubclass];
    [RecordType registerSubclass];

    // https://www.parse.com/docs/ios_guide#objects-pinning/iOS
    [Parse enableLocalDatastore];

    [Parse setApplicationId:(NSString *)kParseAppID clientKey:(NSString *)kParseClientKey];
    [PFFacebookUtils initializeFacebook];
    
    // Notification subscriptions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];

    // Navigation appearance for the whole app
    [[UINavigationBar appearance] setBarTintColor:[SharedConstants getNavigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    User *user = [User currentUser];
    UIViewController *vc = nil;
    if (user == nil) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        vc = [[UINavigationController alloc] initWithRootViewController:lvc];
    } else {
        vc = [[RyCalMainViewController alloc] init];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)userDidLogout {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.rootViewController = navigationController;
}

// https://developers.facebook.com/docs/ios/share
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session] fallbackHandler:^(FBAppCall *call) {
        NSLog(@"Unhandled deep link: %@", url);
        // Here goes the code to handle the links
        // Use the links to show a relevant view of your app to the user
    }];
}

#if TEST_PUSH_NOTIFS
// https://parse.com/tutorials/ios-push-notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

// https://parse.com/tutorials/ios-push-notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
#endif

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
#if TEST_PUSH_NOTIFS
    // Clear app badge number
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
