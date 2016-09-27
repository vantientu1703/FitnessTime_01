//
//  EditMyProfileViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "EditMyProfileViewController.h"
#import "AlertManager.h"
#import "Utils.h"

NSString *const kEditViewControllerTitle = @"Update profile";
CGFloat const kCornerRadiusImageViewUser = 50.0f;
NSString *const kSelectImage = @"Select avatar";
NSString *const kFillAddressTitle = @"Fill address";
NSString *const kFilEmail = @"Fill email";
NSString *const kFileFullName = @"Fill full name";
NSString *const kFillPhoneNumber = @"Fill phone number";
NSString *const kUpdateSuccessTitle = @"Update success";
NSString *const kUpdateFailTitle = @"Update fail";

@interface EditMyProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (weak, nonatomic) IBOutlet UIButton *buttonDateOfBirth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EditMyProfileViewController
{
    NSString *_imageString;
    NSDate *_fromDate;
    BOOL _modifier;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setupMyProfile];
}

- (void)setupMyProfile {
    self.textFieldAddress.text = self.user.address;
    self.textFieldEmail.text = self.user.email;
    self.textFieldFullName.text = self.user.fullName;
    self.textFieldPhoneNumber.text = self.user.telNumber;
    [self.buttonDateOfBirth setTitle:[[DateFormatter sharedInstance]
        dateFormatterDateMonthYear:self.user.birthday] forState:UIControlStateNormal];
    _fromDate = self.user.birthday;
    _imageString = self.user.avatar;
    NSURL *url = self.user.avatarURL;
    [self.imageViewOfUser sd_setImageWithURL:url
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewOfUser.image = [UIImageConstant imageUserConstant];
        } else {
            _imageString = [UIImageJPEGRepresentation(image, 0.4f)
                base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
    }];
}

- (void)setupView {
    self.title = kEditViewControllerTitle;
    self.imageViewOfUser.layer.cornerRadius = kCornerRadiusImageViewUser;
    self.imageViewOfUser.layer.masksToBounds = YES;
    self.textFieldAddress.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldFullName.delegate = self;
    self.textFieldPhoneNumber.delegate = self;
    [self.buttonDateOfBirth setTitle:[[DateFormatter sharedInstance] dateFormatterDateMonthYear:[NSDate date]]
        forState:UIControlStateNormal];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(donePress:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Button
- (IBAction)donePress:(id)sender {
    [self.view endEditing:YES];
    [self saveUser];
}

- (void)saveUser {
    CGFloat height = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    self.scrollView.contentOffset = CGPointMake(0.0f, height);
    double currentTime = [[NSDate date] timeIntervalSince1970];
    double dateBirthTime = [_fromDate timeIntervalSince1970];
    NSString *phoneNumber = [DataValidation isValidPhoneNumber:(NSMutableString *)self.textFieldPhoneNumber.text];
    if (phoneNumber) {
        self.labelNotes.text = phoneNumber;
    } else if (currentTime < dateBirthTime) {
        self.labelNotes.text = kDateBirthTitle;
    } else if (!_imageString.length) {
        self.labelNotes.text = kSelectImage;
    } else if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kFillAddressTitle;
    } else if (!self.textFieldEmail.text.length) {
        self.labelNotes.text = kFilEmail;
    } else if (!self.textFieldFullName.text.length) {
        self.labelNotes.text = kFileFullName;
    } else if (!self.textFieldPhoneNumber.text.length) {
        self.labelNotes.text = kFillPhoneNumber;
    } else if (_modifier) {
        self.user.avatar = _imageString;
        self.user.address = self.textFieldAddress.text;
        self.user.email = self.textFieldEmail.text;
        self.user.fullName = self.textFieldFullName.text;
        self.user.telNumber = self.textFieldPhoneNumber.text;
        self.user.birthday = _fromDate;
        ProfileManager *profileManager = [[ProfileManager alloc] init];
        profileManager.delegate = self;
        [CustomLoadingView showInView:self.view];
        [profileManager updateProfile:self.user];
    }
}

- (IBAction)selectDateOfBirthPress:(id)sender {
    [self showCalendar];
}

- (IBAction)selectCalendarPress:(id)sender {
    [self showCalendar];
};

- (void)showCalendar {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _fromDate = dateSelected;
        _modifier = true;
        [self.buttonDateOfBirth setTitle:[[DateFormatter sharedInstance]
            dateFormatterDateMonthYear:_fromDate] forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

#pragma mark - ProfileManagerDelegate 
- (void)updateProfile:(User *)user success:(BOOL)success error:(NSError *)error {
    _modifier = false;
    [CustomLoadingView hideLoadingInView:self.view];
    if (success) {
        [[DataStore sharedDataStore] updateProfile:user complete:^(BOOL success) {
            if (success) {
                self.labelNotes.text = kUpdateSuccessTitle;
                self.labelNotes.textColor = [GymManagerConstant themeColor];
                if ([self.delegate respondsToSelector:@selector(updateUser:)]) {
                    [self.delegate updateUser:user];
                }
            } else {
                self.labelNotes.text = kUpdateFailTitle;
            }
        }];
    } else {
        self.labelNotes.text = kUpdateFailTitle;
        [AlertManager showAlertWithTitle:kReminderTitle message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

#pragma mark - Select photo
- (IBAction)buttonSelectImagePress:(id)sender {
    [self.view endEditing:YES];
    [AlertManager showAlertWithTitle:kMessageReminder message:kChoosenTypeTitle
        viewControler:self takePhotoFromLibrary:^{
        [self takePhotoFromLibrary];
    } takePhotoFromCamera:^{
        [self takePhotoFromCamera];
    }];
}

-(void)takePhotoFromLibrary {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)takePhotoFromCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *cameraErrorAlert = [UIAlertController alertControllerWithTitle:@""
            message:kNotFoundCamera preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cameraNotFound = [UIAlertAction actionWithTitle:kOkTitle
            style:UIAlertActionStyleDestructive handler:nil];
        [cameraErrorAlert addAction:cameraNotFound];
        [self presentViewController:cameraErrorAlert animated:YES completion:nil];
    } else {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.delegate = self;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGFloat x0 = self.imageViewOfUser.frame.size.width;
    CGFloat y0 = self.imageViewOfUser.frame.size.height;
    CGSize viewSize = CGSizeMake(x0, y0);
    UIImage *newImage = [Utils convertImageToThumbnailImage:chosenImage withSize:viewSize];
    self.imageViewOfUser.image = newImage;
    if (newImage) {
        _imageString = [UIImageJPEGRepresentation(newImage, 0.4f)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    _modifier = true;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _modifier = true;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
