//
//  LoginViewController.m
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful) name:UserDidLoginNotification object:nil];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
}

- (void)onLogout {
    [User logout];
}

- (IBAction)onLogin:(id)sender {
    NSLog(@"onLogin");
    [SVProgressHUD showWithStatus:@"Logging in..." maskType:SVProgressHUDMaskTypeGradient];
    [User login];
}

- (void)loginSuccessful {
    NSLog(@"loginSuccessful!");
    [SVProgressHUD dismiss];
    
    MainViewController *mvc = [[MainViewController alloc] init];
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
