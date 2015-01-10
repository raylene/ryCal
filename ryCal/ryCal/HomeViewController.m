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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutFunTimes];
}

- (void)layoutFunTimes {
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
//        CGFloat fullHeight = screenSize.height;
    //    CGFloat fullWidth = screenSize.width;
    CGFloat fullHeight = CGRectGetHeight(self.view.bounds);
    CGFloat fullWidth = CGRectGetWidth(self.view.bounds);
    
    CGRect calendarFrame = [self createNewFrameBasedOnView:self.monthVC.view];
    calendarFrame.origin.y = (20 + self.navigationController.navigationBar.frame.size.height);
    CGFloat calendarHeight = [self.monthVC getEstimatedHeight];
    calendarFrame.size = CGSizeMake(fullWidth, calendarHeight);

//    CGFloat calendarHeight = [self.monthVC getEstimatedHeight];
//    CGRect calendarFrame = CGRectMake(0,
//                                      (20 + self.navigationController.navigationBar.frame.size.height),
//                                      fullWidth,
//                                      calendarHeight);
    self.monthVC.view.frame = calendarFrame;
//    [self.view addSubview:self.monthVC.view];
    
    CGFloat dayY = (calendarFrame.origin.y + CGRectGetHeight(calendarFrame));
    CGRect dayFrame = CGRectMake(0,
                                 dayY,
                                 fullWidth,
                                 fullHeight - dayY);
    self.dayEditVC.view.frame = dayFrame;
//    [self.view addSubview:self.dayEditVC.view];
}

- (void)setup {
    self.monthVC = [[MonthViewController alloc] initWithDate:self.referenceDate];
    [self.view addSubview:self.monthVC.view];

    self.dayEditVC = [[EditDailyRecordViewController alloc] initWithDate:self.referenceDate];
    [self.view addSubview:self.dayEditVC.view];
//    [self layoutFunTimes];
//    NSLog(@"Frame debugging... monthVC: %@, monthView: %@; dayVC: %@, dayView: %@",
//          NSStringFromCGRect(self.monthVC.view.frame),
//          NSStringFromCGRect(self.monthView.frame),
//          NSStringFromCGRect(self.dayEditVC.view.frame),
//          NSStringFromCGRect(self.dayEditView.frame)
//          );
    
    // Frame fun!
    // 1. Resize self.monthView so that it will fit the full calendar
    // 2. Reposition the calendar view so that it fits within self.monthView
    // 3. Resize self.dayEditView so that it fills the whole window, minus calendar
    // 4. Reposition/resize the edit panel so that it fills self.dayEditView
//    CGFloat fullHeight = self.monthView.frame.size.height + self.dayEditView.frame.size.height;
//    
//    // Use this for calendar sizing
//    CGRect calendarFrame = [self createNewFrameBasedOnView:self.monthVC.view];
//    // Reposition the origin to account for the nav bar
//    calendarFrame.origin.y += self.navigationController.navigationBar.frame.size.height;
//    self.monthView.frame = calendarFrame;
//    [self.monthView addSubview:self.monthVC.view];
//    
//    CGRect newDayFrame = self.dayEditView.frame;
//    newDayFrame.size.height = fullHeight - self.monthView.frame.size.height;
//    self.dayEditView.frame = newDayFrame;
//    self.dayEditVC.view.frame = [self createNewFrameBasedOnView:self.dayEditView];
//    
//    [self.dayEditView addSubview:self.dayEditVC.view];
    
    
//    NSLog(@"Frame debugging AFTER: monthVC: %@, monthView: %@; dayVC: %@, dayView: %@",
//          NSStringFromCGRect(self.monthVC.view.frame),
//          NSStringFromCGRect(self.monthView.frame),
//          NSStringFromCGRect(self.dayEditVC.view.frame),
//          NSStringFromCGRect(self.dayEditView.frame)
//          );
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDayView:) name:ViewFullDayNotification object:nil];
}

- (void)setupNavigationBar {
    self.title = [self.monthData getTitleString];
    
    // If we're already looking at this month, don't let us go into the future
    if (!self.monthData.isCurrentMonth) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStylePlain target:self action:@selector(onGoForwardInTime)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(onGoToToday)];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStylePlain target:self action:@selector(onGoBackInTime)];
}

#pragma mark Private helper methods

- (CGRect)createNewFrameBasedOnView:(UIView *)view {
    return CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

- (void)onGoBackInTime {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForPrevMonth]];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onGoForwardInTime {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForNextMonth]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onGoToToday {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[NSDate date]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentDayView:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    
    DayViewController *vc = [[DayViewController alloc] initWithDay:data];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
