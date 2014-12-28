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
#import "RecordTypeComposerViewController.h"

@interface RecordTypeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (nonatomic, strong) RecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;

@end

@implementation RecordTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupNavigationBar];
    
    [RecordType loadAllTypes:^(NSArray *types, NSError *error) {
        if (types.count == 0) {
            // NOTE: only for testing
            [RecordType createTestRecordTypes];
        }
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
    // No footer
    self.typeTableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add New Type" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateNewType)];
}

- (void)onCreateNewType {
    RecordTypeComposerViewController *vc = [[RecordTypeComposerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
