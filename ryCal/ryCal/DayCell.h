//
//  DayCell.h
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface DayCell : UICollectionViewCell

@property (nonatomic, strong) Day *data;
@property (nonatomic, strong) UIViewController *viewController;

@end
