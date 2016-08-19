//
//  MyProfileViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "MyProfileViewController.h"
#import "EditMyProfileViewController.h"

CGFloat const kCornerRadiusProfile = 50.0f;

@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMyProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UILabel *labelDateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Setup view
- (void)setupView {
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
        target:self action:@selector(editMyProfilePress:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.imageViewMyProfile.layer.cornerRadius = kCornerRadiusProfile;
    self.imageViewMyProfile.layer.masksToBounds = YES;
}

- (IBAction)editMyProfilePress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    EditMyProfileViewController *editMyProfileVC = [st
        instantiateViewControllerWithIdentifier:kEditMyProfileViewControllerIdentifier];
    [self.navigationController pushViewController:editMyProfileVC animated:true];
}

@end
