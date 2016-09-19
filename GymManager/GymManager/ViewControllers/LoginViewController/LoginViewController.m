//
//  LoginViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "LoginViewController.h"
#import "PTMeetingViewController.h"
#import "TransactionsViewController.h"
#import "MenuViewController.h"
#import "TodayMeetingsViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "LoginManager.h"
#import "DataStore.h"

NSString *const kLoginVCTitle = @"Login";
NSString *const kEmailError = @"Email incorrect";
NSString *const kPasswordError = @"Password incorrect";
NSString *const kErrorEmailOrPassword = @"Incorrect email or password";

@interface LoginViewController ()<UITextFieldDelegate, LoginManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (weak, nonatomic) IBOutlet UIView *buttonLoginWithFB;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldPassword.delegate = self;
    self.textFieldUserName.delegate = self;
    self.buttonLoginWithFB.layer.cornerRadius = kCornerRadiusViewBackground;
}

#pragma mark - Login
- (IBAction)loginPress:(id)sender {
    [self.view endEditing:true];
    [self doLogin];
}

- (IBAction)loginWithFBPress:(id)sender {
    __block LoginViewController *weakSelf = self;
    [FacebookService login:self completion:^(NSDictionary *userData) {
        if (userData) {
            [[DataStore sharedDataStore] setUserLoginWithFB:userData];
            [weakSelf login];
        }
    }];
}

- (void)login {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate loadTabbarController];
}

- (void)doLogin {
    LoginManager *loginManager = [[LoginManager alloc] init];
    loginManager.delegate = self;
    NSString *emailLogin = [DataValidation replaceSpaceInEmail:(NSMutableString *)self.textFieldUserName.text];
    NSString *email;
    if (emailLogin) {
        email = [DataValidation isValidEmailAddress:emailLogin];
    }
    NSString *passWord = [DataValidation isValidPassword:self.textFieldPassword.text];
    if (email) {
        self.labelNotes.text = email;
    } else if (passWord) {
        self.labelNotes.text = passWord;
    } else {
        [loginManager doLoginWithEmail:emailLogin password:self.textFieldPassword.text];
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
    }
}

#pragma mark - Register
- (IBAction)registerPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    RegisterViewController *registerVC = [st instantiateViewControllerWithIdentifier:kRegisterViewControllerIdentifier];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction)forgetPasswordPress:(id)sender {
    //TODO
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doLogin];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - LoginManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnUser:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message
            viewControler:self okAction:^{
            self.labelNotes.text = @"";
        }];
    } else {
        self.labelNotes.text = @"";
        [[DataStore sharedDataStore] setNewUserManagefromUser:user WithCompletionblock:^(BOOL success) {
            if (success) {
                [self login];
            } else {
                [AlertManager showAlertWithTitle:kReminderTitle message:kMessageFailLogin
                    viewControler:self reloadAction:^{
                    [self doLogin];
                }];
            }
        }];
    }
}

- (IBAction)tapBackground:(id)sender {
    [self.view endEditing:YES];
}

@end
