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
#import "SlidingMenuMainViewController.h"

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
    CGFloat fullHeight = CGRectGetHeight(self.view.bounds);
    CGFloat fullWidth = CGRectGetWidth(self.view.bounds);

    // Month calendar sizing...
    CGRect calendarFrame = [self createNewFrameBasedOnView:self.monthVC.view];
    calendarFrame.origin.y = (20 + self.navigationController.navigationBar.frame.size.height);
    CGFloat calendarHeight = [self.monthVC getEstimatedHeight];
    calendarFrame.size = CGSizeMake(fullWidth, calendarHeight);

    self.monthVC.view.frame = calendarFrame;
    
    // Day summary sizing...
    CGFloat dayY = (calendarFrame.origin.y + CGRectGetHeight(calendarFrame));
    CGRect dayFrame = CGRectMake(0,
                                 dayY,
                                 fullWidth,
                                 fullHeight - dayY);
    self.dayEditVC.view.frame = dayFrame;
}

- (void)setup {
    self.monthVC = [[MonthViewController alloc] initWithDate:self.referenceDate];
    [self.view addSubview:self.monthVC.view];

    self.dayEditVC = [[EditDailyRecordViewController alloc] initWithDate:self.referenceDate];
    [self.view addSubview:self.dayEditVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDayView:) name:ViewFullDayNotification object:nil];
    
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onGoForwardInTime)];
    [leftSwipeGR setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.monthVC.view addGestureRecognizer:leftSwipeGR];
    
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onGoBackInTime)];
    [rightSwipeGR setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.monthVC.view addGestureRecognizer:rightSwipeGR];
}

- (void)setupNavigationBar {
    self.title = [self.monthData getTitleString];
    
    // If we're already looking at this month, don't let us go into the future
//    if (!self.monthData.isCurrentMonth) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStylePlain target:self action:@selector(onGoForwardInTime)];
//    }
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStylePlain target:self action:@selector(onGoBackInTime)];
    
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu"]];
    menuImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [menuImageView addGestureRecognizer:tgr];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuImageView];

    UIImageView *pastImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftarrow"]];
    pastImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *pastTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGoBackInTime)];
    [pastImageView addGestureRecognizer:pastTgr];
    UIBarButtonItem *pastButton = [[UIBarButtonItem alloc] initWithCustomView:pastImageView];
    
    //self.navigationItem.leftBarButtonItem = menuButton;
    //self.navigationItem.leftBarButtonItem = pastButton;
    self.navigationItem.leftBarButtonItems = @[menuButton, pastButton];
    
    UIImageView *futureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow"]];
    futureImageView.frame = CGRectMake(0, 0, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    UITapGestureRecognizer *futureTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGoForwardInTime)];
    [futureImageView addGestureRecognizer:futureTgr];
    UIBarButtonItem *futureButton = [[UIBarButtonItem alloc] initWithCustomView:futureImageView];
    
    self.navigationItem.rightBarButtonItem = futureButton;
    
    //self.navigationItem.titleView =
}

#pragma mark Private helper methods

- (CGRect)createNewFrameBasedOnView:(UIView *)view {
    return CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

// TODO: Delete if we get rid of a menu button on this screen
- (void)toggleMenu {
    // TODO: see if it's weird to import SlidingMenu in order to trigger this
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuToggleStateNotification object:nil];
}

- (void)onGoBackInTime {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForPrevMonth]];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onGoForwardInTime {
//    if (self.monthData.isCurrentMonth) {
//        [self onGoToToday];
//    } else {
        HomeViewController *vc = [[HomeViewController alloc] initWithDate:[self.monthData getStartDateForNextMonth]];
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

// TODO: delete this if we don't decide to have a "today" button on home
- (void)onGoToToday {
    HomeViewController *vc = [[HomeViewController alloc] initWithDate:[NSDate date]];
    BOOL animated = !self.monthData.isCurrentMonth;
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)presentDayView:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    Day *data = dict[kDayNotifParam];
    
    DayViewController *vc = [[DayViewController alloc] initWithDay:data];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
