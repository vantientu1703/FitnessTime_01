//
//  AddNewCustomerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddNewCustomerViewController.h"
#import "AlertManager.h"
#import "Utils.h"

NSString *const kMessageSelectTypeTitle = @"Select Type";
NSString *const kAcionChooseFromLibraryTtile = @"Choose from library";
NSString *const kAcionChooseFromCameraTtile = @"Choose from camera";
NSString *const kCancelButtonTitle = @"Cancel";
CGFloat const kCornerRadiusImageView = 40.0f;
NSString *const kFillNames = @"Fill name,please!";
NSString *const kFillPhoneNumbers = @"Fill phone number,please!";
NSString *const kFillAddresss = @"Fill address,please";
NSString *const kSelectFromDates = @"Select register date,please!";
NSString *const kSelectToDates = @"Select expiry date,please!";
NSString *const kSelectDateOfBirths = @"Select date of birth,please!";
NSString *const kSelectImages = @"Select avatar,please";

@interface AddNewCustomerViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomerManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameCustomer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegisterDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpityDate;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIView *viewBackgroundCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AddNewCustomerViewController
{
    NSDate *_fromDate;
    NSDate *_toDate;
    NSDate *_dateOfBirth;
    NSString *_imageAvatar;
    BOOL _modifier;
}
#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    if ([self.messageEditCustomer isEqualToString:kMessageEditCustomer]) {
        _dateOfBirth = self.customer.birthday;
        _fromDate = self.customer.registryDate;
        _toDate = self.customer.expiryDate;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        self.textFieldNameCustomer.text = self.customer.fullName;
        self.textFieldPhoneNumber.text = self.customer.telNumber;
        [self.buttonDateOfBirth setTitle:[dateFormatter dateFormatterDateMonthYear:self.customer.birthday]
            forState:UIControlStateNormal];
        self.textFieldAddress.text = self.customer.address;
        [self.buttonRegisterDate setTitle:[dateFormatter dateFormatterDateMonthYear:self.customer.registryDate]
            forState:UIControlStateNormal];
        [self.buttonExpityDate setTitle:[dateFormatter dateFormatterDateMonthYear:self.customer.expiryDate]
            forState:UIControlStateNormal];
        NSURL *url = self.customer.avatarURL;
        [self.imageViewCustomer sd_setImageWithURL:url
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                self.imageViewCustomer.image = [UIImageConstant imageUserConstant];
            } else {
                _imageAvatar = [UIImageJPEGRepresentation(image, 0.4f)
                    base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
        }];
    }
}

- (void)setupView {
    if (!_dateOfBirth) {
        [self.buttonDateOfBirth setTitle:kSelectDate forState:UIControlStateNormal];
    }
    if (!_fromDate) {
        [self.buttonRegisterDate setTitle:kSelectDate forState:UIControlStateNormal];
    }
    if (!_toDate) {
        [self.buttonExpityDate setTitle:kSelectDate forState:UIControlStateNormal];
    }
    self.textFieldPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldAddress.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldNameCustomer.delegate = self;
    self.textFieldPhoneNumber.delegate = self;
    if ([self.messageEditCustomer isEqualToString:kMessageEditCustomer]) {
        self.title = kMessageEditCustomer;
    } else {
        self.title = kAddNEwCustomerVCTitle;
    }
    self.viewBackgroundCustomer.layer.cornerRadius = kCornerRadiusViewBackground;
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageView;
    self.imageViewCustomer.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(selectPhoto:)];
    [self.imageViewCustomer addGestureRecognizer:tap];
    self.imageViewCustomer.userInteractionEnabled = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(saveNewCustomer:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _modifier = true;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITapGestureRecognizer
- (IBAction)selectPhoto:(id)sender {
    [self showAlertController];
}

#pragma mark - Show alert controller
- (void)showAlertController {
    [AlertManager showAlertWithTitle:kReminderTitle
        message:kMessageSelectTypeTitle viewControler:self takePhotoFromLibrary:^{
        [self takePhotoFromLibrary];
    } takePhotoFromCamera:^{
        [self takePhotoFromCamera];
    }];
}

#pragma mark - Take photo
- (void)takePhotoFromLibrary {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)takePhotoFromCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *cameraErrorAlert = [UIAlertController alertControllerWithTitle:@""
            message:kMessageNotFoundCamera preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cameraNotFound = [UIAlertAction actionWithTitle:kOkActionTitle
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

#pragma mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _modifier = true;
    UIImage *choosenImage = info[UIImagePickerControllerOriginalImage];
    CGFloat x0 = self.imageViewCustomer.frame.size.width;
    CGFloat y0 = self.imageViewCustomer.frame.size.height;
    CGSize viewSize = CGSizeMake(x0, y0);
    UIImage *newImage = [Utils convertImageToThumbnailImage:choosenImage withSize:viewSize];
    self.imageViewCustomer.image = newImage;
    if (newImage) {
        _imageAvatar = [UIImageJPEGRepresentation(newImage, 0.4f)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Save new customer
- (IBAction)saveNewCustomer:(id)sender {
    [self.view endEditing:YES];
    [self setupInfoNewCustomer];
}

#pragma mark - Set info customer
- (void)setupInfoNewCustomer {
    CGFloat height = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    self.scrollView.contentOffset = CGPointMake(0.f, height);
    NSString *name = [DataValidation isValidName:self.textFieldNameCustomer.text];
    NSString *phoneNumber = [DataValidation isValidPhoneNumber:(NSMutableString *)self.textFieldPhoneNumber.text];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    double registerDateTime = [_fromDate timeIntervalSince1970];
    double expityDateTime = [_toDate timeIntervalSince1970];
    double dateBirhtTime = [_dateOfBirth timeIntervalSinceNow];
    self.labelNotes.text = kNothingToUpdate;
    if (dateBirhtTime > currentTime) {
        self.labelNotes.text = kDateBirthTitle;
    } else if (registerDateTime > expityDateTime) {
        self.labelNotes.text = kFromDateToDateTitle;
    } else if (name) {
        self.labelNotes.text = kFillNames;
    } else if (phoneNumber) {
        self.labelNotes.text = phoneNumber;
    } else if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kFillAddresss;
    } else if (!_dateOfBirth) {
        self.labelNotes.text = kSelectDateOfBirths;
    } else if (!_fromDate) {
        self.labelNotes.text = kSelectFromDates;
    } else if (!_toDate) {
        self.labelNotes.text = kSelectToDates;
    } else if (!_imageAvatar) {
        self.labelNotes.text = kSelectImages;
    } else {
        Customer *customer;
        if ([self.messageEditCustomer isEqualToString:kMessageEditCustomer]) {
            customer = self.customer;
        } else {
            customer = [[Customer alloc] init];
        }
        customer.fullName = self.textFieldNameCustomer.text;
        customer.telNumber = self.textFieldPhoneNumber.text;
        customer.address = self.textFieldAddress.text;
        customer.birthday = _dateOfBirth;
        customer.registryDate = _fromDate;
        customer.expiryDate = _toDate;
        customer.avatar = _imageAvatar;
        CustomerManager *customerManager = [[CustomerManager alloc] init];
        customerManager.delegate = self;
        if (_modifier) {
            if ([self.messageEditCustomer isEqualToString:kMessageEditCustomer]) {
                [CustomLoadingView showInView:self.view];
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [customerManager updateTrainer:customer];
            
            } else {
                if (currentTime > registerDateTime || currentTime > expityDateTime) {
                    self.labelNotes.text = kDateRegisterAndExpityTitle;
                } else {
                    [CustomLoadingView showInView:self.view];
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    [customerManager createCustomer:customer];
                }
            }
        }
    }
}

#pragma mark - CustomerManagerDelegate 
- (void)createdCustomerWithMessage:(BOOL)success withError:(NSError *)error returnCustomer:(Customer *)customer {
    [CustomLoadingView hideLoadingInView:self.view];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _modifier = false;
    if (success) {
        NSDictionary *userInfo = @{@"newcustomer": customer};
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddNEwCustomerVCTitle object:nil userInfo:userInfo];
        self.labelNotes.text = kCreateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
    } else {
        self.labelNotes.text = kCreateFail;
        [AlertManager showAlertWithTitle:kReminderTitle message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

- (void)updateCustomerWithMessage:(BOOL)success withError:(NSError *)error returnCustomer:(Customer *)customer {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [CustomLoadingView hideLoadingInView:self.view];
    _modifier = false;
    if (success) {
        self.labelNotes.text = kUpdateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
        NSDictionary *userInfo = @{@"customer": customer};
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustomer object:nil userInfo:userInfo];
        if ([self.delegate respondsToSelector:@selector(updateCustomer:)]) {
            [self.delegate updateCustomer:customer];
        }
    } else {
        self.labelNotes.text = kUpdateFail;
        [AlertManager showAlertWithTitle:kRegisterRequest message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

#pragma mark - Implement all buttons
- (IBAction)buttonDateOfBirthPress:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _modifier = true;
        _dateOfBirth = dateSelected;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        [self.buttonDateOfBirth setTitle:[dateFormatter dateFormatterDateMonthYear:_dateOfBirth]
            forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

- (IBAction)buttonRegisterDatePress:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _modifier = true;
        _fromDate = dateSelected;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        [self.buttonRegisterDate setTitle:[dateFormatter dateFormatterDateMonthYear:_fromDate]
            forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

- (IBAction)buttonExpityDatePress:(id)sender {
    [self.view endEditing:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _modifier = true;
        _toDate = dateSelected;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        [self.buttonExpityDate setTitle:[dateFormatter dateFormatterDateMonthYear:_toDate]
            forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

@end
