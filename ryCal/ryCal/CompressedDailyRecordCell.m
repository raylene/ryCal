//
//  CompressedDailyRecordCell.m
//  ryCal
//
//  Created by Raylene Yung on 1/7/15.
//  Copyright (c) 2015 rayleney. All rights reserved.
//

#import "CompressedDailyRecordCell.h"
#import "SharedConstants.h"

@interface CompressedDailyRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *recordTypeName;
@property (weak, nonatomic) IBOutlet UILabel *recordNoteText;
@property (weak, nonatomic) IBOutlet UIView *outerContentView;
@property (weak, nonatomic) IBOutlet UIView *innerContentView;

@end

@implementation CompressedDailyRecordCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [SharedConstants getMonthBackgroundColor];
    self.outerContentView.backgroundColor = [SharedConstants getMonthBackgroundColor];
    self.innerContentView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    //[self saveChanges:selected];
}

@synthesize typeData = _typeData;
- (void)setTypeData:(RecordType *)typeData {
    _typeData = typeData;
    [self setupTypeRelatedFields];
}

@synthesize recordData = _recordData;
- (void)setRecordData:(Record *)recordData {
    _recordData = recordData;
    [self setupRecordDataRelatedFields];
}

- (void)saveChanges:(BOOL)deleteRecord {
    NSLog(@"Saving record changes: %@", self.recordData);
    if (deleteRecord) {
        // No need to delete if it's already nil
        if (self.recordData != nil) {
            [self deleteRecord];
        }
    } else {
        NSString *newText = [self getNewRecordNoteText];
        if (self.recordData) {
            self.recordData[kNoteFieldKey] = newText;
        } else {
            self.recordData = [Record createNewRecord:self.typeData withText:newText onDate:self.date];
        }
        [self.recordData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully saved/updated record");
                // TODO: figure out if this is working properly...
                [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
            } else {
                NSLog(@"Failed to save record");
            }
        }];
    }
}

- (void)deleteRecord {
    [self.recordData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Succeeded in deleting the record");
            self.recordData = nil;
            // TODO: figure out if this is working properly...
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
        } else {
            NSLog(@"Failed to delete");
        }
    }];
}

#pragma mark Methods tied to visual elements that should be overriden

- (void)setupTypeRelatedFields {
    self.recordTypeName.text = self.typeData[kNameFieldKey];
    self.backgroundColor = [SharedConstants getColor:self.typeData[kColorFieldKey]];
    //    self.recordColorImage.backgroundColor = [SharedConstants getColor:typeData[kColorFieldKey]];
}

- (void)setupRecordDataRelatedFields {
    BOOL hasData = (self.recordData != nil);
    
    self.recordNoteText.text = nil;
    UIColor *textColor = [UIColor darkGrayColor];
    UIColor *typeColor = [SharedConstants getColor:self.typeData[kColorFieldKey]];
    if (hasData) {
        textColor = [UIColor whiteColor];
        if (self.recordData[kNoteFieldKey]) {
            self.recordNoteText.text = self.recordData[kNoteFieldKey];
        }
        self.outerContentView.backgroundColor = typeColor;
        self.innerContentView.backgroundColor = typeColor;
    } else {
        self.outerContentView.backgroundColor = typeColor;
        self.innerContentView.backgroundColor = [UIColor whiteColor];
    }
    self.recordNoteText.textColor = self.recordTypeName.textColor = textColor;
}

- (NSString *)getNewRecordNoteText {
    return self.recordData[kNoteFieldKey];
    // Format text so it is saveable
//    NSString *trimmedString = [self.noteTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    // what happens when you tap? sigh
    // This is a binary toggle, so if the record already exists, consider this a delete
    [self saveChanges:(self.recordData != nil)];
}

@end
