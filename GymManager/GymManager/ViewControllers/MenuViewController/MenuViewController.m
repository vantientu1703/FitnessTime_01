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

typedef NS_ENUM(NSInteger, MenuDetailRows) {
    MenuDetailRowMyProfile,
    MenuDetailRowPTManager,
    MenuDetailRowCustomerManager,
    MenuDetailRowLogOut
};

NSString *const kMyProfileTitle = @"My Profile";
NSString *const kPTManagerTitle = @"PT Manager";
NSString *const kCustomerManagerTitle = @"Customer Manager";
NSString *const kLogoutTitle = @"Logout";
NSString *const kIconMyProfile = @"ic_myprofile";
NSString *const kIconPTManager = @"ic_ptmanager";
NSString *const kIconCustomerManager = @"ic_customer";
NSString *const kIconLogout = @"ic_logout";
NSInteger const kNumberOfRowsInSectionMenu = 4;
CGFloat const kHeightCellMenu = 50.0f;
static NSString *const kCellDefault = @"CellDefault";

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    MyProfileViewController *myProfileVC = [st
        instantiateViewControllerWithIdentifier:kMyProfileViewControllerIdentifier];
    switch (indexPath.row) {
        case MenuDetailRowMyProfile:
            [self.navigationController pushViewController:myProfileVC animated:true];
            break;
        case MenuDetailRowPTManager: {
            UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
            PTMeetingViewController *ptPTMeetingVC = [st
                instantiateViewControllerWithIdentifier:kPTMeetingViewControllerIdentifier];
            [self.navigationController pushViewController:ptPTMeetingVC animated:true];
            break;
        }
        case MenuDetailRowCustomerManager:
            //TODO
            break;
        case MenuDetailRowLogOut: {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate loadLoginViewController];
            break;
        }
        default:
            break;
    }
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
        case MenuDetailRowLogOut:
            return kIconLogout;
        default:
            return nil;
    }
}

@end
