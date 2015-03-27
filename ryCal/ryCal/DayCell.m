//
//  DayCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/19/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "DayCell.h"
#import "Day.h"
#import "DayViewController.h"
#import "SharedConstants.h"
#import "Record.h"

@interface DayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *recordIndicatorView;

@end

@implementation DayCell

- (void)awakeFromNib {
    [self resetColors];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

- (void)resetColors {
    [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_EMPTY_ENTRY]];
    self.dayLabel.textColor = [UIColor darkGrayColor];
    self.recordIndicatorView.alpha = 0;
}

- (void)setFeatured:(BOOL)featured {
    if (featured) {
        [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_FEATURED_ENTRY]];
        self.dayLabel.textColor = [UIColor whiteColor];
    } else {
        [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_EMPTY_ENTRY]];
        self.dayLabel.textColor = [UIColor darkGrayColor];
    }
}

@synthesize data = _data;

- (void)setData:(Day *)data {
    _data = data;

    self.dayLabel.text = [self.data getDayString];
    self.recordIndicatorView.alpha = 0;
    Record *record = [self.data getPrimaryRecord];
    if (record != nil) {
        self.recordIndicatorView.backgroundColor = [record getColor];
        self.recordIndicatorView.alpha = 1;
    }
}

- (Day *)data {
    return _data;
}

#pragma mark UITableViewCell methods

- (void)prepareForReuse {
    self.featured = NO;
    self.contentView.backgroundColor = nil;
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SwitchDayNotification object:nil userInfo:@{kDayNotifParam: self.data}];
}

@end
