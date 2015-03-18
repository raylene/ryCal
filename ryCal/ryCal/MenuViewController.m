//
//  MenuViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/30/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "User.h"
#import "HomeViewController.h"
#import "RecordTypeListViewController.h"
#import "UIImageView+AfNetworking.h"
#import "SharedConstants.h"
#import "HelpViewController.h"
// Facebook imports
#import "FBDialogs.h"
#import "FBWebDialogs.h"
#import "FBLinkShareParams.h"

static int const kHomeItemIndex = 0;
static int const kRecordTypesItemIndex = 1;
static int const kInviteItemIndex = 2;
static int const kHelpItemIndex = 3;
static int const kLogoutItemIndex = 4;

NSString * const kRecordItAppUrl = @"https://www.facebook.com/recorditapp/";

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SlidingMenuMainViewController *mainVC;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *menuItemConfig;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) MenuItemCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UIImageView *profilePlaceholderImageView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SharedConstants getMenuBackgroundColor];
    [self setupMenuTable];
    [self displayUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:UserDidLoginNotification object:nil];
}

#pragma mark - Custom setters

@synthesize mainVC = _mainVC;
- (void)setMainVC:(SlidingMenuMainViewController *)mainVC {
    _mainVC = mainVC;
}

- (MenuItemCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.menuTableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
        _prototypeCell.config = self.menuItemConfig[0];
    }
    return _prototypeCell;
}

# pragma mark Private helper methods

- (void)displayUserInfo {
    User *user = [User currentUser];
    self.nameLabel.text = [user getName];
    self.nameLabel.textColor = [SharedConstants getMenuTextColor];
    
    NSString *profileImageURL = [user getProfileImageURL];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:profileImageURL]];
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 2];
}

- (void)setupMenuTable {
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    // No footer
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    self.menuTableView.backgroundColor = [SharedConstants getMenuBackgroundColor];
    
    UINib *menuItemCellNib = [UINib nibWithNibName:@"MenuItemCell" bundle:nil];
    [self.menuTableView registerNib:menuItemCellNib forCellReuseIdentifier:@"MenuItemCell"];

    // Init menu item option configurations
    self.menuItemConfig =
    @[
      @{@"name" : @"Today", @"img":@"today"},
      @{@"name" : @"Activities", @"img": @"recordtypes"},
      @{@"name" : @"Invite Friends", @"img": @"invite"},
      @{@"name" : @"Help", @"img": @"help"},
      @{@"name" : @"Logout", @"img": @"logout"}
      ];
}

#pragma mark - SlidingMenuMainViewControllerDelegate methods

- (UIView *)getView {
    return self.view;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.config = self.menuItemConfig[indexPath.row];
    cell.backgroundColor = [SharedConstants getMenuBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItemConfig.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    if (indexPath.row == kHomeItemIndex) {
        vc = [[HomeViewController alloc] initWithDate:[NSDate date]];
    } else if (indexPath.row == kRecordTypesItemIndex) {
        vc = [[RecordTypeListViewController alloc] init];
    } else if (indexPath.row == kHelpItemIndex) {
        vc = [[HelpViewController alloc] init];
    } else if (indexPath.row == kInviteItemIndex) {
        [self presentFacebookShareDialog];
    } else if (indexPath.row == kLogoutItemIndex) {
        [User logout];
    }
    if (vc == nil) {
        return;
    }
    [self.mainVC displayContentVC:[[UINavigationController alloc] initWithRootViewController:vc]];
}

#pragma mark Facebook sharing integration helper methods

// Taken from: https://developers.facebook.com/docs/ios/share
- (NSDictionary*)fbParseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)presentFacebookShareDialog {
    NSLog(@"presentFacebookShareDialog");
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:kRecordItAppUrl];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if (error) {
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        NSLog(@"Cannot present share dialog, using a feed dialog");

        NSDictionary *params = @{
                                @"name" : @"Record It",
                                @"caption" : @"An easy-to-use wall calendar for your phone.",
                                @"description" : @"Join me in tracking and remembering what you've done this month -- Try it and let's make progress together!",
                                @"link" : kRecordItAppUrl,
                                @"picture" : @""
                                };
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self fbParseURLParams:[resultURL query]];
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

@end