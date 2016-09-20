//
//  MeetingDetailViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "CustomerOrTrainnerTableViewCell.h"
#import "DateMeetingTableViewCell.h"
#import "DateFormatter.h"
#import "PTMeetingViewController.h"
#import "CalendarViewController.h"
#import "CustomerManagerViewController.h"

typedef NS_ENUM(NSInteger, MeetingDetailRows) {
    MeetingDetailRowTrainer,
    MeetingDetailRowCustomer,
    MeetingDetailRowFromDate,
    MeetingDetailRowToDate
};

NSInteger const kNumberOfRowsInSection = 4;
NSString *const kTrainnerTitle = @"Trainer";
NSString *const kCustomerTitle = @"Customer";
NSString *const kCustomerOrTrainnerTableViewCellIdentifier = @"CustomerOrTrainnerTableViewCell";
NSString *const kDateMeetingTableViewCellIdentifier = @"DateMeetingTableViewCell";
NSString *const kNotificationNoSelectTrainer = @"Select trainer,please!";
NSString *const kNotificationNoSelectCustomer = @"Select customer,please!";
NSString *const kNotificationAddNewMeetingSuccess = @"Add new meeting success!";
NSString *const kFromTitle = @"From :";
NSString *const kToTitle = @"To :";
NSString *const kNotificationNOSelectStartDate = @"Select start date,please!";
NSString *const kNotificationNOSelectEndDate = @"Select end date,please!";
CGFloat const kHeightMeetingDetailCell = 44.0f;
NSString *const kRequestFailTitle = @"Resquest failed: unacceptable (406)";

@interface MeetingDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MeetingManagerDelegate, PTMeetingViewControllerDelegate, CustomerManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (strong, nonatomic) PTMeetingViewController *ptMeetingVC;
@property (strong, nonatomic) CustomerManagerViewController *customerManagerVC;

@end

@implementation MeetingDetailViewController
{
    NSIndexPath *_indexPath;
    Trainer *_trainerInstance;
    Customer *_customer;
    NSDate *_fromDate;
    NSDate *_toDate;
    NSString *_nameTrainer;
    NSString *_nameCustomer;
    BOOL _boolStartDate;
    BOOL _boolEndDate;
    BOOL _modifier;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    if ([self.statusEditMeeting isEqualToString:kAddNewMeetingTitle]) {
        self.title = kAddNewMeetingTitle;
    } else {
        self.title = kEditMeetingTitle;
        _fromDate = [[DateFormatter sharedInstance] dateFormatterHourDateMonthYearWithString:self.meeting.fromDate];
        _toDate = [[DateFormatter sharedInstance] dateFormatterHourDateMonthYearWithString:self.meeting.toDate];
        _trainerInstance = self.meeting.trainer;
        _customer = self.meeting.customer;
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(saveNewMeetingPress:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _nameCustomer = @"";
    _nameTrainer = @"";
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MeetingDetailRowTrainer: {
            CustomerOrTrainnerTableViewCell *trainerCell = (CustomerOrTrainnerTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier
                forIndexPath:indexPath];
            trainerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            trainerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                [trainerCell configCellWithName:_trainerInstance.fullName type:kTrainnerTitle];
            } else {
                if (self.trainer) {
                    _trainerInstance = self.trainer;
                    [trainerCell configCellWithName:self.trainer.fullName type:kTrainnerTitle];
                    trainerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    [trainerCell configCellWithName:@"" type:[NSString stringWithFormat:@"%@:", kTrainnerTitle]];
                }
            }
            return trainerCell;
        }
        case MeetingDetailRowCustomer: {
            CustomerOrTrainnerTableViewCell *customerCell = (CustomerOrTrainnerTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier
                forIndexPath:indexPath];
            customerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            customerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                [customerCell configCellWithName:_customer.fullName type:kCustomerTitle];
            } else {
                [customerCell configCellWithName:@"" type:[NSString stringWithFormat:@"%@:", kCustomerTitle]];
            }
            return customerCell;
        }
        case MeetingDetailRowFromDate: {
            DateMeetingTableViewCell *fromDateMeetingCell = (DateMeetingTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier
                forIndexPath:indexPath];
            fromDateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            fromDateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                [fromDateMeetingCell configCellWithDate:[[DateFormatter sharedInstance]
                    dateWithHourDayMonthYearFormatterFromString:self.meeting.fromDate] andTitleFrom:kFromTitle];
            } else {
                [fromDateMeetingCell configCellWithDate:[[DateFormatter sharedInstance]
                    dateFormatterDateMonthYear:[NSDate date]] andTitleFrom:kFromTitle];
            }
            return fromDateMeetingCell;
        }
        case MeetingDetailRowToDate: {
            DateMeetingTableViewCell *toDateMeetingCell = (DateMeetingTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier
                forIndexPath:indexPath];
            toDateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            toDateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                [toDateMeetingCell configCellWithDate:[[DateFormatter sharedInstance]
                    dateWithHourDayMonthYearFormatterFromString:self.meeting.toDate] andTitleFrom:kToTitle];
            } else {
                [toDateMeetingCell configCellWithDate:[[DateFormatter sharedInstance]
                    dateFormatterDateMonthYear:[NSDate date]] andTitleFrom:kToTitle];
            }
            return toDateMeetingCell;
        }
        default:
            return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightMeetingDetailCell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    switch (indexPath.row) {
        case MeetingDetailRowTrainer: {
            if (!self.trainer) {
                _indexPath = indexPath;
                if (!self.ptMeetingVC) {
                    self.ptMeetingVC = [st
                        instantiateViewControllerWithIdentifier:kPTMeetingViewControllerIdentifier];
                }
                self.ptMeetingVC.delegate = self;
                [self.navigationController pushViewController:self.ptMeetingVC animated:true];
                self.ptMeetingVC.statusAddNewMeeting = kStatusAddNewMeeting;
            }
            break;
        }
        case MeetingDetailRowCustomer: {
            _indexPath = indexPath;
            UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
            if (!self.customerManagerVC) {
                self.customerManagerVC = [st
                    instantiateViewControllerWithIdentifier:kCustomerManagerViewControllerIdentifier];;
            }
            self.customerManagerVC.statusCustomerManagerTitle = kStatusAddNewMeeting;
            self.customerManagerVC.delegate = self;
            [self.navigationController pushViewController:self.customerManagerVC animated:true];
            break;
        }
        case MeetingDetailRowFromDate: {
            UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
            CalendarViewController *calendarVC = [st instantiateInitialViewController];
            calendarVC.state = CalendarPickerStateTime;
            [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
                _fromDate = dateSelected;
                _modifier = true;
                DateMeetingTableViewCell *dateMeetingCell = (DateMeetingTableViewCell *)[self.tableView
                    cellForRowAtIndexPath:indexPath];
                dateMeetingCell.labelFromTitle.text = kFromTitle;
                dateMeetingCell.labelDateMeeting.text = [[DateFormatter sharedInstance]
                    dateFormatterHourDateMonthYear:_fromDate];
            }];
            [self.navigationController pushViewController:calendarVC animated:true];
            break;
        }
        case MeetingDetailRowToDate: {
            UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
            CalendarViewController *calendarVC = [st instantiateInitialViewController];
            calendarVC.state = CalendarPickerStateTime;
            [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
                _toDate = dateSelected;
                _modifier = true;
                DateMeetingTableViewCell *dateMeetingCell = (DateMeetingTableViewCell *)[self.tableView
                    cellForRowAtIndexPath:indexPath];
                dateMeetingCell.labelFromTitle.text = kToTitle;
                dateMeetingCell.labelDateMeeting.text = [[DateFormatter sharedInstance]
                    dateFormatterHourDateMonthYear:_toDate];
            }];
            [self.navigationController pushViewController:calendarVC animated:true];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Implement button done
- (IBAction)saveNewMeetingPress:(id)sender {
    if (!_trainerInstance) {
        self.labelNotes.text = kNotificationNoSelectTrainer;
    } else if (!_customer) {
        self.labelNotes.text = kNotificationNoSelectCustomer;
    } else if (!_fromDate) {
        self.labelNotes.text = kNotificationNOSelectStartDate;
    } else if (!_toDate) {
        self.labelNotes.text = kNotificationNOSelectEndDate;
    } else {
        MeetingManager *meetingManager = [[MeetingManager alloc] init];
        meetingManager.delegate = self;
        if (_modifier) {
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [meetingManager updateMeetingItem:self.meeting withTrainer:_trainerInstance
                    withCustomer:_customer fromDate:_fromDate toDate:_toDate];
            } else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [meetingManager createMeetingWithTrainer:_trainerInstance withTrainee:_customer
                    fromDate:_fromDate toDate:_toDate];
            }
        }
    }
}

#pragma mark - MeetingManagerDelegate
- (void)createMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (success) {
        _modifier = false;
        self.labelNotes.text = kCreateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
        NSDictionary *userInfo = @{@"meeting": meeting};
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddNewMeetingTitle
            object:self userInfo:userInfo];
        [[NotificationManager sharedManager] addNewMeeting:meeting];
    } else {
        self.labelNotes.text = error.localizedDescription;
    }
}

- (void)updateMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (success) {
        _modifier = false;
        self.labelNotes.text = kUpdateSuccess;
        self.labelNotes.textColor = [GymManagerConstant themeColor];
        NSDictionary *userInfo = @{@"meeting": meeting};
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMeeting object:nil userInfo:userInfo];
        [[NotificationManager sharedManager] editMeeting:meeting];
    } else {
        [AlertManager showAlertWithTitle:kRegisterRequest message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

- (void)createMeetingFaileWithMessage:(NSString *)message {
    //TODO: handle create meeting fail
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (message) {
        self.labelNotes.text = message;
    }
}

- (void)updateMeetingFailWithMessage:(NSString *)message {
    //TODO: handle update meeting fail
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (message) {
        self.labelNotes.text = message;
    }
}

#pragma mark - PTMeetingViewControllerDelegate
- (void)selectedTrainer:(Trainer *)trainer {
    _trainerInstance = trainer;
    _modifier = true;
    CustomerOrTrainnerTableViewCell *cell = (CustomerOrTrainnerTableViewCell *)[self.tableView
        cellForRowAtIndexPath:_indexPath];
    cell.labelNameCustomOrTrainer.text = _trainerInstance.fullName;
}

#pragma mark - CustomerManagerViewControllerDelegate
- (void)selectedCustomer:(Customer *)customer {
    _customer = customer;
    _modifier = true;
    CustomerOrTrainnerTableViewCell *cell = (CustomerOrTrainnerTableViewCell *)[self.tableView
        cellForRowAtIndexPath:_indexPath];
    cell.labelNameCustomOrTrainer.text = _customer.fullName;
}

@end
