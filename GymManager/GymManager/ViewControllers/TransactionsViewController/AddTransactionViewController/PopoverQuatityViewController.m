//
//  PopoverQuatityViewController.m
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PopoverQuatityViewController.h"

@interface PopoverQuatityViewController () <UITextFieldDelegate>

@property (nonatomic) NSUInteger currentQuantity;
@property (copy, nonatomic) void(^completionBlock)(NSUInteger quantity);

@end

@implementation PopoverQuatityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(didTapBackGround)];
    [self.viewBackGround addGestureRecognizer:tap];
    self.txtFieldQuantity.delegate = self;
    [self.txtFieldQuantity addTarget:self action:@selector(textFieldDidChange) forControlEvents:
        UIControlEventEditingChanged];
    self.currentQuantity = 0;
    self.txtFieldQuantity.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.currentQuantity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield handler
- (void)updateQuantity {
    self.txtFieldQuantity.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.currentQuantity];
}

- (void)textFieldDidChange {
    self.currentQuantity = [self.txtFieldQuantity.text integerValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //if text length more than 3 digits, return No
    if (range.location + textField.text.length > 3) {
        return NO;
    }
    return YES;
}

#pragma mark - Action handler
- (void)didTapBackGround {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnIncreaseClick:(id)sender {
    //Quantity can't be more than 99.
    if (self.currentQuantity < 99) {
        self.currentQuantity += 1;
        [self updateQuantity];
    }
}

- (IBAction)btnDecreaseClick:(id)sender {
    //if current value is 0, can't decrease 
    if (self.currentQuantity > 0) {
        self.currentQuantity -= 1;
        [self updateQuantity];
    }
}

- (IBAction)btnSubmitClick:(id)sender {
    self.completionBlock(self.currentQuantity);
    [self didTapBackGround];
}

- (IBAction)btnCancelClick:(id)sender {
    [self didTapBackGround];
}

#pragma mark - Block callback
- (void)didEnterQuantityWithCompletionBlock:(void(^)(NSUInteger quantity))block {
    self.completionBlock = block;
}

@end
