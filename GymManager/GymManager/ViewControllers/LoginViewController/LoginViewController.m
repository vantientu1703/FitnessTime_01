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

NSString *const kLoginVCTitle = @"Login";

@interface LoginViewController ()<UITextFieldDelegate>

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

- (IBAction)loginPress:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSetRootViewWindowTitle object:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate loadTabbarController];
}

- (IBAction)registerPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    RegisterViewController *registerVC = [st instantiateViewControllerWithIdentifier:kRegisterViewControllerIdentifier];
    [self.navigationController pushViewController:registerVC animated:true];}

- (IBAction)forgetPasswordPress:(id)sender {
    //TODO
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
