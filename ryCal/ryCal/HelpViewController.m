//
//  HelpViewController.m
//  ryCal
//
//  Created by Raylene Yung on 2/28/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "HelpViewController.h"
#import "SharedConstants.h"
#import "SlidingMenuMainViewController.h"
#import "RecordQueryTracker.h"

@interface HelpViewController ()

- (IBAction)onClearCache:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *clearCacheButton;
@property (weak, nonatomic) IBOutlet UIView *clearCacheButtonBackground;
@property (weak, nonatomic) IBOutlet UIView *contactUsButtonBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *helpScrollView;

- (IBAction)onEmailUsButton:(id)sender;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    self.helpScrollView.contentSize = CGSizeMake(300, 1000);
    [self setupCacheButton];
    [self.contactUsButtonBackground setBackgroundColor:[SharedConstants getColor:ENABLED_BUTTON_COLOR]];
}

- (void)setupNavigationBar {
    self.title = @"Help";
    
    // TODO: share code with HomeViewController?
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu"]];
    menuImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [menuImageView addGestureRecognizer:tgr];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuImageView];
}

- (void)setupCacheButton {
    if ([[RecordQueryTracker sharedQueryTracker] hasCachedData]) {
        [self.clearCacheButton setEnabled:YES];
        [self.clearCacheButtonBackground setBackgroundColor:[SharedConstants getColor:ENABLED_BUTTON_COLOR]];
    } else {
        [self.clearCacheButton setEnabled:NO];
        [self.clearCacheButtonBackground setBackgroundColor:[SharedConstants getColor:DISABLED_BUTTON_COLOR]];
    }
}

- (void)toggleMenu {
    // TODO: see if it's weird to call this notif directly / import SlidingMenu
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuToggleStateNotification object:nil];
}

- (IBAction)onClearCache:(id)sender {
    [[RecordQueryTracker sharedQueryTracker] resetDatastore];
    [self setupCacheButton];
}

- (IBAction)onEmailUsButton:(id)sender {
    NSString *urlString = [@"mailto:recorditapp@gmail.com?subject=Help Me!" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    BOOL result = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    NSLog(@"opened email? %d", result);
}

@end
