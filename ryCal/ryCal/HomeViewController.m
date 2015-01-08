//
//  HomeViewController.m
//  ryCal
//
//  Created by Raylene Yung on 1/5/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "HomeViewController.h"
#import "MonthViewController.h"
#import "EditDailyRecordViewController.h"
#import "SharedConstants.h"
#import "DayViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSDate *referenceDate;
@property (nonatomic, strong) Month *monthData;

@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *dayEditView;

@property (nonatomic, strong) MonthViewController *monthVC;
@property (nonatomic, strong) EditDailyRecordViewController *dayEditVC;

@end

@implementation HomeViewController

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.referenceDate = date;
        self.monthData = [[Month alloc] initWithNSDate:date];
        // HACK: reset reference date to today to properly feature it if it's the current month
        if (self.monthData.isCurrentMonth) {
            self.referenceDate = [NSDate date];
        }
    }
    return self;
}

- (void)setup {
    self.monthVC = [[MonthViewController alloc] initWithDate:self.referenceDate];
    self.monthVC.presentingVC = self.navigationController;

//    // Option 1
    CGRect newMonthFrame = self.monthView.frame;
    newMonthFrame.origin.y += self.navigationController.navigationBar.frame.size.height;
    self.monthVC.view.frame = newMonthFrame;
//    // Option 2
//    // self.monthVC.view.frame = self.monthView.frame;

    [self.monthView addSubview:self.monthVC.view];

    self.dayEditView.backgroundColor = [SharedConstants getMonthBackgroundColor];
    
//    if (self.monthData.isCurrentMonth) {
        self.dayEditVC = [[EditDailyRecordViewController alloc] initWithDate:self.referenceDate];
        // TODO: delete the presentingVC var, no longer needed
        self.dayEditVC.presentingVC = self.navigationController;
        self.dayEditVC.view.frame = CGRectMake(0, 0, self.dayEditView.frame.size.width, self.dayEditView.frame.size.height);
        [self.dayEditView addSubview:self.dayEditVC.view];
//    }
    
    // TODO: put this back if the dynamic swapping of the bottom in EditDailyRecordVC doesn't work out...
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDayView:) name:ViewDayNotification object:nil];
    
    // Not needed?
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUsingNewDay:) name:ViewDayNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = [self.monthData getTitleString];
    
    // If we're already looking at this month, don't let us go into the future
    if (!self.monthData.isCurrentMonth) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStylePlain target:self action:@selector(onGoForwardInTime)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStylePlain target:self action:@selector(onGoBackInTime)];
}

- (void)onGoBackInTime {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForPrevMonth]];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onGoForwardInTime {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForNextMonth]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentDayView:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    
    DayViewController *vc = [[DayViewController alloc] init];
    vc.dayData = data;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
//    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)updateUsingNewDay:(NSNotification *)notification {
//    NSDictionary *dict = [notification userInfo];
//    Day *data = dict[kDayNotifParam];
//}

@end
