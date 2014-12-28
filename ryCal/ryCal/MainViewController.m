//
//  MainViewController.m
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MainViewController.h"
#import "MonthCollectionView.h"
#import "DayCell.h"
#import "User.h"
#import "RecordTypeViewController.h"
#import "RecordTypeComposerViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet MonthCollectionView *monthCollectionView;

@end

@implementation MainViewController

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
