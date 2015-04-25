//
//  EditableRecordTypeCell.h
//  ryCal
//
//  Displays a fully featured editable record entry for a given day
//
//  Created by Raylene Yung on 12/22/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompressedDailyRecordCell.h"

@interface EditableRecordTypeCell : CompressedDailyRecordCell

// TODO: see if better way to get indexPath from UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
