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

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) EditableRecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    self.recordDictionary = [[NSMutableDictionary alloc] init];

    self.title = [self.dayData getTitleString];

//    [Record createTestRecordsForDate:[self.dayData getStartDate]];
    
    [RecordType loadEnabledTypes:^(NSArray *types, NSError *error) {
        self.recordTypes = types;
        [Record loadAllRecordsForDay:self.dayData completion:^(NSArray *records, NSError *error) {
            // NSLog(@"Records for day: %@", records);
            for (Record *record in records) {
                // TODO: figure out why this doesn't work...
                // NSString *recordTypeID = [record getTypeIDField];
                NSString *recordTypeID = record[@"typeID"];
                [self.recordDictionary setObject:record forKey:recordTypeID];
            }
            [self.typeTableView reloadData];
        }];
    }];
}

- (void)setupTypeTable {
    UINib *cellNib = [UINib nibWithNibName:@"EditableRecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"EditableRecordTypeCell"];

    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Custom setters

- (EditableRecordTypeCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableRecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableRecordTypeCell" forIndexPath:indexPath];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    cell.recordData = self.recordDictionary[cell.typeData.objectId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordTypes.count;
}

- (void)onLogout {
    [User logout];
}

@end
