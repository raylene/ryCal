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
@property (nonatomic, strong) RecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;

@end

@implementation RecordTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTypeData) name:RecordTypeDataChangedNotification object:nil];
    
    [self refreshTypeData];
}

- (void)refreshTypeData {
    [RecordType loadAllTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
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

- (void)setupNavigationBar {
    self.title = @"Record Types";
    // TODO: possibly customize add button style?
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateNewType)];
    self.navigationItem.rightBarButtonItem = addButton;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];

    // TODO: see if there is a better way to do this?
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All Records" style:UIBarButtonItemStylePlain target:self action:nil];    
}

- (void)onCreateNewType {
    RecordTypeComposerViewController *vc = [[RecordTypeComposerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toggleMenu {
    // TODO: see if it's weird to call this notif directly / import SlidingMenu
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuToggleStateNotification object:nil];
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
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

@end