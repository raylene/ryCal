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

static int const kHomeItemIndex = 0;
static int const kRecordTypesItemIndex = 1;
static int const kLogoutItemIndex = 2;
static int const kHelpItemIndex = 3;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SlidingMenuMainViewController *mainVC;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *menuItemConfig;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) MenuItemCell *prototypeCell;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SharedConstants getMenuBackgroundColor];
    [self setupMenuTable];
    [self displayUserInfo];
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
    self.nameLabel.text = [user getUsername];
    self.nameLabel.textColor = [SharedConstants getMenuTextColor];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[user getProfileImageURL]]];
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 3];
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
      @{@"name" : @"Logout", @"img": @"logout"},
      @{@"name" : @"Help", @"img": @"help"}
      ];
}

#pragma mark - SlidingMenuMainViewControllerDelegate methods

- (UIView *)getView {
    return self.view;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
        vc = [[RecordTypeListViewController alloc] init];
    } else if (indexPath.row == kLogoutItemIndex) {
        [User logout];
    }
    if (vc == nil) {
        return;
    }
    [self.mainVC displayContentVC:[[UINavigationController alloc] initWithRootViewController:vc]];
}

@end