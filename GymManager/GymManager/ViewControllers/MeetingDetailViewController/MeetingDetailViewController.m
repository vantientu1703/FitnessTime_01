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

typedef NS_ENUM(NSInteger, MeetingDetailRows) {
    MeetingDetailRowTrainer,
    MeetingDetailRowCustomer,
    MeetingDetailRowFromDate,
    MeetingDetailRowToDate
};

NSInteger const kNumberOfRowsInSection = 4;
NSString *const kTrainnerTitle = @"Persion Trainer";
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

@interface MeetingDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotes;

@end

@implementation MeetingDetailViewController
{
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _nameCustomer = @"";
    _nameTrainer = @"";
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DateFormatter *dateFormatter = [[DateFormatter alloc] init];
    switch (indexPath.row) {
        case MeetingDetailRowTrainer: {
            CustomerOrTrainnerTableViewCell *trainerCell = (CustomerOrTrainnerTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier
                forIndexPath:indexPath];
            trainerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            trainerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [trainerCell configCellWithName:kTrainnerTitle];
            return trainerCell;
        }
        case MeetingDetailRowCustomer: {
            CustomerOrTrainnerTableViewCell *customerCell = (CustomerOrTrainnerTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier
                forIndexPath:indexPath];
            customerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            customerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [customerCell configCellWithName:kCustomerTitle];
            return customerCell;
        }
        case MeetingDetailRowFromDate: {
            DateMeetingTableViewCell *fromDateMeetingCell = (DateMeetingTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier
                forIndexPath:indexPath];
            fromDateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            fromDateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [fromDateMeetingCell configCellWithDate:[dateFormatter dateFormatterDateMonthYear:[NSDate date]]
                andTitleFrom:kFromTitle];
            return fromDateMeetingCell;
        }
        case MeetingDetailRowToDate: {
            DateMeetingTableViewCell *toDateMeetingCell = (DateMeetingTableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier
                forIndexPath:indexPath];
            toDateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            toDateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [toDateMeetingCell configCellWithDate:[dateFormatter dateFormatterDateMonthYear:[NSDate date]] andTitleFrom:kToTitle];
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
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    PTMeetingViewController *ptMeetingVC = [st
        instantiateViewControllerWithIdentifier:kPTMeetingViewControllerIdentifier];
    CalendarViewController *calendarVC = [[CalendarViewController alloc] init];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected) {
        //TODO
    }];
    switch (indexPath.row) {
        case MeetingDetailRowTrainer:
            [self.navigationController pushViewController:ptMeetingVC animated:true];
            ptMeetingVC.statusAddNewMeeting = kStatusAddNewMeeting;
            break;
        case MeetingDetailRowCustomer:
            //TODO
            break;
        case MeetingDetailRowFromDate:
            [self.navigationController pushViewController:calendarVC animated:true];
            break;
        case MeetingDetailRowToDate:
            [self.navigationController pushViewController:calendarVC animated:true];
            break;
        default:
            break;
    }
}

#pragma mark - Implement button Submit
- (IBAction)submitPress:(id)sender {
    if (!_nameTrainer.length) {
        self.labelNotes.text = kNotificationNoSelectTrainer;
    } else if (!_nameCustomer.length) {
        self.labelNotes.text = kNotificationNoSelectCustomer;
    } else if (!_boolStartDate) {
        self.labelNotes.text = kNotificationNOSelectStartDate;
    } else if (!_boolEndDate) {
        self.labelNotes.text = kNotificationNOSelectEndDate;
    } else {
        //TODO
        self.labelNotes.text = kNotificationAddNewMeetingSuccess;
    }
}

@end
