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

@interface MyProfileViewController ()<EditMyProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMyProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UILabel *labelDateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (strong, nonatomic) User *user;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupProfile];
}

- (void)setupProfile {
    DateFormatter *dateFormatter = [[DateFormatter alloc] init];
    self.user = (User *)[[DataStore sharedDataStore] getUserManage];
    self.labelFullName.text = self.user.fullName;
    self.labelEmail.text = self.user.email;
    self.labelDateOfBirth.text = [dateFormatter
        dateFormatterDateMonthYear:self.user.birthday];
    self.labelAddress.text = self.user.address;
    self.labelPhoneNumber.text = self.user.telNumber;
    NSURL *url = self.user.avatarURL;
    [self.imageViewMyProfile sd_setImageWithURL:url
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewMyProfile.image = [UIImageConstant imageUserConstant];
        }
    }];
}

#pragma mark - Setup view
- (void)setupView {
    self.title = kMyProfileTitle;
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
    editMyProfileVC.user = self.user;
    editMyProfileVC.delegate = self;
    [self.navigationController pushViewController:editMyProfileVC animated:true];
}

#pragma mark - EditProfileViewControlerDelegate
- (void)updateUser:(User *)user {
    self.user = user;
    [self setupProfile];
}

@end
