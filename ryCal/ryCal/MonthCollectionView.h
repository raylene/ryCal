//
//  MonthCollectionView.h
//  ryCal
//
//  Created by Raylene Yung on 12/16/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Month.h"

@interface MonthCollectionView : UICollectionView

@property (nonatomic, strong) Month *monthData;
@property (nonatomic, strong) UIViewController *viewController;

- (void)setDate:(NSDate *)date;
- (int)getNumDays;

@end
