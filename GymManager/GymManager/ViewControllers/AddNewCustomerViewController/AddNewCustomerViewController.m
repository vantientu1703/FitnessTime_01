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

NSString *const kAddNEwCustomerVCTitle = @"Add new customer";
NSString *const kMessageSelectTypeTitle = @"Select Type";
NSString *const kAcionChooseFromLibraryTtile = @"Choose from library";
NSString *const kAcionChooseFromCameraTtile = @"Choose from camera";
NSString *const kCancelButtonTitle = @"Cancel";
NSString *const kMessageNotFoundCamera = @"Not found camera";
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
    self.title = kAddNEwCustomerVCTitle;
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
    //TODO
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGFloat x0 = self.imageViewCustomer.frame.size.width;
    CGFloat y0 = self.imageViewCustomer.frame.size.height;
    CGSize viewSize = CGSizeMake(x0, y0);
    UIImage *newImage = [Utils convertImageToThumbnailImage:chosenImage withSize:viewSize];
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
