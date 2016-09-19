//
//  RegisterViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterManager.h"
#import "DataValidation.h"
#import "AppDelegate.h"

NSString *const kRegisterVCTitle = @"Register";
NSString *const kIsNoSelectedDate = @"No select date of birth";
NSString *const kRegisterSuccess = @"Register success";
NSString *const kFillAddress = @"Fill address";

@interface RegisterViewController ()<UITextFieldDelegate, RegisterManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelecDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UIView *viewContainButtonSelectDate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterViewController
{
    BOOL _isSelectedDate;
    NSDate *_dateOfBirth;
}
#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    if (!_dateOfBirth) {
        [self.buttonSelecDateOfBirth setTitle:kSelectDate forState:UIControlStateNormal];
    }
    self.viewContainButtonSelectDate.layer.cornerRadius = kCornerRadiusViewBackground;
    self.navigationController.navigationBar.barTintColor = [UIColor
        colorWithPatternImage:[UIImage imageNamed:@"1_gym_view_bg.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
        setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPress:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.title = kRegisterVCTitle;
    self.textFieldAddress.delegate = self;
    self.textFieldConfirmPassword.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldPassword.delegate = self;
    self.textFieldUserName.delegate = self;
}

#pragma mark - Register
- (IBAction)registerPress:(id)sender {
    [self doRegister];
}

- (void)doRegister {
    User *user = [self setUser];
    RegisterManager *registerManager = [[RegisterManager alloc] init];
    registerManager.delegate = self;
    if (user) {
        [registerManager doRegisterWithUser:user];
    }
}

- (IBAction)cancelPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (User *)setUser {
    CGFloat height = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    self.scrollView.contentOffset = CGPointMake(0.0f, height);
    User *user = [[User alloc] init];
    NSString *isValidEmail = [DataValidation isValidEmailAddress:self.textFieldEmail.text];
    NSString *isConfirmPassword = [DataValidation isValidConfirmedPassword:self.textFieldConfirmPassword.text
        password:self.textFieldPassword.text];
    NSString *isValidPassword = [DataValidation isValidPassword:self.textFieldPassword.text];
    NSString *isValidName = [DataValidation isValidName:self.textFieldUserName.text];
    if (isConfirmPassword) {
        self.labelNotes.text = isConfirmPassword;
        return nil;
    } else if (isValidEmail) {
        self.labelNotes.text = isValidEmail;
        return nil;
    } else if (isValidName) {
        self.labelNotes.text = isValidName;
        return nil;
    } else if (isValidPassword) {
        self.labelNotes.text = isValidPassword;
        return nil;
    } else if (!_isSelectedDate) {
        self.labelNotes.text = kIsNoSelectedDate;
        return nil;
    } else if (!self.textFieldAddress.text.length) {
        self.labelNotes.text = kFillAddress;
        return nil;
    } else {
        self.labelNotes.text = @"";
        [self.view endEditing:YES];
        self.buttonRegister.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        user.fullName = self.textFieldUserName.text;
        user.email = self.textFieldEmail.text;
        user.address = self.textFieldAddress.text;
        user.birthday = _dateOfBirth;
        user.password = self.textFieldPassword.text;
        return user;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - RegisterManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnUser:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    self.buttonRegister.enabled = YES;
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message
            viewControler:self reloadAction:^{
            [self doRegister];
        }];
    } else {
        [[DataStore sharedDataStore] setNewUserManagefromUser:user WithCompletionblock:^(BOOL success) {
            if (success) {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate loadTabbarController];
            } else {
                [AlertManager showAlertWithTitle:kReminderTitle message:error.localizedDescription
                    viewControler:self okAction:^{
                }];
            }
        }];
    }
}

#pragma mark - Button select date of birth
- (IBAction)buttonDateOfBirthPress:(id)sender {
    [self showCalendar];
}

- (IBAction)calendarPress:(id)sender {
    [self showCalendar];
}

- (void)showCalendar {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [self.navigationController pushViewController:calendarVC animated:true];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _isSelectedDate = true;
        _dateOfBirth = dateSelected;
        DateFormatter *dateFormatter = [[DateFormatter alloc] init];
        NSString *dateString = [dateFormatter dateFormatterDateMonthYear:_dateOfBirth];
        [self.buttonSelecDateOfBirth setTitle:dateString forState:UIControlStateNormal];
    }];
}

@end
