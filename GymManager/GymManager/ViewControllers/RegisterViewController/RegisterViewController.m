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
    DateFormatter *dateFommater = [[DateFormatter alloc] init];
    NSString *dateString = [dateFommater dateFormatterDateMonthYear:[NSDate date]];
    self.title = kRegisterVCTitle;
    self.textFieldAddress.delegate = self;
    self.textFieldConfirmPassword.delegate = self;
    [self.buttonSelecDateOfBirth setTitle:dateString forState:UIControlStateNormal];
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

- (User *)setUser {
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
        user.userName = self.textFieldUserName.text;
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
    //TODO
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message
            viewControler:self reloadAction:^{
            [self doRegister];
        }];
    } else {
        self.labelNotes.text = kRegisterSuccess;
    }
}

#pragma mark - Button select date of birth
- (IBAction)buttonDateOfBirthPress:(id)sender {
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
