//
//  MenuViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "MenuViewController.h"
#import "MyProfileViewController.h"
#import "PTMeetingViewController.h"
#import "AppDelegate.h"
#import "CustomerManagerViewController.h"
#import "CategoryViewController.h"
#import "PTManagerViewController.h"

typedef NS_ENUM(NSInteger, MenuDetailRows) {
    MenuDetailRowMyProfile,
    MenuDetailRowPTManager,
    MenuDetailRowCustomerManager,
    MenuDetailRowCategory,
    MenuDetailRowLogOut
};

NSString *const kPTManagerTitle = @"PT Manager";
NSString *const kLogoutTitle = @"Logout";
NSString *const kCategoryTitle = @"Category";
NSString *const kIconMyProfile = @"ic_myprofile";
NSString *const kIconPTManager = @"ic_ptmanager";
NSString *const kIconCustomerManager = @"ic_customer";
NSString *const kIconLogout = @"ic_logout";
NSString *const kIconCategory = @"ic_category";
NSInteger const kNumberOfRowsInSectionMenu = 5;
CGFloat const kHeightCellMenu = 50.0f;
static NSString *const kCellDefault = @"CellDefault";

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate, ProfileManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MyProfileViewController *myProfileVC;
@property (strong, nonatomic) PTMeetingViewController *ptPTMeetingVC;
@property (strong, nonatomic) CustomerManagerViewController *customerManagerVC;
@property (strong, nonatomic) PTManagerViewController *ptManagerVC;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsInSectionMenu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellDefault];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault];
    }
    cell.imageView.image = [UIImage imageNamed:[self cellWithImage:indexPath.row]];
    cell.textLabel.text = [self cellWithTitle:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightCellMenu;
}

#pragma mark - UITableViewDataSources
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    UIStoryboard *customerManagerStoryboard = [UIStoryboard
        storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    switch (indexPath.row) {
        case MenuDetailRowMyProfile: {
            if (!self.myProfileVC) {
                self.myProfileVC = [st
                    instantiateViewControllerWithIdentifier:kMyProfileViewControllerIdentifier];
            }
            [self.navigationController pushViewController:self.myProfileVC animated:true];
            break;
        }
        case MenuDetailRowPTManager: {
            UIStoryboard *ptManagerST = [UIStoryboard storyboardWithName:kPTManagerStoryboardIdentifier bundle:nil];
            if (!self.ptManagerVC) {
                self.ptManagerVC = [ptManagerST
                    instantiateViewControllerWithIdentifier:kPTManagerViewControllerIdentifier];
            }
            [self.navigationController pushViewController:self.ptManagerVC animated:true];
            break;
        }
        case MenuDetailRowCustomerManager: {
            if (!self.customerManagerVC) {
                self.customerManagerVC = [customerManagerStoryboard
                    instantiateViewControllerWithIdentifier:kCustomerManagerViewControllerIdentifier];
            }
            self.customerManagerVC.statusCustomerManagerTitle = kCustomerManagerVCTitle;
            [self.navigationController pushViewController:self.customerManagerVC animated:true];
            break;
        }
        case MenuDetailRowCategory: {
            CategoryViewController *categoryVC = [customerManagerStoryboard
                instantiateViewControllerWithIdentifier:kCategoryViewControllerIdentifier];
            [self.navigationController pushViewController:categoryVC animated:true];
            break;
        }
        case MenuDetailRowLogOut: {
            ProfileManager *profileManager = [[ProfileManager alloc] init];
            profileManager.delegate = self;
            [profileManager logout];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate loadLoginViewController];
            [[DataStore sharedDataStore] clearUser];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ProfileManagerDelegate 
- (void)logoutSuccess:(BOOL)success error:(NSError *)error {
    //TODO
}

#pragma mark - Set title for cell
- (NSString *)cellWithTitle:(NSInteger)index {
    switch (index) {
        case MenuDetailRowMyProfile:
            return kMyProfileTitle;
        case MenuDetailRowPTManager:
            return kPTManagerTitle;
        case MenuDetailRowCustomerManager:
            return kCustomerManagerTitle;
        case MenuDetailRowCategory:
            return kCategoryTitle;
        case MenuDetailRowLogOut:
            return kLogoutTitle;
        default:
            return nil;
    }
}

#pragma mark - Set image for cell
- (NSString *)cellWithImage:(NSInteger)index {
    switch (index) {
        case MenuDetailRowMyProfile:
            return kIconMyProfile;
        case MenuDetailRowPTManager:
            return kIconPTManager;
        case MenuDetailRowCustomerManager:
            return kIconCustomerManager;
        case MenuDetailRowCategory:
            return kIconCategory;
        case MenuDetailRowLogOut:
            return kIconLogout;
        default:
            return nil;
    }
}

@end
