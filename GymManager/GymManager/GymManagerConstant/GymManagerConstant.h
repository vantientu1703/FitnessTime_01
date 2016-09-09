//
//  GymManagerConstant.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GymManagerConstant : NSObject

extern NSString *const kNameStoryboard;
extern NSString *const kNameStoryboardTransaction;
extern NSString *const kLoginViewControllerIdentifier;
extern NSString *const kTodayViewControllerTitle;
extern NSString *const kPTMeetingViewControllerTitle;
extern NSString *const kTransactionsViewControllerTitle;
extern NSString *const kMenuViewControllerTitle;
extern NSString *const kRegisterViewControllerIdentifier;
extern NSString *const kNotificationSetRootViewWindowTitle;
extern const CGFloat kTableViewCellHeight;
extern const CGFloat kTableViewHeaderHeight;
extern NSString *const kTransactionCellIndentifier;
extern NSString *const kTodayMeetinViewControllerIdentifier;
extern NSString *const kIconCalendar;
extern NSString *const kEditActionTitle;
extern NSString *const kDeleteActionTitle;
extern NSString *const kReminderTitle;
extern NSString *const kMessageReminder;
extern NSString *const kOkActionTitle;
extern NSString *const kCancelActionTitle;
extern CGFloat const kCornerRadiusButton;
extern NSString *const kPTMeetingViewControllerIdentifier;
extern NSString *const kMeetingDetailViewControllerIdentifier;
extern NSString *const kStatusAddNewMeeting;
extern NSString *const kStatusViewMeetingDetail;
extern NSString *const kMenuViewControllerIdentifier;
extern NSString *const kMyProfileViewControllerIdentifier;
extern NSString *const kEditMyProfileViewControllerIdentifier;
extern NSString *const kChoosenTypeTitle;
extern NSString *const kChoseFromLibraryTitle;
extern NSString *const kChoseFromCameraTitle;
extern NSString *const kCancelTitle;
extern NSString *const kNotFoundCamera;
extern NSString *const kOkTitle;
extern NSString *const kCustomerManagerStoryboard;
extern NSString *const kCustomerManagerViewControllerIdentifier;
extern NSString *const kAddNewCustomerViewControllerIdentifier;
extern NSString *const kMessageEditCustomer;
extern NSString *const kIconUser;
extern NSString *const kCustomerManagerTitle;
extern NSString *const kInfoCustomerManagerViewControllerIdentifier;
extern CGFloat const kCornerRadiusViewBackground;
extern NSString *const kDetailPTManagerViewControllerIdentifier;
extern NSString *const kEditPTManagerViewControllerIdentifier;
extern NSString *const kMessageNotFoundCamera;
extern NSString *const kCategoryViewControllerIdentifier;
extern NSString *const kAddNewCategoryViewControllerIdentifier;
extern NSString *const kEditNumberOfCategoryViewControllerIdentifier;
extern NSString *const kDetailMeetingTitle;
extern NSString *const kDetailPTManagerTitle;
extern NSString *const kPTManagerVCTitle;
extern NSString *const kAddNewMeetingTitle;
extern NSString *const kEditMeetingTitle;
extern NSString *const kTodayMeetingsVCTitle;
extern NSString *const kDetailMeetingsTrainerVCTitle;
extern NSString *const kCustomerManagerVCTitle;
extern NSString *const kCalendarIdentifier;
extern NSString *const kEditTrainerTitle;
extern NSString *const kCreateSuccess;
extern NSString *const kCreateFail;
extern NSString *const kUpdateSuccess;
extern NSString *const kUpdateFail;
extern NSString *const kSelectDate;
extern NSString *const kStoryboardTransactionQuantity;
extern NSString *const kShowQuantitySegue;
extern NSString *const kDeleteMeetingSuccess;
extern NSString *const kDeleteMeetingFail;
extern NSString *const kTrainer;
extern NSString *const kCustomer;
extern NSString *const kIconFriends;
extern NSString *const kIconNewsFeed;
extern NSString *const kIconSetting;
extern NSString *const kIconTransactions;
extern NSString *const kMyProfileTitle;
extern CGFloat const kCornerRadiusButtonAddNewMeeting;
extern NSString *const kPTMeetingCollectionViewCellIdentifier;
extern NSString *const kPTManagerStoryboardIdentifier;
extern NSString *const kPTManagerViewControllerIdentifier;
extern NSString *const kAddNewTrainerTitle;
extern NSString *const kUpdateTrainerTitle;
extern NSString *const kDetailMeetingPTStoryboardIdentifier;
extern NSString *const kTodayMeetingTableViewCellIdentifier;;
extern CGFloat const kHeightCellTodayMeetingTableViewCell;
extern NSString *const kDetailMeetingPTVCIdentifier;
extern NSString *const kAddNEwCustomerVCTitle;
extern NSString *const kUpdateCustomer;
extern NSString *const kIncomeStoryboardIdentifier;
extern NSString *const kShowPersonalIncomeViewControllerIdentifier;
extern NSString *const kTransactionListCategoryIdentifier;
extern NSString *const kShowCategoryTitle;
extern NSString *const kDateBirthTitle;
extern NSString *const kFromDateToDateTitle;
extern NSString *const kDateRegisterAndExpityTitle;

#pragma mark - CoreData
extern NSString *const kCoreDataModel;
extern NSString *const kBundleID;

#pragma mark - API
extern NSString *const URLRequest;
extern NSString *const URLRequestItem;
extern NSString *const URLRequestTransaction;
extern NSString *const kLoginRequest;
extern NSString *const kRegisterRequest;
extern NSString *const kTransactionRequest;
extern NSString *const kURLAPI;
extern NSString *const kAPIUser;
extern NSString *const kGetAllItemsRequest;
extern NSString *const kManager;
extern NSString *const kMeetings;
extern NSString *const kLogout;
extern NSString *const kURLImage;

#pragma mark - Message
extern NSString *const kMessageFailLogin;

+ (UIColor *)themeColor;
+ (NSString *)separateNumberBySemiColon:(float)number;

@end
