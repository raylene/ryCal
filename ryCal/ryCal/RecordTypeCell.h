//
//  RecordTypeCell.h
//  ryCal
//
//  Displays a summary view for a single record type
// 
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordType.h"

@interface RecordTypeCell : UITableViewCell

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) RecordType *typeData;

@end
