//
//  MonthViewController.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MonthViewController.h"
#import "DayCell.h"
#import "DummyCell.h"
#import "User.h"
#import "RecordTypeListViewController.h"
#import "RecordTypeComposerViewController.h"
#import "SharedConstants.h"

@interface MonthViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;

@property (nonatomic, strong) Month *monthData;
@property (nonatomic, assign) NSInteger selectedDayIdx;

@end

@implementation MonthViewController

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self setupWithDate:date];
    }
    return self;
}

- (void)setupWithDate:(NSDate *)date {
    // TODO: fix weird month/day logic
    self.monthData = [[Month alloc] initWithNSDate:date];
    self.selectedDayIdx = [self.monthData getReferenceDayIdx];
    self.title = [self.monthData getTitleString];
    [self refreshMonthData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectedDay:) name:SwitchDayNotification object:nil];
}

- (void)setupCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"DayCell" bundle:nil];
    [self.monthCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"DayCell"];

    UINib *dummyCellNib = [UINib nibWithNibName:@"DummyCell" bundle:nil];
    [self.monthCollectionView registerNib:dummyCellNib forCellWithReuseIdentifier:@"DummyCell"];

    self.monthCollectionView.delegate = self;
    self.monthCollectionView.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonthData) name:MonthDataChangedNotification object:nil];
    
    self.monthFrameWidth = self.monthCollectionView.frame.size.width;
}

// TODO: see if Month should really be responsible for fetching all records
- (void)refreshMonthData {
    [self.monthData loadAllRecords:^(NSError *error) {
        if (error == nil) {
            [self.monthCollectionView reloadData];
        }
    }];
}

- (void)updateSelectedDay:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *dayData = dict[kDayNotifParam];
    self.selectedDayIdx = [dayData getDayInt] - 1;
    [self.monthCollectionView reloadData];
}

- (CGFloat)getFrameWidth {
    return self.monthFrameWidth;
}

- (CGFloat)getCellWidth {
    return [self getFrameWidth]/8.0;
}

- (CGFloat)getCellSpacing {
    return floor(([self getCellWidth] / 6.0));
}

- (CGFloat)getEstimatedHeight {
    CGFloat cellWidth = [self getCellWidth];
    return cellWidth + ([self getNumRows] - 1) * (cellWidth + [self getCellSpacing]);
}

- (NSInteger)getNumRows {
    return ceil((float)[self getNumCells] / 7.0);
}

- (NSInteger)getNumCells {
    return (7 + self.monthData.numDays + self.monthData.numBufferDays);
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getNumCells];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self getCellSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self getCellSpacing];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self getCellWidth];
    if (indexPath.row < 7) {
        return CGSizeMake(width, width/4.0);
    }
    return CGSizeMake(width, width);
}

static NSString *daysOfWeek[] = { @"SU", @"M", @"TU", @"W", @"TH", @"F", @"SA" };

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NSInteger idx = indexPath.row;
    NSInteger totalBuffer = (self.monthData.numBufferDays + 7);
    if (idx < 7) {
        DummyCell *dummyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DummyCell" forIndexPath:indexPath];
        [dummyCell setText:daysOfWeek[idx]];
        cell = dummyCell;
    } else if (idx < totalBuffer) {
        DummyCell *dummyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DummyCell" forIndexPath:indexPath];
        [dummyCell setText:nil];
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
