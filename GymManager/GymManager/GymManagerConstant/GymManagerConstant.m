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
NSString *const kPTMeetingViewControllerTitle = @"PT Meeting";
NSString *const kTransactionsViewControllerTitle = @"Transactions";
NSString *const kMenuViewControllerTitle = @"Menu";
NSString *const kRegisterViewControllerIdentifier = @"RegisterViewController";
NSString *const kNotificationSetRootViewWindowTitle = @"Set root view window";
const CGFloat kTableViewCellHeight = 40.0;
const CGFloat kTableViewHeaderHeight = 60.0;
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
NSString *const kDetailPTManagerTitle = @"show detail pt manager";
NSString *const kPTManagerVCTitle = @"PT Manager";
NSString *const kAddNewMeetingTitle = @"Add new meeting";
NSString *const kEditMeetingTitle = @"Edit meeting";
NSString *const kTodayMeetingsVCTitle = @"Today Meeting";
NSString *const kDetailMeetingsTrainerVCTitle = @"Detail Meeting Trainner";
NSString *const kCustomerManagerVCTitle = @"customer manager view controller title";
NSString *const kCalendarIdentifier = @"Calendar";
NSString *const kEditTrainerTitle = @"Edit trainer";
NSString *const kCreateSuccess = @"Create success";
NSString *const kCreateFail = @"Create fail";
NSString *const kUpdateSuccess = @"Update success";
NSString *const kUpdateFail = @"Update fail";
NSString *const kSelectDate = @"Select date";
NSString *const kStoryboardTransactionQuantity = @"Quantity";
NSString *const kShowQuantitySegue = @"ShowQuatitySegue";

#pragma mark - CoreData
NSString *const kCoreDataModel = @"GymManager";
NSString *const kBundleID = @"com.vantientu.GymManager";

#pragma mark - API
NSString *const URLRequest = @"https://fit-ness-backend.herokuapp.com/api/";
NSString *const kLoginRequest = @"auth/login";
NSString *const kRegisterRequest = @"auth/register";
NSString *const kTransactionRequest = @"orders";
NSString *const kURLAPI = @"https://fit-ness-backend.herokuapp.com/api/";
NSString *const kAPIUser = @"users";
NSString *const kGetAllItemsRequest = @"items";
NSString *const kManager = @"managers";

#pragma mark - Message
NSString *const kMessageFailLogin = @"Login is fail";

@end
