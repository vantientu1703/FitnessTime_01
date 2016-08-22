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

NSString *const kLoginVCTitle = @"Login";

@interface LoginViewController ()<UITextFieldDelegate, LoginManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldPassword.delegate = self;
    self.textFieldUserName.delegate = self;
    self.title = kLoginVCTitle;
}

#pragma mark - Login
- (IBAction)loginPress:(id)sender {
    [self doLogin];
}

- (void)doLogin {
    LoginManager *loginManager = [[LoginManager alloc] init];
    loginManager.delegate = self;
    [loginManager doLoginWithEmail:self.textFieldUserName.text password:self.textFieldPassword.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}

#pragma mark - Register
- (IBAction)registerPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    RegisterViewController *registerVC = [st instantiateViewControllerWithIdentifier:kRegisterViewControllerIdentifier];
    [self.navigationController pushViewController:registerVC animated:true];
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
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message
            viewControler:self reloadAction:^{
            [self doLogin];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate loadTabbarController];
    }
}
@end
