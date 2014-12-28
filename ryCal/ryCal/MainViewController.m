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

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet MonthCollectionView *monthCollectionView;

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.monthCollectionView setViewController:self];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
}

- (IBAction)onRecordTypeClick:(id)sender {
    NSLog(@"Clicked Record Types");
 
    RecordTypeViewController *vc = [[RecordTypeViewController alloc] init];
    //    vc.backgroundColor = self.color;
    //    vc.textColor = self.bestieTextLabel.textColor;
    //    vc.modalPresentationStyle = UIModalPresentationCustom;
    //    vc.transitioningDelegate = self.parentVC;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onLogout {
    [User logout];
}
@end
