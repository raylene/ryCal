//
//  DummyCell.m
//  ryCal
//
//  Created by Raylene Yung on 1/8/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "DummyCell.h"
#import "SharedConstants.h"

@interface DummyCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation DummyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

@end
