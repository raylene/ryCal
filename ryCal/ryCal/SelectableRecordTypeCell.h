//
//  SelectableRecordTypeCell.h
//  ryCal
//
//  Created by Raylene Yung on 12/22/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordType.h"
#import "Record.h"

@interface SelectableRecordTypeCell : UITableViewCell

@property (nonatomic, strong) RecordType *typeData;
@property (nonatomic, strong) Record *recordData;

@property (nonatomic, strong) NSDate *date;

@end
