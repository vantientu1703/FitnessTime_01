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

@interface MeetingDetailViewController ()<UITableViewDataSource, UITableViewDelegate, MeetingManagerDelegate, PTMeetingViewControllerDelegate, CustomerManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;
@property (strong, nonatomic) PTMeetingViewController *ptMeetingVC;
@property (strong, nonatomic) CustomerManagerViewController *customerManagerVC;

@end

@implementation MeetingDetailViewController
{
    NSIndexPath *_indexPath;
    Trainer *_trainer;
    Customer *_customer;
    NSDate *_fromDate;
    NSDate *_toDate;
    NSString *_nameTrainer;
    NSString *_nameCustomer;
    BOOL _boolStartDate;
    BOOL _boolEndDate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    //TODO
    if ([self.statusEditMeeting isEqualToString:kAddNewMeetingTitle]) {
        self.title = kAddNewMeetingTitle;
    } else {
        self.title = kEditMeetingTitle;
        _fromDate = [[DateFormatter sharedInstance] dateFormatterHourDateMonthYearWithString:self.meeting.fromDate];
        _toDate = [[DateFormatter sharedInstance] dateFormatterHourDateMonthYearWithString:self.meeting.toDate];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self action:@selector(saveMeeting:)];
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
    Trainer *trainer;
    Customer *customer;
    for (NSDictionary *obj in self.meeting.users) {
        if ([obj[@"role"] isEqualToString:kTrainer]) {
            trainer = [[Trainer alloc] initWithDictionary:obj error:nil];
            _trainer = trainer;
        } else if ([obj[@"role"] isEqualToString:kCustomer]) {
            customer = [[Customer alloc] initWithDictionary:obj error:nil];
            _customer = customer;
        }
    }
    switch (indexPath.row) {
        case MeetingDetailRowTrainer: {
            CustomerOrTrainnerTableViewCell *trainerCell = (CustomerOrTrainnerTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier
                forIndexPath:indexPath];
            trainerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            trainerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
                [trainerCell configCellWithName:trainer.fullName];
            } else {
                [trainerCell configCellWithName:kTrainnerTitle];
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
                [customerCell configCellWithName:customer.fullName];
            } else {
                [customerCell configCellWithName:kCustomerTitle];
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
            _indexPath = indexPath;
            if (!self.ptMeetingVC) {
                self.ptMeetingVC = [st
                    instantiateViewControllerWithIdentifier:kPTMeetingViewControllerIdentifier];
            }
            self.ptMeetingVC.delegate = self;
            [self.navigationController pushViewController:self.ptMeetingVC animated:true];
            self.ptMeetingVC.statusAddNewMeeting = kStatusAddNewMeeting;
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
    if (!_trainer) {
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
        if ([self.statusEditMeeting isEqualToString:kEditMeetingTitle]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            [meetingManager updateMeetingItem:self.meeting withTrainer:_trainer
                withCustomer:_customer fromDate:_fromDate toDate:_toDate];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            [meetingManager createMeetingWithTrainer:_trainer withTrainee:_customer fromDate:_fromDate toDate:_toDate];
        }
    }
}

#pragma mark - MeetingManagerDelegate
- (void)createMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (success) {
        self.labelNotes.text = kCreateSuccess;
        if ([self.delegate respondsToSelector:@selector(reloadDataMeetings:)]) {
            [self.delegate reloadDataMeetings:meeting];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddNewMeetingTitle object:nil];
        }
    } else {
        self.labelNotes.text = error.localizedDescription;
    }
}

- (void)updateMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (success) {
        self.labelNotes.text = kUpdateSuccess;
        if ([self.delegate respondsToSelector:@selector(updateMeeting:)]) {
            [self.delegate updateMeeting:meeting];
        }
    } else {
        [AlertManager showAlertWithTitle:kRegisterRequest message:error.localizedDescription
            viewControler:self okAction:^{
        }];
    }
}

#pragma mark - PTMeetingViewControllerDelegate
- (void)selectedTrainer:(Trainer *)trainer {
    _trainer = trainer;
    CustomerOrTrainnerTableViewCell *cell = (CustomerOrTrainnerTableViewCell *)[self.tableView
        cellForRowAtIndexPath:_indexPath];
    cell.labelNameCustomOrTrainer.text = _trainer.fullName;
}

#pragma mark - CustomerManagerViewControllerDelegate
- (void)selectedCustomer:(Customer *)customer {
    _customer = customer;
    CustomerOrTrainnerTableViewCell *cell = (CustomerOrTrainnerTableViewCell *)[self.tableView
        cellForRowAtIndexPath:_indexPath];
    cell.labelNameCustomOrTrainer.text = _customer.fullName;
}

@end
