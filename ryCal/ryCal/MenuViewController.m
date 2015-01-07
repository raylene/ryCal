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
#import "MonthViewController.h"
#import "HomeViewController.h"
#import "RecordTypeViewController.h"
#import "UIImageView+AfNetworking.h"
#import "SharedConstants.h"

static int const kProfileItemIndex = 2;
static int const kHomeItemIndex = 0;
static int const kRecordTypesItemIndex = 1;
static int const kLogoutItemIndex = 3;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SlidingMenuMainViewController *mainVC;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

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
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 0.5];
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
      @{@"name" : @"Home", @"img":@"home"},
      @{@"name" : @"Record Types", @"img": @"recordtypes"},
      @{@"name" : @"Settings", @"img": @"profile"},
      @{@"name" : @"Logout", @"img": @"logout"}
      ];
}

#pragma mark - SlidingMenuMainViewControllerDelegate methods

- (UIView *)getView {
    return self.view;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"menu size: %ld, %f", indexPath.row, size.height + 1);

    return 60;
//    return size.height + 1;
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
    if (indexPath.row == kProfileItemIndex) {
//        vc = [[ProfileViewController alloc] init];
//        [(ProfileViewController *)vc setUser:[User currentUser]];
    } else if (indexPath.row == kHomeItemIndex) {
//        vc = [[MonthViewController alloc] init];
        vc = [[HomeViewController alloc] initWithDate:[NSDate date]];
    } else if (indexPath.row == kRecordTypesItemIndex) {
        vc = [[RecordTypeViewController alloc] init];
    } else if (indexPath.row == kLogoutItemIndex) {
        [User logout];
    }
    if (vc == nil) {
        return;
    }
    [self.mainVC displayContentVC:[[UINavigationController alloc] initWithRootViewController:vc]];
}

@end
