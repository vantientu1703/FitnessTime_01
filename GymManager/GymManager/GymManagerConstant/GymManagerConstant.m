//
//  GymManagerConstant.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "GymManagerConstant.h"

@implementation GymManagerConstant

NSString *const kNameStoryboard = @"Main";
NSString *const kNameStoryboardTransaction = @"Transaction";
NSString *const kLoginViewControllerIdentifier = @"LoginViewController";
NSString *const kTodayViewControllerTitle = @"Today";
NSString *const kPTMeetingViewControllerTitle = @"Meetings";
NSString *const kTransactionsViewControllerTitle = @"Transactions";
NSString *const kMenuViewControllerTitle = @"Menu";
NSString *const kRegisterViewControllerIdentifier = @"RegisterViewController";
NSString *const kNotificationSetRootViewWindowTitle = @"Set root view window";
const CGFloat kTableViewCellHeight = 40.0;
const CGFloat kTableViewHeaderHeight = 90.0;
NSString *const kTransactionCellIndentifier = @"CategoryCell";
NSString *const kTodayMeetinViewControllerIdentifier = @"TodayMeetingsViewController";
NSString *const kIconCalendar = @"ic_calendar";
NSString *const kEditActionTitle = @"Edit";
NSString *const kDeleteActionTitle = @"Delete";
NSString *const kReminderTitle = @"Reminder";
NSString *const kMessageReminder = @"Are you make sure delete?";
NSString *const kOkActionTitle = @"Ok";
NSString *const kCancelActionTitle = @"Cancel";
CGFloat const kCornerRadiusButton = 20.0f;
NSString *const kPTMeetingViewControllerIdentifier = @"PTMeetingViewController";
NSString *const kPTManagerViewControllerIdentifier = @"PTManagerViewController";
NSString *const kMeetingDetailViewControllerIdentifier = @"MeetingDetailViewController";
NSString *const kStatusAddNewMeeting = @"status add new meeting";
NSString *const kStatusViewMeetingDetail = @"status view meeting detail";
NSString *const kMenuViewControllerIdentifier = @"MenuViewController";
NSString *const kMyProfileViewControllerIdentifier = @"MyProfileViewController";
NSString *const kEditMyProfileViewControllerIdentifier = @"EditMyProfileViewController";
NSString *const kChoosenTypeTitle = @"Choosen type";
NSString *const kChoseFromLibraryTitle = @"Choose from library";
NSString *const kChoseFromCameraTitle = @"Choose from camera";
NSString *const kCancelTitle = @"Cancel";
NSString *const kNotFoundCamera = @"Not found camera";
NSString *const kOkTitle = @"Ok";
NSString *const kCustomerManagerStoryboard = @"CustomerManagerStoryboard";
NSString *const kCustomerManagerViewControllerIdentifier = @"CustomerManagerViewController";
NSString *const kAddNewCustomerViewControllerIdentifier = @"AddNewCustomerViewController";
NSString *const kMessageEditCustomer = @"Edit customer";
NSString *const kIconUser = @"ic_user";
NSString *const kCustomerManagerTitle = @"Customer Manager";
NSString *const kInfoCustomerManagerViewControllerIdentifier = @"InfoCustomerManagerViewController";
CGFloat const kCornerRadiusViewBackground = 5.0f;
NSString *const kDetailPTManagerViewControllerIdentifier = @"DetailPTManagerViewController";
NSString *const kEditPTManagerViewControllerIdentifier = @"EditPTManagerViewController";
NSString *const kMessageNotFoundCamera = @"Not found camera";
NSString *const kCategoryViewControllerIdentifier = @"CategoryViewController";
NSString *const kAddNewCategoryViewControllerIdentifier = @"AddNewCategoryViewController";
NSString *const kEditNumberOfCategoryViewControllerIdentifier = @"EditNumberOfCategoryViewController";
NSString *const kDetailMeetingTitle = @"show detail meeting";
NSString *const kDetailPTManagerTitle = @"Detail PT manager";
NSString *const kPTManagerVCTitle = @"PT Manager";
NSString *const kAddNewMeetingTitle = @"New meeting";
NSString *const kAddNewTrainerTitle = @"Add new trainer";
NSString *const kUpdateTrainerTitle = @"Update new trainer";
NSString *const kEditMeetingTitle = @"Edit meeting";
NSString *const kTodayMeetingsVCTitle = @"Daily Meetings";
NSString *const kDetailMeetingsTrainerVCTitle = @"Detail Meeting Trainner";
NSString *const kCustomerManagerVCTitle = @"customer manager view controller title";
NSString *const kCalendarIdentifier = @"Calendar";
NSString *const kEditTrainerTitle = @"Edit trainer";
NSString *const kCreateSuccess = @"Create Success";
NSString *const kCreateFail = @"Create fail";
NSString *const kUpdateSuccess = @"Update success";
NSString *const kUpdateFail = @"Update fail";
NSString *const kSelectDate = @"Select date";
NSString *const kStoryboardTransactionQuantity = @"Quantity";
NSString *const kShowQuantitySegue = @"ShowQuatitySegue";
NSString *const kDeleteMeetingSuccess = @"Delete meeting is success";
NSString *const kDeleteMeetingFail = @"Delete meeting is fail";
NSString *const kTrainer = @"trainer/";
NSString *const kCustomer = @"customer/";
NSString *const kIconFriends = @"friends";
NSString *const kIconNewsFeed = @"news-feed";
NSString *const kIconSetting = @"settings";
NSString *const kIconTransactions = @"ic_transactions";
NSString *const kMyProfileTitle = @"My Profile";
CGFloat const kCornerRadiusButtonAddNewMeeting = 20.0f;
NSString *const kPTMeetingCollectionViewCellIdentifier = @"MeetingCollectionViewCell";
NSString *const kPTManagerStoryboardIdentifier = @"PTManager";
NSString *const kDetailMeetingPTStoryboardIdentifier = @"DetailMeetingPT";
NSString *const kTodayMeetingTableViewCellIdentifier = @"TodayMeetingTableViewCell";
CGFloat const kHeightCellTodayMeetingTableViewCell = 102.0f;
NSString *const kDetailMeetingPTVCIdentifier = @"DetailMeetingPTViewController";
NSString *const kAddNEwCustomerVCTitle = @"Add new customer";
NSString *const kUpdateCustomer = @"Update customer";
NSString *const kIncomeStoryboardIdentifier = @"Income";
NSString *const kShowPersonalIncomeViewControllerIdentifier = @"ShowPersonalIncomeViewController";
NSString *const kTransactionListCategoryIdentifier = @"TransactionListCategory";
NSString *const kShowCategoryTitle = @"Show category title";
NSString *const kDateBirthTitle = @"Date just before current time!";
NSString *const kFromDateToDateTitle = @"registerDate just before expiryDate!";
NSString *const kDateRegisterAndExpityTitle = @"Date register or expity just before current time!";
NSString *const kUpdateMeeting = @"Update meeting";
NSString *const kFilterTitle = @"Filter";

#pragma mark - CoreData
NSString *const kCoreDataModel = @"GymManager";
NSString *const kBundleID = @"com.vantientu.GymManager";

#pragma mark - Notification Register
NSString *const kNotiCallActionIdent = @"NotiCallAction";
NSString *const kNotiDictKeyId = @"id";
NSString *const kNotiDictKeyTrainer = @"trainer";
NSString *const kNotiDictKeyCustomer = @"customer";
NSString *const kNotiDictKeyTrainerPhone = @"trainer_phone";

#pragma mark - API
NSString *const URLRequest = @"https://fit-ness-backend.herokuapp.com/api/"; //@"http://172.16.0.131:3000/api/";
NSString *const URLRequestTransaction = @"https://fit-ness-backend.herokuapp.com/api/orders";
NSString *const kLoginRequest = @"auth/login";
NSString *const kRegisterRequest = @"auth/register";
NSString *const kTransactionRequest = @"orders";
NSString *const kURLAPI = @"https://fit-ness-backend.herokuapp.com/api/"; //@"http://172.16.0.131:3000/api/";
NSString *const kAPIUser = @"users/";
NSString *const kGetAllItemsRequest = @"items";
NSString *const kManager = @"managers";
NSString *const kMeetings = @"meetings/";
NSString *const kLogout = @"auth/logout";
NSString *const kURLImage = @"https://fit-ness-backend.herokuapp.com"; //@"http://172.16.0.131:3000";

#pragma mark - Message
NSString *const kMessageFailLogin = @"Login is fail";

+ (UIColor *)themeColor {
    return [UIColor blueColor];
}

+ (NSString *)separateNumberBySemiColon:(float)number {
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%0.2f",number];
    NSRange range;
    int countString;
    range = [string rangeOfString:@"."];
    if (range.location != NSNotFound) {
        countString = (unsigned int)range.location;
    } else {
        countString = (unsigned int)[string length];
    }
    if (countString > 3) {
        int k = countString / 3;
        if (countString % 3 == 0) {
            k = k - 1;
        }
        for (int i = 1; i <= k; i ++) {
            [string insertString:@"," atIndex:countString - i * 3];
        }
    }
    return string;
}

@end
