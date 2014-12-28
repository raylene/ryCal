//
//  RecordTypeCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/21/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordTypeCell.h"
#import "RecordType.h"

@interface RecordTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *recordColorImage;
@property (weak, nonatomic) IBOutlet UILabel *recordTypeName;

@end

@implementation RecordTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize data = _data;
- (void) setData:(RecordType *)data {
    _data = data;
//    self.recordColorImage.text = [self.data getMonthString];
    self.recordTypeName.text = [data objectForKey:@"name"];
//    
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
//    [self addGestureRecognizer:tgr];
}

//- (RecordType *)data {
//    return _data;
//}

@end
