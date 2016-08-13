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
    BOOL boolStartDate;
    BOOL boolEndDate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    //TODO
    _nameCustomer = @"";
    _nameTrainer = @"";
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Trainer Cell
        CustomerOrTrainnerTableViewCell *customerOrTrainnerCell = (CustomerOrTrainnerTableViewCell *)[tableView
            dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier forIndexPath:indexPath];
        customerOrTrainnerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        customerOrTrainnerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [customerOrTrainnerCell configForCellWithNameCustomerOrTrainer:kTrainnerTitle];
        return customerOrTrainnerCell;
    } else if (indexPath.row == 1) {
        // Customer Cell
        CustomerOrTrainnerTableViewCell *customerOrTrainnerCell = (CustomerOrTrainnerTableViewCell *)[tableView
            dequeueReusableCellWithIdentifier:kCustomerOrTrainnerTableViewCellIdentifier forIndexPath:indexPath];
        customerOrTrainnerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        customerOrTrainnerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [customerOrTrainnerCell configForCellWithNameCustomerOrTrainer:kCustomerTitle];
        return customerOrTrainnerCell;
    } else if (indexPath.row == 2) {
        // From Date Cell
        DateMeetingTableViewCell *dateMeetingCell = (DateMeetingTableViewCell *)[tableView
            dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier forIndexPath:indexPath];
        dateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [dateMeetingCell configForCellWithDate:[DateFormatter dateFormatterDateMonthYear:[NSDate date]] andTitleFrom:kFromTitle];
        return dateMeetingCell;
    } else {
        // To Date Cell
        DateMeetingTableViewCell *dateMeetingCell = (DateMeetingTableViewCell *)[tableView
            dequeueReusableCellWithIdentifier:kDateMeetingTableViewCellIdentifier forIndexPath:indexPath];
        dateMeetingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dateMeetingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [dateMeetingCell configForCellWithDate:[DateFormatter dateFormatterDateMonthYear:[NSDate date]] andTitleFrom:kToTitle];
        return dateMeetingCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightMeetingDetailCell;
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //TODO
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
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
    } else if (!boolStartDate) {
        self.labelNotes.text = kNotificationNOSelectStartDate;
    } else if (!boolEndDate) {
        self.labelNotes.text = kNotificationNOSelectEndDate;
    } else {
        //TODO
        self.labelNotes.text = kNotificationAddNewMeetingSuccess;
    }
}


@end
