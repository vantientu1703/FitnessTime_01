//
//  ShareFBViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ShareFBViewController.h"
#import "PhototShareManagerViewController.h"

NSString *const kShareWithFB = @"Share with facebook";
NSInteger const kLabelTag = 100000;

@interface ShareFBViewController ()<UITextFieldDelegate, QBImagePickerControllerDelegate, FBSDKSharingDelegate, AlertManagerDelegate, UIImagePickerControllerDelegate, PhototShareManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatarFB;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak, nonatomic) IBOutlet UIView *imageShareFB;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *arrImages;
@property (strong, nonatomic) UIView *detailView;

@end

@implementation ShareFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    self.buttonShare.layer.cornerRadius = kCornerRadiusViewBackground;
    self.textFieldTitle.delegate = self;
    self.title = kShareWithFB;
}

- (void)setupView {
    NSURL *url = [NSURL URLWithString:self.user.avatar];
    self.labelName.text = self.user.fullName;
    [self.imageViewAvatarFB sd_setImageWithURL:url
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewAvatarFB.image = [UIImageConstant imageUserConstant];
        }
    }];
    UITapGestureRecognizer *tap = [self tapGestureReccognizer];
    [self.imageShareFB addGestureRecognizer:tap];
    self.imageShareFB.userInteractionEnabled = YES;
}

- (UITapGestureRecognizer *)tapGestureReccognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImages:)];
    return tap;
}

- (IBAction)selectImages:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kShareStoryboard bundle:nil];
    PhototShareManagerViewController *photoShareManagerVC = [st
        instantiateViewControllerWithIdentifier:kPhototShareManagerViewControllerIdentifier];
    photoShareManagerVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoShareManagerVC];
    [self presentViewController:nav animated:true completion:nil];
}

#pragma mark - PhototShareManagerViewControllerDelehate
- (void)fillImageToViewWithArrayImages:(NSArray *)images {
    if (images.count) {
        self.arrImages = (NSMutableArray *)images;
        [self openImageViewWithIndex:images.count images:images];
    }
}

#pragma mark - AlertManagerDelegate
- (void)showQBImagePikcerController:(QBImagePickerController *)qbImagePickerController {
    qbImagePickerController.delegate = self;
    qbImagePickerController.allowsMultipleSelection = YES;
    qbImagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:qbImagePickerController animated:YES completion:NULL];
}

- (IBAction)sharePress:(id)sender {
    // Post album into facebook
    if (self.arrImages.count) {
        if (self.arrImages.count > 1) {
            [FacebookService shareImages:self.arrImages withViewController:self];
        } else {
            [FacebookService shareImage:self.arrImages[0] message:self.textFieldTitle.text withViewController:self];
        }
    }
}

- (IBAction)logoutFBPress:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)openImageViewWithIndex:(NSInteger)count images:(NSArray *)images {
    NSArray *arrObjects = [[NSBundle mainBundle] loadNibNamed:@"DisplayImageView" owner:self options:nil];
    // total view in xib
    if (count > 5) {
        count = 5;
    }
    if (self.detailView) {
        [self.detailView removeFromSuperview];
        self.detailView = nil;
    }
    // index view from 0 to 4
    self.detailView = arrObjects[count - 1];
    self.detailView.frame = self.imageShareFB.frame;
    [self.scrollView addSubview:self.detailView];
    UITapGestureRecognizer *tap = [self tapGestureReccognizer];
    [self.detailView addGestureRecognizer:tap];
    self.detailView.userInteractionEnabled = YES;
    [self showImagesWithView:self.detailView images:self.arrImages];
}

- (void)showImagesWithView:(UIView *)view images:(NSArray *)images {
    NSInteger count = images.count;
    for (NSInteger i = 1; i <= count; i++) {
        UIView *detailView = [view viewWithTag:i];
        if (detailView && [detailView isMemberOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)detailView;
            imageView.image = [Utils convertImageToThumbnailImage:images[i -1] withSize:imageView.bounds.size];
        }
    }
    // If total images than more five
    UIView *labelView = [view viewWithTag:kLabelTag];
    if (labelView && [labelView isMemberOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)labelView;
        if (count > 5) {
            label.text = [NSString stringWithFormat:@"+%ld", (count - 4)];
            label.hidden = NO;
        } else {
            label.hidden = YES;
        }
    }
}

@end
