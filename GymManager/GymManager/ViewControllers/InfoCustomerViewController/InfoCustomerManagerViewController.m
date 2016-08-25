//
//  InfoCustomerManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "InfoCustomerManagerViewController.h"
#import "AddNewCustomerViewController.h"

NSString *const kInfoCustomerVCTitle = @"Info customer";
CGFloat const kCornerRadiusViewBackgroundCustomer = 5.0f;
CGFloat const kCornerRadiusImageViewCustomers = 40.0f;
NSString *const kEdiCustomerTitle = @"Edit customer";

@interface InfoCustomerManagerViewController ()<AddNewCustomerViewControllerDelegate>

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
    [self setupInfoCustomer];
}

- (void)setupInfoCustomer {
    self.labelAddress.text = self.customer.address;
    self.labelDateOfBirth.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:self.customer.birthday];
    self.labelExprityDate.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:self.customer.expiryDate];
    self.labelNameCustomer.text = self.customer.fullName;
    self.labelPhoneNumber.text = self.customer.telNumber;
    self.labelRegisterDate.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:self.customer.registryDate];
}

#pragma mark - Setup view
- (void)setupView {
    //TODO
    self.title = kInfoCustomerVCTitle;
    self.viewBackgroudInfoCustomer.layer.cornerRadius = kCornerRadiusViewBackgroundCustomer;
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageViewCustomers;
    self.imageViewCustomer.layer.masksToBounds = YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self
        action:@selector(editButtonPress:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

#pragma mark - Edit button
- (IBAction)editButtonPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    AddNewCustomerViewController *addNewCustomerVC = [st
        instantiateViewControllerWithIdentifier:kAddNewCustomerViewControllerIdentifier];
    addNewCustomerVC.messageEditCustomer = kMessageEditCustomer;
    addNewCustomerVC.customer = self.customer;
    addNewCustomerVC.delegate = self;
    [self.navigationController pushViewController:addNewCustomerVC animated:true];
}

#pragma mark - AddNewCustomerViewControllerDelegate
- (void)updateCustomer:(Customer *)customer {
    self.customer = customer;
    [self setupInfoCustomer];
    if ([self.delegate respondsToSelector:@selector(reloadDataCustomers:)]) {
        [self.delegate reloadDataCustomers:customer];
    }
}

@end
