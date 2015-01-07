//
//  EditDailyRecordViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "EditDailyRecordViewController.h"
#import "User.h"
#import "EditableRecordTypeCell.h"
#import "RecordType.h"
#import "Record.h"
#import "SharedConstants.h"

@interface EditDailyRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EditableRecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;
- (IBAction)addMoreInfo:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@end

@implementation EditDailyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupRecordData];
}

- (id)initWithDay:(Day *)dayData {
    self = [super init];
    if (self) {
        [self setDayData:dayData];
    }
    return self;
}

- (id)initWithMonthAndDate:(Month *)monthData date:(NSDate *)date {
    self = [super init];
    if (self) {
        Day *dayData = [[Day alloc] initWithMonthAndDay:monthData dayIndex:1];
        [self setDayData:dayData];
    }
    return self;
}

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        Month *month = [[Month alloc] initWithNSDate:date];
        Day *dayData = [[Day alloc] initWithMonthAndDate:month date:date];
        [self setDayData:dayData];
    }
    return self;
}

- (void)setupTypeTable {
    UINib *cellNib = [UINib nibWithNibName:@"EditableRecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"EditableRecordTypeCell"];
    
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupRecordData {
    self.recordDictionary = [[NSMutableDictionary alloc] init];
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
        [Record loadAllRecordsForTimeRange:[self.dayData getStartDate] endDate:[self.dayData getEndDate] completion:^(NSArray *records, NSError *error) {
            for (Record *record in records) {
                NSString *recordTypeID = record[kTypeIDFieldKey];
                [self.recordDictionary setObject:record forKey:recordTypeID];
            }
            [self.typeTableView reloadData];
        }];
    }];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableRecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell" forIndexPath:indexPath];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
//    return self.recordTypes.count;
}

- (IBAction)addMoreInfo:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ViewDayNotification object:nil userInfo:@{kDayNotifParam: self.dayData}];
}

@end
