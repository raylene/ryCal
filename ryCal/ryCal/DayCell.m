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
    
    // Selected state color
//    UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
//    selectedBGView.backgroundColor = [UIColor whiteColor];
//    self.selectedBackgroundView = selectedBGView;
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
//    [self resetColors];
//
//    if (self.featured) {
//        [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_FEATURED_ENTRY]];
//        self.dayLabel.textColor = [UIColor whiteColor];
//    }    

    self.dayLabel.text = [self.data getDayString];
    self.recordIndicatorView.alpha = 0;
    Record *record = [self.data getPrimaryRecord];
    if (record != nil) {
//        NSLog(@"day primary record? %@, %@, %@", [self.data getDayString], [self.data getTitleString], [self.data getPrimaryRecord]);
        self.recordIndicatorView.backgroundColor = [record getColor];
        self.recordIndicatorView.alpha = 1;
    }
}

- (Day *)data {
    return _data;
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SwitchDayNotification object:nil userInfo:@{kDayNotifParam: self.data}];
    
    // TODO: fix this so that you can show cells that have been tapped/featured
    // self.featured = YES;
    
//    DayViewController *vc = [[DayViewController alloc] init];
//    vc.dayData = self.data;
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.viewController presentViewController:nvc animated:YES completion:nil];
//    // NOTE: I changed self.viewController to already be a nav controller...
//    // [(UINavigationController *)self.viewController pushViewController:vc animated:YES];
}

@end
