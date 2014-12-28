//
//  RecordTypeCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordTypeCell.h"
#import "RecordType.h"
#import "SharedConstants.h"
#import "RecordTypeComposerViewController.h"

@interface RecordTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *recordColorImage;
@property (weak, nonatomic) IBOutlet UILabel *recordTypeName;

- (IBAction)onEdit:(id)sender;

@end

@implementation RecordTypeCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize typeData = _typeData;
- (void) setTypeData:(RecordType *)typeData {
    _typeData = typeData;
    self.recordTypeName.text = typeData[kNameFieldKey];
    self.recordColorImage.backgroundColor = [SharedConstants getColor:typeData[kColorFieldKey]];
    
    if ([typeData[kArchivedFieldKey] boolValue]) {
        self.recordTypeName.textColor = [UIColor grayColor];
    }
}

- (IBAction)onEdit:(id)sender {
    RecordTypeComposerViewController *vc = [[RecordTypeComposerViewController alloc] initWithRecordType:self.typeData];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
