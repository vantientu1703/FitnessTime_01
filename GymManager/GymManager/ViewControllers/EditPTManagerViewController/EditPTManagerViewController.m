//
//  EditPTManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "EditPTManagerViewController.h"

CGFloat const kCornerRadiusImageViewPTEdit = 50.0f;
NSString *const kNoFillAddressTitle  = @"Fill address,please!";
NSString *const kNoFillEmailTitle = @"Fill email,please!";
NSString *const kNoFillFullNameTitle = @"Fill full name,please!";
NSString *const kNoFillPhoneNumberTitle = @"Fill phone number,please";
NSString *const kNoFillIncomShifTitle = @"Fill income per shif,please!";

@interface EditPTManagerViewController ()<AlertManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPT;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFiledIncomeShif;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@end

@implementation EditPTManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

#pragma mark - Set up view
- (void)setupView {
    //TODO
    self.imageViewPT.layer.cornerRadius = kCornerRadiusImageViewPTEdit;
    self.imageViewPT.layer.masksToBounds = true;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(savePTInfo:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Done button
- (IBAction)savePTInfo:(id)sender {
    //TODO
    if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kNoFillAddressTitle;
    } else if (!self.textFieldEmail.text.length) {
        self.labelNotes.text = kNoFillEmailTitle;
    } else if (!self.textFieldFullName.text.length) {
        self.labelNotes.text = kNoFillFullNameTitle;
    } else if (!self.textFieldPhoneNumber.text.length) {
        self.labelNotes.text = kNoFillPhoneNumberTitle;
    } else if (!self.textFiledIncomeShif.text.length) {
        self.labelNotes.text = kNoFillIncomShifTitle;
    } else {
        //TODO
    }
}

#pragma mark - Button select date
- (IBAction)buttonSelectDatePress:(id)sender {
    //TODO
    CalendarViewController *calendarVC = [[CalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:true];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        //TODO
    }];
}

#pragma mark - Update avatar
- (IBAction)buttonUpdateProfilePress:(id)sender {
    //TODO
    AlertManager *alertManager = [[AlertManager alloc] init];
    alertManager.delegate = self;
    [alertManager showChooseImageAlertWithTitle:kReminderTitle
        message:kMessageReminder vieController:self];
}

#pragma mark - AlertManagerDelegate
- (void)imagePickerController:(UIImagePickerController *)imagePickerController {
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //TODO
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    CGSize size = CGSizeMake(self.imageViewPT.bounds.size.width, self.imageViewPT.bounds.size.height);
    UIImage *newImage = [Utils convertImageToThumbnailImage:chosenImage withSize:size];
    self.imageViewPT.image = newImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
