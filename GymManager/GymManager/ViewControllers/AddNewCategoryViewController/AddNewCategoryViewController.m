//
//  AddNewCategoryViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddNewCategoryViewController.h"

@interface AddNewCategoryViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldNameCategory;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPriceCategory;
@property (weak, nonatomic) IBOutlet UIButton *buttonCreateNewCategory;

@end

@implementation AddNewCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldNameCategory.delegate = self;
    self.textFieldPriceCategory.delegate = self;
    [self.textFieldNameCategory becomeFirstResponder];
}

- (IBAction)createButtonPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(createNewCategory:)]) {
        //TODO
        [self.delegate createNewCategory:nil];
    }
}

- (IBAction)closeButtonPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeAddNewCategoryVCFromParentViewController)]) {
        [self.delegate removeAddNewCategoryVCFromParentViewController];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
