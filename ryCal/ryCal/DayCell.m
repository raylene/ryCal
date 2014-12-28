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

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation DayCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[SharedConstants getColor:RECORD_COLOR_EMPTY_ENTRY]];
}

@synthesize data = _data;

- (void) setData:(Day *)data {
    _data = data;
    self.monthLabel.text = [self.data getMonthString];
    self.dayLabel.text = [self.data getDayString];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

- (Day *)data {
    return _data;
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    CGPoint location = [sender locationInView: self];
    NSLog(@"Tapped cell: %f, %f, %@, %@", location.x, location.y, [self.data getMonthString],
              [self.data getDayString]);
    DayViewController *vc = [[DayViewController alloc] init];
//    vc.backgroundColor = self.color;
//    vc.textColor = self.bestieTextLabel.textColor;
//    vc.modalPresentationStyle = UIModalPresentationCustom;
//    vc.transitioningDelegate = self.parentVC;
    vc.dayData = self.data;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
