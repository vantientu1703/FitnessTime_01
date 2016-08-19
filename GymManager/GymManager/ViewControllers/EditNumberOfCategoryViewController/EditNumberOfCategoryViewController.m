//
//  EditNumberOfCategoryViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "EditNumberOfCategoryViewController.h"

@interface EditNumberOfCategoryViewController ()<UITextFieldDelegate>

@end

@implementation EditNumberOfCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldNumberOfCategory.delegate = self;
    self.textFieldNumberOfCategory.keyboardType = UIKeyboardTypeNumberPad;
    [self.textFieldNumberOfCategory becomeFirstResponder];
}

- (IBAction)okButtonPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setNumberOfCategory:)]) {
        [self.delegate setNumberOfCategory:self.textFieldNumberOfCategory.text.integerValue];
    }
}

- (IBAction)cancelButtonPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeEditVCFromParentViewController)]) {
        [self.delegate removeEditVCFromParentViewController];
    }
}

- (IBAction)increaseButtonPress:(id)sender {
    NSInteger i = self.textFieldNumberOfCategory.text.integerValue;
    i++;
    self.textFieldNumberOfCategory.text = [NSString stringWithFormat:@"%ld", i];
}

- (IBAction)decreaseButtonPress:(id)sender {
    NSInteger i = self.textFieldNumberOfCategory.text.integerValue;
    if (i > 0) {
        i--;
        self.textFieldNumberOfCategory.text = [NSString stringWithFormat:@"%ld", i];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
