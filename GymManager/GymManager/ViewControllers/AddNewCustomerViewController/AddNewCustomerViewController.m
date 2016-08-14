//
//  AddNewCustomerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddNewCustomerViewController.h"

NSString *const kMessageSelectTypeTitle = @"Select Type";
NSString *const kAcionChooseFromLibraryTtile = @"Choose from library";
NSString *const kAcionChooseFromCameraTtile = @"Choose from camera";
NSString *const kCancelButtonTitle = @"Cancel";
NSString *const kMessageNotFoundCamera = @"Not found camera";
NSString *const kOkActionTitle = @"Ok";
CGFloat const kCornerRadiusImageView = 40.0f;
CGFloat const kCornerRadiusViewBackground = 5.0f;

@interface AddNewCustomerViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

@end

@implementation AddNewCustomerViewController

#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    //TODO
    self.viewBackgroundCustomer.layer.cornerRadius = kCornerRadiusViewBackground;
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageView;
    self.imageViewCustomer.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    [self.imageViewCustomer addGestureRecognizer:tap];
    self.imageViewCustomer.userInteractionEnabled = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNewCustomer:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - UITapGestureRecognizer
- (IBAction)selectPhoto:(id)sender {
    [self showAlertController];
}

#pragma mark - Show alert controller
- (void)showAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kMessageSelectTypeTitle preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:kAcionChooseFromLibraryTtile style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromLibrary];
    }];
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:kAcionChooseFromCameraTtile style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:kCancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:chooseFromLibrary];
    [alertController addAction:chooseFromCamera];
    [alertController addAction:cancelButton];
    [self presentViewController:alertController animated:true completion:nil];
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
        UIAlertController *cameraErrorAlert = [UIAlertController alertControllerWithTitle:@"" message:kMessageNotFoundCamera preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cameraNotFound = [UIAlertAction actionWithTitle:kOkActionTitle style:UIAlertActionStyleDestructive handler:nil];
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
    //TODO
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGFloat x0 = self.imageViewCustomer.frame.size.width * 5.f;
    CGFloat y0 = self.imageViewCustomer.frame.size.height * 5.f;
    CGFloat x1 = chosenImage.size.width;
    CGFloat y1 = chosenImage.size.height;
    CGFloat x2 = 0.f;
    CGFloat y2 = 0.f;
    if (x1 > y1) {
        x2 = x0;
        y2 = (x2 * y1) / x1;
    } else {
        y2 = y0;
        x2 = (y2 * x1) / y1;
    }
    CGSize viewSize = CGSizeMake(x2, y2);
    UIGraphicsBeginImageContext(viewSize);
    [chosenImage drawInRect:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.imageViewCustomer.image = newImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Save new customer
- (IBAction)saveNewCustomer:(id)sender {
    //TODO
}

#pragma mark - Implement all buttons
- (IBAction)buttonDateOfBirthPress:(id)sender {
    //TODO
}

- (IBAction)buttonRegisterDatePress:(id)sender {
    //TODO
}

- (IBAction)buttonExpityDatePress:(id)sender {
    //TODO
}

@end
