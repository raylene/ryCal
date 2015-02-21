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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (IBAction)switchValueChanged:(id)sender {
    BOOL isDisabled = !self.toggleSwitch.on;
    [self.noteTextField setHidden:isDisabled];
    if (isDisabled) {
        self.noteTextField.text = nil;
    }
    [super saveChanges:[self shouldDeleteRecord]];
}

- (IBAction)noteDidEndOnExit:(id)sender {
    [self resignFirstResponder];
    [self saveChanges:[self shouldDeleteRecord]];
}

#pragma mark CompressedDailyRecordCell that should be overridden

- (BOOL)shouldShowDeleteConfirmation {
    NSString *currentNote = self.recordData[kNoteFieldKey];
    return currentNote.length;
}

- (void)setupTypeRelatedFields {
    self.recordTypeName.text = self.typeData[kNameFieldKey];
    self.recordColorImage.backgroundColor = [SharedConstants getColor:self.typeData[kColorFieldKey]];
}

- (void)setupRecordDataRelatedFields {
    BOOL hasData = (self.recordData != nil);
    [self.toggleSwitch setOn:hasData];
    [self.noteTextField setHidden:!hasData];
    
    if (hasData && self.recordData[kNoteFieldKey]) {
        [self.noteTextField setText:self.recordData[kNoteFieldKey]];
    }
}

- (BOOL)shouldDeleteRecord {
    return !self.toggleSwitch.on;
}

- (NSString *)getNewRecordNoteText {
    return [SharedConstants getSaveFormattedString:self.noteTextField.text];
}

@end
