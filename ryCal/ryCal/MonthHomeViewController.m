//
//  MonthHomeViewController.m
//  ryCal
//
//  Created by Raylene Yung on 1/5/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "MonthHomeViewController.h"
//#import "MonthViewController.h"
#import "EditDailyRecordViewController.h"
#import "SharedConstants.h"
#import "DayViewController.h"
// Month view imports
#import "DayCell.h"
#import "DummyCell.h"
#import "User.h"

@interface MonthHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSDate *referenceDate;
@property (nonatomic, strong) Month *monthData;
@property (nonatomic, assign) NSInteger selectedDayIdx;

@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *dayEditView;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;

//@property (nonatomic, strong) MonthViewController *monthVC;
@property (nonatomic, strong) EditDailyRecordViewController *dayEditVC;

@end

@implementation MonthHomeViewController

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self setupDateInfo:date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupDateInfo:(NSDate *)date {
    self.referenceDate = date;
    self.monthData = [[Month alloc] initWithNSDate:date];
    
    // HACK: reset reference date to today to properly feature it if it's the current month
    if (self.monthData.isCurrentMonth) {
        self.referenceDate = [NSDate date];
    }
    
    self.selectedDayIdx = [self.monthData getReferenceDayIdx];
    [self refreshMonthData];
}

- (void)setup {
    CGSize calendarSize = [self.monthCollectionView.collectionViewLayout collectionViewContentSize];
    NSLog(@"calendar size %@", NSStringFromCGSize(calendarSize));
    
    self.dayEditVC = [[EditDailyRecordViewController alloc] initWithDate:self.referenceDate];
    self.dayEditVC.view.frame = [self createNewFrameBasedOnView:self.dayEditView];
    self.dayEditView.backgroundColor = [SharedConstants getMonthBackgroundColor];
    [self.dayEditView addSubview:self.dayEditVC.view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDayView:) name:ViewFullDayNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectedDay:) name:SwitchDayNotification object:nil];
}

- (void)setupNavigationBar {
    self.title = [self.monthData getTitleString];
    
    // If we're already looking at this month, don't let us go into the future
    if (!self.monthData.isCurrentMonth) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStylePlain target:self action:@selector(onGoForwardInTime)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStylePlain target:self action:@selector(onGoBackInTime)];
}


- (void)setupCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"DayCell" bundle:nil];
    [self.monthCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"DayCell"];
    
    UINib *dummyCellNib = [UINib nibWithNibName:@"DummyCell" bundle:nil];
    [self.monthCollectionView registerNib:dummyCellNib forCellWithReuseIdentifier:@"DummyCell"];
    
    self.monthCollectionView.delegate = self;
    self.monthCollectionView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonthData) name:MonthDataChangedNotification object:nil];
}

#pragma mark Private helper methods

- (CGRect)createNewFrameBasedOnView:(UIView *)view {
    return CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

// TODO: make static?
- (NSString *)getDayHeaderForIdx:(NSInteger)idx {
    return @[
        @"SU",
        @"M",
        @"TU",
        @"W",
        @"TH",
        @"F",
        @"SA"
    ][idx];
}

- (void)onGoBackInTime {
    MonthHomeViewController *vc = [[MonthHomeViewController alloc] initWithDate:[self.monthData getStartDateForPrevMonth]];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onGoForwardInTime {
    MonthHomeViewController *vc = [[MonthHomeViewController alloc] initWithDate:[self.monthData getStartDateForNextMonth]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentDayView:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    
    DayViewController *vc = [[DayViewController alloc] initWithDay:data];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


// TODO: see if Month should really be responsible for fetching all records
- (void)refreshMonthData {
    [self.monthData loadAllRecords:^(NSError *error) {
        if (error == nil) {
            [self.monthCollectionView reloadData];
            
            CGSize calendarSize = [self.monthCollectionView.collectionViewLayout collectionViewContentSize];
            NSLog(@"POST RELOAD: calendar size %@", NSStringFromCGSize(calendarSize));
        }
    }];
}

- (void)updateSelectedDay:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *dayData = dict[kDayNotifParam];
    self.selectedDayIdx = [dayData getDayInt] - 1;
    [self.monthCollectionView reloadData];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Total days including buffer: %ld", (self.monthData.numDays + self.monthData.numBufferDays));
    return (7 + self.monthData.numDays + self.monthData.numBufferDays);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double width = collectionView.frame.size.width/8;
    if (indexPath.row < 7) {
        return CGSizeMake(width, width/2);
    }
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NSInteger idx = indexPath.row;
    NSInteger totalBuffer = (self.monthData.numBufferDays + 7);
    if (idx < 7) {
        DummyCell *dummyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DummyCell" forIndexPath:indexPath];
        [dummyCell setText:[self getDayHeaderForIdx:idx]];
        cell = dummyCell;
    } else if (idx < totalBuffer) {
        DummyCell *dummyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DummyCell" forIndexPath:indexPath];
        cell = dummyCell;
    } else {
        DayCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
        NSInteger dayIdx = idx - totalBuffer;
        [dayCell setFeatured:(dayIdx == self.selectedDayIdx)];
        [dayCell setData:[[Day alloc] initWithMonthAndDay:self.monthData dayIndex:dayIdx]];
        cell = dayCell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [SharedConstants getDayHighlightColor];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

@end
