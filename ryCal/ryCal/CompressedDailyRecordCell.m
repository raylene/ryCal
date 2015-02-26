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
@property (weak, nonatomic) IBOutlet UIView *checkboxView;

@property (nonatomic, strong) UIImageView *selectedCheckImageView;

@end

@implementation CompressedDailyRecordCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [SharedConstants getMonthBackgroundColor];
    self.outerContentView.backgroundColor = [SharedConstants getMonthBackgroundColor];
    self.innerContentView.backgroundColor = [UIColor whiteColor];

    // Reusable checked image view
    self.selectedCheckImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"centercheck"]];
    CGRect frame = self.checkboxView.frame;
    frame.origin.x = frame.origin.y = 0;
    self.selectedCheckImageView.frame = frame;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
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
        [self deleteRecord];
    } else {
        NSString *newText = [self getNewRecordNoteText];
        if (self.recordData && newText != nil) {
            self.recordData[kNoteFieldKey] = newText;
        } else {
            self.recordData = [Record createNewRecord:self.typeData withText:newText onDate:self.date];
        }
        
        // TODO: push this into the Record.h class?
        [self.recordData saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully saved/updated record");
                [self sendDataChangedNotifications];
            } else {
                NSLog(@"Failed to save record");
            }
        }];
    }
}

- (void)deleteRecord {
    // No need to delete if it's already nil
    if (self.recordData == nil) {
        return;
    }
    [Record deleteRecord:self.recordData completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Succeeded in deleting the record: %@", self.recordData);
            self.recordData = nil;
            [self sendDataChangedNotifications];
        } else {
            NSLog(@"Failed to delete");
        }
    }];
}

- (void)sendDataChangedNotifications {
    // TODO: figure out if this is working properly...
    [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
    // TODO: cleanup duplicate Month + Day notifs being sent out
    [[NSNotificationCenter defaultCenter] postNotificationName:DayDataChangedNotification object:nil];
}

#pragma mark Methods tied to visual elements that should be overriden

- (BOOL)shouldShowDeleteConfirmation {
    return self.recordNoteText.text.length;
}

- (void)setupTypeRelatedFields {
    self.recordTypeName.text = self.typeData[kNameFieldKey];
    self.backgroundColor = [SharedConstants getColor:self.typeData[kColorFieldKey]];
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

        [self.checkboxView addSubview:self.selectedCheckImageView];
    } else {
        self.outerContentView.backgroundColor = typeColor;
        self.innerContentView.backgroundColor = [UIColor whiteColor];
        
        [self.selectedCheckImageView removeFromSuperview];
        self.checkboxView.layer.borderColor = [typeColor CGColor];
        self.checkboxView.layer.borderWidth = 1;
    }
    self.recordNoteText.textColor = self.recordTypeName.textColor = textColor;
}

- (NSString *)getNewRecordNoteText {
    return self.recordData[kNoteFieldKey];
}

#pragma mark UIGestureRecognizers

- (IBAction)onTapGesture:(id)sender {
    // This is a binary toggle, so if the record already exists, consider this a delete
    BOOL deleteRecord = self.recordData != nil;
    if (deleteRecord && [self shouldShowDeleteConfirmation]) {
        NSString *msg = @"You've saved a special note for this record. Are you sure you want to delete this?";
        [SharedConstants presentDeleteConfirmation:msg confirmationHandler:^{
            [self saveChanges:deleteRecord];
        }];
    } else {
        [self saveChanges:deleteRecord];
    }
}

@end
