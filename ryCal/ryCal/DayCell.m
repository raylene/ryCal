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

@interface DayCell ()

// TODO -- delete
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation DayCell

- (void)awakeFromNib {
    [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_EMPTY_ENTRY]];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

@synthesize data = _data;

- (void) setData:(Day *)data {
    _data = data;
    self.monthLabel.text = [self.data getMonthString];
    self.dayLabel.text = [self.data getDayString];
}

- (Day *)data {
    return _data;
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    DayViewController *vc = [[DayViewController alloc] init];
    vc.dayData = self.data;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
