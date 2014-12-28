//
//  SelectableRecordTypeCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/22/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "SelectableRecordTypeCell.h"
#import "SharedConstants.h"

@interface SelectableRecordTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *recordColorImage;
@property (weak, nonatomic) IBOutlet UILabel *recordTypeName;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

- (IBAction)switchValueChanged:(id)sender;
- (IBAction)noteEditingDidEnd:(id)sender;
- (IBAction)noteEditingDidBegin:(id)sender;
- (IBAction)noteEditingChanged:(id)sender;
- (IBAction)noteDidEndOnExit:(id)sender;

@end

@implementation SelectableRecordTypeCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

@synthesize typeData = _typeData;
- (void) setTypeData:(RecordType *)typeData {
    _typeData = typeData;
    //    self.recordColorImage.text = [self.data getMonthString];
    self.recordTypeName.text = typeData[@"name"];//[typeData objectForKey:@"name"];
    self.recordColorImage.backgroundColor = [SharedConstants getColor:typeData[@"color"]];
}

@synthesize recordData = _recordData;
- (void) setRecordData:(Record *)recordData {
    NSLog(@"setRecordData: %@", recordData);
    _recordData = recordData;
    BOOL hasData = (recordData != nil);
    [self.toggleSwitch setOn:hasData];
    [self.noteTextField setHidden:!hasData];
    
    if (hasData && recordData[@"note"]) {
        [self.noteTextField setText:recordData[@"note"]];
    }
}

- (IBAction)switchValueChanged:(id)sender {
//    NSLog(@"switchValueChanged: %d", self.toggleSwitch.on);
    [self.noteTextField setHidden:!self.toggleSwitch.on];
    if (!self.toggleSwitch.on) {
        self.noteTextField.text = nil;
    }
    [self saveChanges];
}

- (IBAction)noteEditingDidEnd:(id)sender {
//    NSLog(@"noteEditingDidEnd: %@", self.noteTextField.text);
}

- (IBAction)noteEditingDidBegin:(id)sender {
//    NSLog(@"noteEditingDidBegin: %@", self.noteTextField.text);
}

- (IBAction)noteEditingChanged:(id)sender {
//    NSLog(@"noteEditingChanged: %@", self.noteTextField.text);
}

- (IBAction)noteDidEndOnExit:(id)sender {
    NSLog(@"noteDidEndOnExit: %@", self.noteTextField.text);
    [self resignFirstResponder];
    [self saveChanges];
}

- (void)saveChanges {
    NSLog(@"Saving record changes: %@", self.recordData);
    if (self.toggleSwitch.on) {
        // Format text so it is saveable
        NSString *trimmedString = [self.noteTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (self.recordData) {
            self.recordData[@"note"] = trimmedString;
            NSLog(@"attempting to updateText: %@, %@", self.recordData, trimmedString);
//            [self.recordData updateText:trimmedString completion:nil];
        } else {
            self.recordData = [Record createNewRecord:self.typeData.objectId withText:trimmedString onDate:self.date];
        }
        [self.recordData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully saved/updated record");
            }
        }];
    } else {
        // Delete the record if it already exists
        if (self.recordData != nil) {
            [self.recordData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                self.recordData = nil;
            }];
        }
    }
}

@end
