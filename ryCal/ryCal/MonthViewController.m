//
//  MonthViewController.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MonthViewController.h"
#import "DayCell.h"
#import "User.h"
#import "RecordTypeViewController.h"
#import "RecordTypeComposerViewController.h"
#import "SharedConstants.h"

@interface MonthViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) Month *monthData;
@property (nonatomic, assign) NSInteger selectedDayIdx;

@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;
@end

@implementation MonthViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setupWithDate:[NSDate date]];
    }
    return self;
}

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self setupWithDate:date];
    }
    return self;
}

- (void)setupWithDate:(NSDate *)date {
    self.monthData = [[Month alloc] initWithNSDate:date];
    // TODO: fix weird month/day logic
    self.selectedDayIdx = [self.monthData getReferenceDayIdx];
    [self refreshMonthData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MonthViewC viewDidLoad: (%f, %f), (%f, %f)", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);

    [self setupCollectionView];
    self.title = [self.monthData getTitleString];
}

- (void)setupCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"DayCell" bundle:nil];
    [self.monthCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"DayCell"];
    
    self.monthCollectionView.delegate = self;
    self.monthCollectionView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonthData) name:MonthDataChangedNotification object:nil];
}

- (void)refreshMonthData {
    [self.monthData loadAllRecords:^(NSError *error) {
        if (error == nil) {
            [self.monthCollectionView reloadData];
        }
    }];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.monthData.numDays;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double width = collectionView.frame.size.width/8;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];

    int dayIdx = (int)indexPath.row;
    if (self.monthData.isCurrentMonth) {
        [cell setFeatured:(dayIdx == self.selectedDayIdx)];
    }
    [cell setData:[[Day alloc] initWithMonthAndDay:self.monthData dayIndex:dayIdx]];

    [cell setViewController:self.presentingVC];
//    [cell setViewController:self.presentingViewController];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
