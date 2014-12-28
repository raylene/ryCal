//
//  RecordTypeViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordTypeViewController.h"
#import "RecordType.h"
#import "RecordTypeCell.h"

@interface RecordTypeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (nonatomic, strong) RecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;

@end

@implementation RecordTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [RecordType loadAllTypes:^(NSArray *types, NSError *error) {
        NSLog(@"Record types: %@", types);
        if (types.count == 0) {
            [RecordType createTestRecordTypes];
        }
        self.recordTypes = types;
        [self.typeTableView reloadData];
    }];
}

- (void)setupTypeTable {
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;
    // No footer
    self.typeTableView.tableFooterView = [[UIView alloc] init];
    
    UINib *cellNib = [UINib nibWithNibName:@"RecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"RecordTypeCell"];
    
    // Init menu item option configurations
//    self.menuItemConfig =
//    @[
//      @{@"name" : @"Profile", @"img":@"home"},
//      @{@"name" : @"Calendar", @"img": @"home"},
//      @{@"name" : @"Compose", @"img": @"home"},
//      ];
}


#pragma mark - Custom setters

- (RecordTypeCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"RecordTypeCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
    //self.prototypeCell.config = self.menuItemConfig[indexPath.row];
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTypeCell" forIndexPath:indexPath];
    cell.data = self.recordTypes[indexPath.row];
    //cell.config = self.menuItemConfig[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return self.recordTypes.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//    UIViewController *vc;
//    // TODO: add the rest of these
//    if (indexPath.row == kProfileItemIndex) {
//        NSLog(@"***creating profile view***");
//        vc = [[UserProfileViewController alloc] init];
//        //return;
//    } else if (indexPath.row == kCalendarItemIndex) {
//        return;
//    } else if (indexPath.row == kComposeItemIndex) {
//        vc = [[ComposeViewController alloc] init];
//    }
//    
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
//        NSLog(@"Menu presentVC completed");
//    }];


@end
