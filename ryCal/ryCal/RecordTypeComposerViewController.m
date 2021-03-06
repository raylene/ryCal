//
//  RecordTypeComposerViewController.m
//  ryCal
//
//  Created by Raylene Yung on 12/27/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "RecordTypeComposerViewController.h"
#import "SharedConstants.h"
#import "ColorCell.h"
#import "RecordType.h"

@interface RecordTypeComposerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) RecordType *recordType;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *enabledControl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)onDelete:(id)sender;
- (IBAction)nameTextEditingChanged:(id)sender;

@end

@implementation RecordTypeComposerViewController

NSString * const kRecordDescriptionPlaceholder = @"What do you want to accomplish? (e.g. Go running twice a week)";

- (id)init {
    self = [super init];
    if (self) {
        [self setupWithRecordType:nil];
    }
    return self;
}

- (id)initWithRecordType:(RecordType *)recordType {
    self = [super init];
    if (self) {
        [self setupWithRecordType:recordType];
    }
    return self;
}

- (void)setupWithRecordType:(RecordType *)recordType {
    if (recordType == nil) {
        recordType = [RecordType createNewDefaultRecordType];
    }
    [self setRecordType:recordType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupColorCollectionView];
    [self setupNavigationBar];
    [self setupTextView];
    
    // Setup tap gesture recognizer to help dismiss keyboard
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    [self.view addGestureRecognizer:tgr];
    
    // Initialize elements using current record type data
    [self.nameTextField setText:self.recordType[kNameFieldKey]];
    [self.enabledControl setSelectedSegmentIndex:(int)[self.recordType[kArchivedFieldKey] boolValue]];
    
    // Disable saving/deleting if there's no type name
    [self toggleEditingButtonStates];
}

- (void)setupNavigationBar {
    self.title = @"Edit";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
}

- (void)setupTextView {
    // Some tips from: http://stackoverflow.com/questions/1824463/how-to-style-uitextview-to-like-rounded-rect-text-field
    [self.descriptionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [self.descriptionTextView.layer setBorderWidth:1.0];
    [self.descriptionTextView.layer setCornerRadius:5.0];
    self.descriptionTextView.clipsToBounds = YES;
    
    self.descriptionTextView.delegate = self;
    
    if ([self.recordType[kDescriptionFieldKey] length]) {
        [self.descriptionTextView setText:self.recordType[kDescriptionFieldKey]];
        self.descriptionTextView.textColor = [UIColor blackColor];
    } else {
        [self.descriptionTextView setText:kRecordDescriptionPlaceholder];
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
    }
}

// Helper to properly save the description instead of the placeholder
- (NSString *)getDescriptionTextForSaving {
    if (![self.descriptionTextView.text isEqualToString:kRecordDescriptionPlaceholder]) {
        return [SharedConstants getSaveFormattedString:self.descriptionTextView.text];
    }
    return nil;
}

- (void)setupColorCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"ColorCell" bundle:nil];
    [self.colorCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"ColorCell"];
    
    self.colorCollectionView.delegate = self;
    self.colorCollectionView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSwitched:) name:ColorSelectedNotification object:nil];
}

- (void)colorSwitched:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSString *notifID = dict[kRecordTypeIDNotifParam];
    if ((self.recordType.objectId && [self.recordType.objectId isEqualToString:notifID]) ||
        (!self.recordType.objectId && [notifID isEqualToString:kRecordTypeIDNotifParamPlaceholder])) {
        self.recordType[kColorFieldKey] = dict[kColorSelectedNotifParam];
    }
}

#pragma mark Event handling helper methods

- (void)tapDismissKeyboard {
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (void)onSave {
    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.recordType.name = [SharedConstants getSaveFormattedString:self.nameTextField.text];
    self.recordType.archived = (BOOL)self.enabledControl.selectedSegmentIndex;
    self.recordType.description = [self getDescriptionTextForSaving];
    
    [RecordType saveType:self.recordType completion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully saved record type changes");
            [[NSNotificationCenter defaultCenter] postNotificationName:RecordTypeDataChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
        } else {
            NSLog(@"Error saving!");
        }
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onDelete:(id)sender {
    NSString *msg = @"Deleting this activity will completely remove it from your calendar, and there is currently no way to recover it. Are you sure you want to delete this?";
    [SharedConstants presentDeleteConfirmation:msg confirmationHandler:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        // TODO: also delete all records with that type? Would need a confirmation before doing this...
        [RecordType deleteType:self.recordType completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully deleted record type");
                [[NSNotificationCenter defaultCenter] postNotificationName:RecordTypeDataChangedNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:MonthDataChangedNotification object:nil];
            } else {
                NSLog(@"Error deleting record type");
                NSString *msg = [NSString stringWithFormat:@"We encountered an error when trying to delete your activity. Please try again later. (Error code: %@)", error.localizedDescription];
                [SharedConstants presentErrorDialog:msg];
            }
        }];
    }];
}

#pragma mark UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kRecordDescriptionPlaceholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = kRecordDescriptionPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark UITextField event and related helper methods

- (void)toggleEditingButtonStates {
    // Disable saving/deleting if there's no type name
    BOOL hasName = self.nameTextField.text.length;
    self.navigationItem.rightBarButtonItem.enabled = hasName;
    self.deleteButton.enabled = hasName;
}
- (IBAction)nameTextEditingChanged:(id)sender {
    [self toggleEditingButtonStates];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDataDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NUM_COLORS;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double width = collectionView.frame.size.width / ((NUM_COLORS / 2) + 1);
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    NSArray *colorArray = [SharedConstants getColorArray];
    [cell setViewController:self];
    [cell setColorName:colorArray[indexPath.row]];
    if (self.recordType.objectId) {
        [cell setRecordTypeID:self.recordType.objectId];
    } else {
        // No record yet -- set to placeholder
        [cell setRecordTypeID:kRecordTypeIDNotifParamPlaceholder];
    }
    [cell setSelectedColor:self.recordType[kColorFieldKey]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
