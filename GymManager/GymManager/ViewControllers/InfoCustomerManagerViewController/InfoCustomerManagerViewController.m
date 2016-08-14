//
//  InfoCustomerManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "InfoCustomerManagerViewController.h"
#import "AddNewCustomerViewController.h"

CGFloat const kCornerRadiusViewBackgroundCustomer = 5.0f;
CGFloat const kCornerRadiusImageViewCustomers = 40.0f;

@interface InfoCustomerManagerViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewBackgroudInfoCustomer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelDateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelRegisterDate;
@property (weak, nonatomic) IBOutlet UILabel *labelExprityDate;

@end

@implementation InfoCustomerManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

#pragma mark - Setup view
- (void)setupView {
    self.viewBackgroudInfoCustomer.layer.cornerRadius = kCornerRadiusViewBackgroundCustomer;
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageViewCustomers;
    self.imageViewCustomer.layer.masksToBounds = YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPress:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

#pragma mark - Edit button
- (IBAction)editButtonPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    AddNewCustomerViewController *addNewCustomerVC = [st instantiateViewControllerWithIdentifier:kAddNewCustomerViewControllerIdentifier];
    addNewCustomerVC.messageEditCustomer = kMessageEditCustomer;
    [self.navigationController pushViewController:addNewCustomerVC animated:true];
}

@end
