//
//  DayViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "DayViewController.h"
#import "User.h"
#import "EditableRecordTypeCell.h"
#import "RecordType.h"
#import "Record.h"
#import "SharedConstants.h"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EditableRecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSDictionary *recordDictionary;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@property (nonatomic, assign) CGPoint initialTableOffset;

@end

@implementation DayViewController

float const RECORD_CELL_HEIGHT = 70.0;

- (id)initWithDay:(Day *)dayData {
    self = [super init];
    if (self) {
        [self setDayData:dayData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    [self setupNavigationBar];
    self.recordDictionary = [[NSMutableDictionary alloc] init];

    self.title = [self.dayData getTitleString];
    
    // TODO: potentially share code with similar record fetching in Month.m
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
        [Record loadRecordDictionaryForTimeRange:[self.dayData getStartDate] endDate:[self.dayData getEndDate] cacheKey:[self.dayData getDayCacheKey] completion:^(NSDictionary *recordDict, NSError *error) {
            self.recordDictionary = recordDict;
            [self.typeTableView reloadData];
        }];
    }];
    
    [self subscribeToNotifications];
}

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToRecord:) name:ScrollToRecordNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeToNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ScrollToRecordNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDismiss)];
}

- (void)onDismiss {
    [self unsubscribeToNotifications];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTypeTable {
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;

    self.initialTableOffset = CGPointMake(0.0, 0.0 - self.typeTableView.frame.origin.y);
    
    UINib *cellNib = [UINib nibWithNibName:@"EditableRecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"EditableRecordTypeCell"];
}

#pragma Notification response methods

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    [self.typeTableView
     setContentOffset:self.initialTableOffset
     animated:YES];
}

- (void)scrollToRecord:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSIndexPath *indexPath = dict[kIndexPathNotifParam];
    NSLog(@"scrollToRecord: %@", indexPath);
    
    [self.typeTableView
     setContentOffset:CGPointMake(0, (indexPath.row * RECORD_CELL_HEIGHT))
     animated:YES];
}

#pragma mark - Custom setters

- (EditableRecordTypeCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RECORD_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableRecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    cell.monthCacheKey = [self.dayData getMonthCacheKey];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

@end
