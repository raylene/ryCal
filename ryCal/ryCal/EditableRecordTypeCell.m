//
//  EditableRecordTypeCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/22/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "EditableRecordTypeCell.h"
#import "SharedConstants.h"

@interface EditableRecordTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *recordColorImage;
@property (weak, nonatomic) IBOutlet UILabel *recordTypeName;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

- (IBAction)switchValueChanged:(id)sender;
- (IBAction)noteDidEndOnExit:(id)sender;

@end

@implementation EditableRecordTypeCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

@synthesize typeData = _typeData;
- (void) setTypeData:(RecordType *)typeData {
    _typeData = typeData;
    self.recordTypeName.text = typeData[kNameFieldKey];
    self.recordColorImage.backgroundColor = [SharedConstants getColor:typeData[kColorFieldKey]];
}

@synthesize recordData = _recordData;
- (void) setRecordData:(Record *)recordData {
    _recordData = recordData;
    BOOL hasData = (recordData != nil);
    [self.toggleSwitch setOn:hasData];
    [self.noteTextField setHidden:!hasData];
    
    if (hasData && recordData[kNoteFieldKey]) {
        [self.noteTextField setText:recordData[kNoteFieldKey]];
    }
}

- (IBAction)switchValueChanged:(id)sender {
    BOOL isDisabled = !self.toggleSwitch.on;
    [self.noteTextField setHidden:isDisabled];
    if (isDisabled) {
        self.noteTextField.text = nil;
    }
    [self saveChanges];
}

- (IBAction)noteDidEndOnExit:(id)sender {
    [self resignFirstResponder];
    [self saveChanges];
}

- (void)saveChanges {
    NSLog(@"Saving record changes: %@", self.recordData);
    if (self.toggleSwitch.on) {
        // Format text so it is saveable
        NSString *trimmedString = [self.noteTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (self.recordData) {
            self.recordData[kNoteFieldKey] = trimmedString;
        } else {
            self.recordData = [Record createNewRecord:self.typeData.objectId withText:trimmedString onDate:self.date];
        }
        [self.recordData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully saved/updated record");
            } else {
                NSLog(@"Failed to save record");
            }
        }];
    } else {
        // Delete the record if it already exists
        if (self.recordData != nil) {
            [self.recordData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Succeeded in deleting the record");
                    self.recordData = nil;
                } else {
                    NSLog(@"Failed to delete");
                }
            }];
        }
    }
}

@end
