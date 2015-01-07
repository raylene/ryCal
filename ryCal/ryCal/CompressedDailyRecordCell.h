//
//  CompressedDailyRecordCell.h
//  ryCal
//
//  Created by Raylene Yung on 1/7/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordType.h"
#import "Record.h"

@interface CompressedDailyRecordCell : UITableViewCell

// TODO: change this to be an initWithRecordData?
@property (nonatomic, strong) RecordType *typeData;
@property (nonatomic, strong) Record *recordData;

@property (nonatomic, strong) NSDate *date;

// TODO: read up on obj-c class inheritance a bit more to see if this can be private
- (void)saveChanges:(BOOL)deleteRecord;

@end
