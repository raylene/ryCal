//
//  RecordTypeListViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordTypeListViewController.h"
#import "RecordType.h"
#import "RecordTypeCell.h"
#import "RecordTypeComposerViewController.h"
#import "SharedConstants.h"
#import "SlidingMenuMainViewController.h"

@interface RecordTypeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UIView *nuxView;
@property (nonatomic, strong) RecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation RecordTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupNavigationBar];
    [self setupNuxExperience];
    [self setupRefreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTypeData) name:RecordTypeDataChangedNotification object:nil];
    
    [self refreshTypeData];
}

- (void)refreshTypeData {
    [RecordType loadAllTypes:^(NSArray *types, NSError *error) {
//        self.recordTypes = types;
        [self setupNuxExperience];
        [self.typeTableView reloadData];
    }];
}

- (void)setupTypeTable {
    UINib *cellNib = [UINib nibWithNibName:@"RecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"RecordTypeCell"];
    
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;
    self.typeTableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupNuxExperience {
    BOOL hasRecordTypes = self.recordTypes && self.recordTypes.count;
    self.nuxView.hidden = hasRecordTypes;
    self.typeTableView.hidden = !hasRecordTypes;
}

- (void)setupNavigationBar {
    self.title = @"Activities";
    
    // TODO: share code with HomeViewController?
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu"]];
    menuImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [menuImageView addGestureRecognizer:tgr];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuImageView];

    UIImageView *newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus"]];
    newImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *newTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCreateNewType)];
    [newImageView addGestureRecognizer:newTgr];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newImageView];
    
    // TODO: see if there is a better way to do this?
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Records" style:UIBarButtonItemStylePlain target:self action:nil];    
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.typeTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)onCreateNewType {
    RecordTypeComposerViewController *vc = [[RecordTypeComposerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toggleMenu {
    // TODO: see if it's weird to call this notif directly / import SlidingMenu
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuToggleStateNotification object:nil];
}

-(void)pullToRefresh {
    NSLog(@"Pulled!");
    [RecordType forceReloadAllTypes:^(NSArray *types, NSError *error) {
        if (!error) {
            self.recordTypes = types;
            [self.typeTableView reloadData];
        } else {
          // TODO: present "error fetching data" dialog?
        }
        [self.refreshControl endRefreshing];
    }];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTypeCell" forIndexPath:indexPath];
    cell.viewController = self;
    cell.typeData = self.recordTypes[indexPath.row];
//    NSLog(@"Displaying record type cell: %@, %@", cell.typeData.name, cell.typeData.color);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

@end