//
//  ColorCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/27/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "ColorCell.h"
#import "SharedConstants.h"

@interface ColorCell ()

@property (weak, nonatomic) IBOutlet UIView *selectedStateView;

@end

@implementation ColorCell

- (void)awakeFromNib {
    self.selectedStateView.hidden = YES;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSwitched:) name:ColorSelectedNotification object:nil];
}

@synthesize colorName = _colorName;
- (void)setColorName:(NSString *)colorName {
    _colorName = colorName;
    self.backgroundColor = [SharedConstants getColor:colorName];
}

- (void)setSelectedColor:(NSString *)selectedColor {
    self.selectedStateView.hidden = ![self.colorName isEqualToString:selectedColor];
}

- (void)colorSwitched:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    self.selectedStateView.hidden = ![self.colorName isEqualToString:dict[kColorSelectedNotifParam]];
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    self.selectedStateView.hidden = !(self.selectedStateView.hidden);
    [[NSNotificationCenter defaultCenter] postNotificationName:ColorSelectedNotification object:nil userInfo:@{kColorSelectedNotifParam: self.colorName, kRecordTypeIDNotifParam: self.recordTypeID}];
}

@end