//
//  DayCell.h
//  ryCal
//
//  Displays a single day's summary within the month calendar view
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "Record.h"

@interface DayCell : UICollectionViewCell

@property (nonatomic, strong) Day *data;
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, strong) Record *primaryRecord;

@property (nonatomic, assign) BOOL featured;

@end
