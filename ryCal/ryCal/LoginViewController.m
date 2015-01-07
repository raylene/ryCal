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
#import "SharedConstants.h"
#import "RyCalMainViewController.h"

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
    RyCalMainViewController *vc = [[RyCalMainViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
