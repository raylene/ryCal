//
//  DayViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "DayViewController.h"
#import "User.h"
#import "EditableRecordTypeCell.h"
#import "RecordType.h"
#import "Record.h"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EditableRecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSDictionary *recordDictionary;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@end

@implementation DayViewController

- (id)initWithDay:(Day *)dayData {
    self = [super init];
    if (self) {
        [self setDayData:dayData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupNavigationBar];
    self.recordDictionary = [[NSMutableDictionary alloc] init];

    self.title = [self.dayData getTitleString];
    
    // TODO: potentially share code with similar record fetching in Month.m
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
        [Record loadRecordDictionaryForTimeRange:[self.dayData getStartDate] endDate:[self.dayData getEndDate] cacheKey:[self.dayData getDayCacheKey] completion:^(NSDictionary *recordDict, NSError *error) {
            self.recordDictionary = recordDict;
            [self.typeTableView reloadData];
        }];
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDismiss)];
}

- (void)onDismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTypeTable {
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;

    UINib *cellNib = [UINib nibWithNibName:@"EditableRecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"EditableRecordTypeCell"];
}

#pragma mark - Custom setters

- (EditableRecordTypeCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableRecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell" forIndexPath:indexPath];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    cell.monthCacheKey = [self.dayData getMonthCacheKey];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

@end
