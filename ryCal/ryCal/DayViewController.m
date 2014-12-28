//
//  DayViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/20/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "DayViewController.h"
#import "User.h"
#import "SelectableRecordTypeCell.h"
#import "RecordType.h"
#import "Record.h"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SelectableRecordTypeCell *prototypeCell;
@property (nonatomic, strong) NSArray *recordTypes;
@property (nonatomic, strong) NSArray *records;

@property (nonatomic, strong) NSMutableDictionary *recordDictionary;

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTypeTable];
    self.dateLabel.text = [self.dayData getFullDateString];
    self.recordDictionary = [[NSMutableDictionary alloc] init];
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

//    [Record createTestRecordsForDate:[self.dayData getStartDate]];
    
    [RecordType loadAllTypes:^(NSArray *types, NSError *error) {
        NSLog(@"Record types: %@", types);
        self.recordTypes = types;
        [Record loadAllRecordsForDay:self.dayData completion:^(NSArray *records, NSError *error) {
            self.records = records;
            NSLog(@"Records for day: %@", self.records);
            for (Record *record in self.records) {
                // NSLog(@"Setting obj for key: %@, %@", record[@"typeID"], record);
                [self.recordDictionary setObject:record forKey:record[@"typeID"]];
                NSLog(@"Record dictionary for day: %@", self.recordDictionary);
            }
            [self.typeTableView reloadData];
        }];
    }];
}

- (void)setupTypeTable {
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *cellNib = [UINib nibWithNibName:@"SelectableRecordTypeCell" bundle:nil];
    [self.typeTableView registerNib:cellNib forCellReuseIdentifier:@"SelectableRecordTypeCell"];
}

#pragma mark - Custom setters

- (SelectableRecordTypeCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.typeTableView dequeueReusableCellWithIdentifier:@"SelectableRecordTypeCell"];
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
    SelectableRecordTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectableRecordTypeCell" forIndexPath:indexPath];
    cell.typeData = self.recordTypes[indexPath.row];
    cell.date = [self.dayData getStartDate];
    NSLog(@"attempting to set record data... %@, %@", cell.typeData, [self.recordDictionary objectForKey:cell.typeData.objectId]);
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
