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

// TODO: look and see if it's weird for something to be its own delegate...
@interface MonthCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MonthCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup {
    NSLog(@"Setup MonthCollectionView!");
    UINib *cellNib = [UINib nibWithNibName:@"DayCell" bundle:nil];
    [self registerNib:cellNib forCellWithReuseIdentifier:@"DayCell"];
    
    self.monthData = [[Month alloc] initWithNSDate:[NSDate date]];
    
    self.delegate = self;
    self.dataSource = self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (int)getNumDays {
    NSLog(@"getNumDays: %d", self.monthData.numDays);
    return self.monthData.numDays;
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"getNumDays: %d", self.monthData.numDays);
    return self.monthData.numDays;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4; // This is the minimum inter item spacing, can be more
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double width = collectionView.frame.size.width/8;
    CGSize returnSize = CGSizeMake(width, width);
    return returnSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    Day *dayData = [[Day alloc] initWithMonthAndDay:self.monthData day:(int)indexPath.row];
    [cell setData:dayData];
    [cell setViewController:self.viewController];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
