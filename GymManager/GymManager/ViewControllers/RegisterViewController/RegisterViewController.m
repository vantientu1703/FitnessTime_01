//
//  RegisterViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterManager.h"

NSString *const kRegisterVCTitle = @"Register";

@interface RegisterViewController ()<UITextFieldDelegate, RegisterManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@end

@implementation RegisterViewController

#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.title = kRegisterVCTitle;
    self.textFieldAddress.delegate = self;
    self.textFieldConfirmPassword.delegate = self;
    self.textFieldDateOfBirth.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldPassword.delegate = self;
    self.textFieldUserName.delegate = self;
}

#pragma mark - Register
- (IBAction)registerPress:(id)sender {
    //TODO
}

- (void)doRegister {
    User *user = [self setUser];
    RegisterManager *registerManager = [[RegisterManager alloc] init];
    registerManager.delegate = self;
    [registerManager doRegisterWithUser:user];
}

- (User *)setUser {
    User *user = [[User alloc] init];
    return user;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - RegisterManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnUser:(User *)user {
    //TODO
}

@end
