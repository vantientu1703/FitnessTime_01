//
//  EditPTManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "EditPTManagerViewController.h"
#import "TrainerManager.h"
#import "PTMeetingViewController.h"

CGFloat const kCornerRadiusImageViewPTEdit = 50.0f;
NSString *const kNoFillAddressTitle  = @"Fill address,please!";
NSString *const kNoFillEmailTitle = @"Fill email,please!";
NSString *const kNoFillFullNameTitle = @"Fill full name,please!";
NSString *const kNoFillPhoneNumberTitle = @"Fill phone number,please";
NSString *const kNoFillIncomShifTitle = @"Fill income per shif,please!";
NSString *const kSelectDateOfBirth = @"Select date of birth,please";
NSString *const kSelectAvatar = @"Select avatar,please";

@interface EditPTManagerViewController ()<AlertManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TrainerManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPT;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet DecimalTextField *textFiledIncomeShif;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EditPTManagerViewController
{
    NSDate *_dateOfBirth;
    NSString *_imageString;
    BOOL _modifier;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

#pragma mark - Set up view
- (void)setupView {
    if ([self.statusEditString isEqualToString:kEditTrainerTitle]) {
        self.title = kEditTrainerTitle;
    } else {
        self.title = kAddNewTrainerTitle;
    }
    self.textFieldFullName.delegate = self;
    self.textFieldPhoneNumber.delegate = self;
    self.textFieldAddress.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFiledIncomeShif.delegate = self;
    self.imageViewPT.layer.cornerRadius = kCornerRadiusImageViewPTEdit;
    self.imageViewPT.layer.masksToBounds = true;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(savePTInfo:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    if (!_dateOfBirth) {
        [self.buttonDateOfBirth setTitle:kSelectDate forState:UIControlStateNormal];
    }
    if ([self.statusEditString isEqualToString:kEditTrainerTitle]) {
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        self.textFieldAddress.text = self.trainer.address;
        self.textFieldEmail.text = self.trainer.email;
        self.textFieldFullName.text = self.trainer.fullName;
        self.textFieldPhoneNumber.text = self.trainer.telNumber;
        self.textFiledIncomeShif.text = [NSString stringWithFormat:@"%0.2f", self.trainer.meetingMoney];
        if (self.trainer.birthday) {
            [self.buttonDateOfBirth setTitle:[dateFormatter dateFormatterDateMonthYear:self.trainer.birthday]
                forState:UIControlStateNormal];
        } else {
            [self.buttonDateOfBirth setTitle:kSelectDate forState:UIControlStateNormal];
        }
        NSURL *url = self.trainer.avatarURL;
        [self.imageViewPT sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                self.imageViewPT.image = [UIImageConstant imageUserConstant];
            } else {
                _imageString = [UIImageJPEGRepresentation(image, 0.4f)
                    base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
        }];
        _dateOfBirth = self.trainer.birthday;
    }
}

#pragma mark - Done button
- (IBAction)savePTInfo:(id)sender {
    [self.view endEditing:true];
    [self createTrainer];
}

#pragma mark - Set info for trainer
- (void)createTrainer {
    CGFloat height = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    self.scrollView.contentOffset = CGPointMake(0.0f, height);
    NSString *phoneNumber = [DataValidation isValidPhoneNumber:(NSMutableString *)self.textFieldPhoneNumber.text];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    double dateBirthTime = [_dateOfBirth timeIntervalSince1970];
    self.labelNotes.text = kNothingToUpdate;
    if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kNoFillAddressTitle;
    } else if (!self.textFieldFullName.text.length) {
        self.labelNotes.text = kNoFillFullNameTitle;
    } else if (!self.textFieldPhoneNumber.text.length) {
        self.labelNotes.text = phoneNumber;
    } else if (!self.textFiledIncomeShif.text.length) {
        self.labelNotes.text = kNoFillIncomShifTitle;
    } else if (!_dateOfBirth) {
        self.labelNotes.text = kSelectDateOfBirth;
    } else if (!_imageString) {
        self.labelNotes.text = kSelectAvatar;
    } else if (currentTime < dateBirthTime) {
        self.labelNotes.text = kDateBirthTitle;
    } else {
        Trainer *trainer;
        if ([self.statusEditString isEqualToString:kEditTrainerTitle]) {
            trainer = self.trainer;
        } else {
            trainer = [[Trainer alloc] init];
        }
        trainer.fullName = self.textFieldFullName.text;
        trainer.telNumber = self.textFieldPhoneNumber.text;
        trainer.birthday = _dateOfBirth;
        trainer.address = self.textFieldAddress.text;
        trainer.email = self.textFieldEmail.text;
        trainer.meetingMoney = self.textFiledIncomeShif.value;
        TrainerManager *trainerManager = [[TrainerManager alloc] init];
        trainerManager.delegate = self;
        if (_modifier) {
            if ([self.statusEditString isEqualToString:kEditTrainerTitle]) {
                trainer.avatar = _imageString;
                [CustomLoadingView showInView:self.view];
                [trainerManager updateTrainer:trainer];
            } else {
                [CustomLoadingView showInView:self.view];
                trainer.avatar = _imageString;
                [trainerManager createNewTrainer:trainer];
            }
        }
    }
}

#pragma mark - TrainerManagerDelegate
- (void)createdTrainerWithMessage:(BOOL)success withError:(NSError *)error returnTrainer:(Trainer *)trainer {
    [CustomLoadingView hideLoadingInView:self.view];
    _modifier = false;
    if (success) {
        self.labelNotes.text = kCreateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
        NSDictionary *userInfo = @{@"trainer": trainer};
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddNewTrainerTitle object:self userInfo:userInfo];
    } else {
        [AlertManager showAlertWithTitle:kRegisterRequest message:error.localizedDescription
            viewControler:self reloadAction:^{
            [self createTrainer];
        }];
        self.labelNotes.text = kCreateFail;
    }
}

- (void)updateTrainerWithMessage:(BOOL)success withError:(NSError *)error returnTrainer:(Trainer *)trainer {
    [CustomLoadingView hideLoadingInView:self.view];
    _modifier = false;
    if (success) {
        self.labelNotes.text = kUpdateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
        if ([self.delegate respondsToSelector:@selector(updateTrainer:)]) {
            [self.delegate updateTrainer:trainer];
        }
        NSDictionary *userInfo = @{@"trainer": trainer};
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateTrainerTitle object:nil userInfo:userInfo];
    } else {
        self.labelNotes.text = kUpdateFail;
        [AlertManager showAlertWithTitle:kRegisterRequest message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

#pragma mark - Button select date
- (IBAction)buttonSelectDatePress:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [self.navigationController pushViewController:calendarVC animated:true];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _modifier = true;
        _dateOfBirth = dateSelected;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        [self.buttonDateOfBirth setTitle:[dateFormatter
            dateFormatterDateMonthYear:_dateOfBirth] forState:UIControlStateNormal];
    }];
}

#pragma mark - Update avatar
- (IBAction)buttonUpdateProfilePress:(id)sender {
    AlertManager *alertManager = [[AlertManager alloc] init];
    alertManager.delegate = self;
    [alertManager showChooseImageAlertWithTitle:kReminderTitle message:kMessageReminder vieController:self];
}

#pragma mark - AlertManagerDelegate
- (void)showImagePickerController:(UIImagePickerController *)imagePickerController {
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //TODO
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGSize size = CGSizeMake(self.imageViewPT.bounds.size.width, self.imageViewPT.bounds.size.height);
    UIImage *newImage = [Utils convertImageToThumbnailImage:chosenImage withSize:size];
    self.imageViewPT.image = newImage;
    if (newImage) {
        _imageString = [UIImageJPEGRepresentation(newImage, 0.4)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    _modifier = true;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createTrainer];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _modifier = true;
    return YES;
}

@end
