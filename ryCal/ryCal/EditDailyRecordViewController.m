//
//  EditDailyRecordViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "EditDailyRecordViewController.h"
#import "User.h"
#import "CompressedDailyRecordCell.h"
#import "DayViewController.h"
#import "RecordType.h"
#import "Record.h"
#import "SharedConstants.h"

@interface EditDailyRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UILabel *dateHeaderLabel;
@property (weak, nonatomic) IBOutlet UIView *howToView;
@property (weak, nonatomic) IBOutlet UIButton *addNotesButton;

@property (nonatomic, strong) CompressedDailyRecordCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSDictionary *recordDictionary;

- (IBAction)addMoreInfo:(id)sender;

@end

@implementation EditDailyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SharedConstants getMonthBackgroundColor];
    [self setupTypeTable];
    // TODO: read up on VC lifecycle more to get why this wasn't working before
    [self setupDateHeader];

    // Start by blanking everything out
    self.howToView.hidden = YES;
    self.typeTableView.hidden = YES;
    self.addNotesButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUsingNewDay:) name:SwitchDayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDayDataChanged) name:DayDataChangedNotification object:nil];
}

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        Month *month = [[Month alloc] initWithNSDate:date];
        Day *dayData = [[Day alloc] initWithMonthAndDate:month date:date];
        [self setDayData:dayData];
        [self loadRecordData];
    }
    return self;
}

@synthesize dayData = _dayData;
- (void)setDayData:(Day *)dayData {
    _dayData = dayData;
    [self setupDateHeader];
}

- (void)setupDateHeader {
    NSString *header = @"TODAY";
    if (!self.dayData.isToday) {
        header = [self.dayData getHeaderString];
    }
    self.dateHeaderLabel.text = header;
}

- (void)setupNuxExperience {
    BOOL hasRecordTypes = self.recordTypes && self.recordTypes.count;
    self.howToView.hidden = hasRecordTypes;
    self.typeTableView.hidden = !hasRecordTypes;
    self.addNotesButton.hidden = !hasRecordTypes;
}

- (void)setupTypeTable {
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.backgroundColor = [SharedConstants getMonthBackgroundColor];
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;

    UINib *cellNib = [UINib nibWithNibName:@"CompressedDailyRecordCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"CompressedDailyRecordCell"];
}

- (void)loadRecordData {
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
        [self setupNuxExperience];
        [Record loadRecordDictionaryForTimeRange:[self.dayData getStartDate] endDate:[self.dayData getEndDate] cacheKey:[self.dayData getDayCacheKey] completion:^(NSDictionary *recordDict, NSError *error) {
            self.recordDictionary = recordDict;
            
            [self.typeTableView reloadData];
        }];
    }];
}

- (void)updateUsingNewDay:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    [self setDayData:data];
    [self loadRecordData];
}

- (void)updateDayDataChanged {
    [self loadRecordData];
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
    cell.date = [self.dayData getStartDate];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    cell.monthCacheKey = [self.dayData getMonthCacheKey];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

#pragma mark Add More action

- (IBAction)addMoreInfo:(id)sender {
    // TODO: figure out if there's a better way to display the day permalink...
    [[NSNotificationCenter defaultCenter] postNotificationName:ViewFullDayNotification object:nil userInfo:@{kDayNotifParam: self.dayData}];
}

@end
