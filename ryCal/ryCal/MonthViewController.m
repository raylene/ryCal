//
//  MonthViewController.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MonthViewController.h"
#import "MonthCollectionView.h"
#import "DayCell.h"
#import "User.h"
#import "RecordTypeViewController.h"
#import "RecordTypeComposerViewController.h"

@interface MonthViewController ()

@property (weak, nonatomic) IBOutlet MonthCollectionView *monthCollectionView;
@end

@implementation MonthViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setReferenceDate:[NSDate date]];
    }
    return self;
}

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        [self setReferenceDate:date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MonthViewC viewDidLoad: (%f, %f), (%f, %f)", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);

    [self setupNavigationBar];
    [self setupCollectionView];
    
    self.title = [self.monthCollectionView.monthData getTitleString];
}

- (void)setupCollectionView {
    [self.monthCollectionView setDate:self.referenceDate];
    [self.monthCollectionView setViewController:self];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
}

- (void)onLogout {
    [User logout];
}

- (IBAction)onRecordTypeClick:(id)sender {
    RecordTypeViewController *vc = [[RecordTypeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
