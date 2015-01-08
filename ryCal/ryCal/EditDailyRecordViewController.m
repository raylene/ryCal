//
//  EditDailyRecordViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "EditDailyRecordViewController.h"
#import "User.h"
//#import "EditableRecordTypeCell.h"
#import "CompressedDailyRecordCell.h"
#import "DayViewController.h"
#import "RecordType.h"
#import "Record.h"
#import "SharedConstants.h"

@interface EditDailyRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CompressedDailyRecordCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;
- (IBAction)addMoreInfo:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UILabel *dateHeaderLabel;

@end

@implementation EditDailyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDateHeader];
    [self setupTypeTable];
    [self setupRecordData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRecordData) name:MonthDataChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUsingNewDay:) name:ViewDayNotification object:nil];
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

@synthesize dayData = _dayData;
- (void)setDayData:(Day *)dayData {
    _dayData = dayData;
    [self setupDateHeader];
}

// TODO: look into viewDidLoad in the lifecycle and see why I need to call this 2x
// it needs to be in viewDidLoad for a new VC via alloc, and needs to be setDayData for
// the same VC that's just having it's data be refreshed
- (void)setupDateHeader {
    NSString *header = @"TODAY";
    if (!self.dayData.isToday) {
        header = [self.dayData getTitleString];
    }
    self.dateHeaderLabel.text = header;
}

- (void)setupTypeTable {
    UINib *cellNib = [UINib nibWithNibName:@"CompressedDailyRecordCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"CompressedDailyRecordCell"];
    
    self.typeTableView.backgroundColor = [SharedConstants getMonthBackgroundColor];
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

- (void)updateUsingNewDay:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    [self setDayData:data];
    [self setupRecordData];
}

#pragma mark - Custom setters

- (CompressedDailyRecordCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"CompressedDailyRecordCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompressedDailyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompressedDailyRecordCell" forIndexPath:indexPath];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return MAX(self.recordTypes.count, 3);
    return self.recordTypes.count;
}

// ---------------

- (IBAction)addMoreInfo:(id)sender {
    // TODO: figure out another way to display the day permalink...?
//    [[NSNotificationCenter defaultCenter] postNotificationName:ViewDayNotification object:nil userInfo:@{kDayNotifParam: self.dayData}];
    
    DayViewController *vc = [[DayViewController alloc] init];
    vc.dayData = self.dayData;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.presentingVC presentViewController:nvc animated:YES completion:nil];
}

@end
