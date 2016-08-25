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

@interface EditMyProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@end

@implementation EditMyProfileViewController
{
    NSString *_imageString;
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
    _imageString = self.user.avatar;
}

- (void)setupView {
    self.title = kEditViewControllerTitle;
    self.imageViewOfUser.layer.cornerRadius = kCornerRadiusImageViewUser;
    self.imageViewOfUser.layer.masksToBounds = YES;
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
    if (!_imageString.length) {
        self.labelNotes.text = kSelectImage;
    } else if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kFillAddressTitle;
    } else if (!self.textFieldEmail.text.length) {
        self.labelNotes.text = kFilEmail;
    } else if (!self.textFieldFullName.text.length) {
        self.labelNotes.text = kFileFullName;
    } else if (!self.textFieldPhoneNumber.text.length) {
        self.labelNotes.text = kFillPhoneNumber;
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        self.user.avatar = _imageString;
        self.user.address = self.textFieldAddress.text;
        self.user.email = self.textFieldEmail.text;
        self.user.fullName = self.textFieldFullName.text;
        self.user.telNumber = self.textFieldPhoneNumber.text;
        ProfileManager *profileManager = [[ProfileManager alloc] init];
        profileManager.delegate = self;
        [profileManager updateProfile:self.user];
    }
}

#pragma mark - ProfileManagerDelegate 
- (void)updateProfile:(User *)user success:(BOOL)success error:(NSError *)error {
    if (success) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [[DataStore sharedDataStore] updateProfile:user complete:^(BOOL success) {
            if (success) {
                self.labelNotes.text = kUpdateSuccessTitle;
            } else {
                self.labelNotes.text = kUpdateFailTitle;
            }
        }];
        self.labelNotes.text = kUpdateSuccessTitle;
        if ([self.delegate respondsToSelector:@selector(updateUser:)]) {
            [self.delegate updateUser:user];
        }
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        self.labelNotes.text = kUpdateFailTitle;
        [AlertManager showAlertWithTitle:kReminderTitle message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

#pragma mark - Select photo
- (IBAction)buttonSelectImagePress:(id)sender {
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
        _imageString = [_imageString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
