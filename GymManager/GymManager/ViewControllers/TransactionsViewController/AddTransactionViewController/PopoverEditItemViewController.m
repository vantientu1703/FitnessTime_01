//
//  PopoverEditItemViewController.m
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PopoverEditItemViewController.h"

@interface PopoverEditItemViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (copy, nonatomic) void(^completionBlock)(Item *item);

@end

@implementation PopoverEditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(didTapBackGround)];
    [self.viewBackGround addGestureRecognizer:tap];
    if (self.item) {
        self.lbName.text = self.item.name;
        self.lbPrice.value = self.item.price;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSave:(id)sender {
    if (self.item) {
        if ([self itemIsChanged]) {
            [self updateItem];
        }
    } else {
        self.item = [[Item alloc] init];
        [self updateItem];
    }
    [self didTapBackGround];
}

- (BOOL)itemIsChanged {
    if (![self.lbName.text isEqualToString:self.item.name] || self.lbPrice.value != self.item.price) {
        return YES;
    }
    return NO;
}

- (void)updateItem {
    self.item.name = self.lbName.text;
    self.item.price = self.lbPrice.value;
    self.completionBlock(self.item);
}

- (IBAction)btnCancelClick:(id)sender {
    [self didTapBackGround];
}

#pragma mark - Action handler
- (void)didTapBackGround {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Block assgin
- (void)didEditItemWithCompletionBlock:(void(^)(Item *item))block {
    self.completionBlock = block;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
