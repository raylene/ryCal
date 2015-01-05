//
//  MonthCollectionView.m
//  ryCal
//
//  Created by Raylene Yung on 12/16/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MonthCollectionView.h"
#import "DayCell.h"
#import "Month.h"
#import "SharedConstants.h"

// TODO: look and see if it's weird for something to be its own delegate...
// maybe create a wrapper class for this or merge back into the VC if I don't actually need
// multiple MonthCollectionViews anywhere
@interface MonthCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MonthCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithDate:[NSDate date]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithDate:[NSDate date]];
    }
    return self;
}

- (void)setupWithDate:(NSDate *)date {
    UINib *cellNib = [UINib nibWithNibName:@"DayCell" bundle:nil];
    [self registerNib:cellNib forCellWithReuseIdentifier:@"DayCell"];
    
    self.delegate = self;
    self.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonthData) name:MonthDataChangedNotification object:nil];
}

- (void)refreshMonthData {
    [self reloadData];
}

- (void)setDate:(NSDate *)date {
    self.monthData = [[Month alloc] initWithNSDate:date];
    [self.monthData loadAllRecords:^(NSError *error) {
        if (error == nil) {
            [self refreshMonthData];
        }
    }];
}

- (int)getNumDays {
    return self.monthData.numDays;
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
    [cell setData:[[Day alloc] initWithMonthAndDay:self.monthData dayIndex:dayIdx]];
    [cell setViewController:self.viewController];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
