//
//  RegisterViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "RegisterViewController.h"

NSString *const kRegisterVCTitle = @"Register";

@interface RegisterViewController ()<UITextFieldDelegate>

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
    self.textFieldAddress.delegate = self;
    self.textFieldConfirmPassword.delegate = self;
    self.textFieldDateOfBirth.delegate = self;
    self.textFieldEmail.delegate = self;
    self.textFieldPassword.delegate = self;
    self.textFieldUserName.delegate = self;
    [self setupView];
}

- (void)setupView {
    self.title = kRegisterVCTitle;
}

- (IBAction)registerPress:(id)sender {
    //TODO
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
