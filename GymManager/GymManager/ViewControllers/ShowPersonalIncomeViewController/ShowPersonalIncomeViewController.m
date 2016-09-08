//
//  ShowPersonalIncomeViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ShowPersonalIncomeViewController.h"

@interface ShowPersonalIncomeViewController ()<MeetingManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTotalShift;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalNoShift;
@property (weak, nonatomic) IBOutlet UILabel *labelIncomePerShift;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalSalary;
@property (weak, nonatomic) IBOutlet UILabel *labelTimes;
@property (strong, nonatomic) NSMutableArray *arrMeetings;
@property (strong, nonatomic) NSMutableArray *arrMeetingFilters;

@end

@implementation ShowPersonalIncomeViewController
{
    NSInteger _totalShifts;
    NSInteger _totalNoShifts;
    NSInteger _incomePerShift;
    double _totalSalary;
    NSDate *_dateSelected;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self getAllMeetingsTrainer];
}

- (void)getAllMeetingsTrainer {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    MeetingManager *meetingManager = [[MeetingManager alloc] init];
    meetingManager.delegate = self;
    [meetingManager getMeetingsWithTrainer:self.trainer];
}

#pragma mark - MeetingManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrMeetings {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (error) {
        [AlertManager showAlertWithTitle:kRegisterRequest message:message
            viewControler:self reloadAction:^{
            [self getAllMeetingsTrainer];
        }];
    } else {
        self.arrMeetings = arrMeetings.mutableCopy;
        [self filterMeetingsWithMonth:_dateSelected];
    }
}

- (void)setupView {
    _dateSelected = [NSDate date];
    self.title = self.trainer.fullName;
    self.labelTimes.text = [[DateFormatter sharedInstance] stringMonthYearFromDate:_dateSelected];
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kIconCalendar]
        style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar:)];
    self.navigationItem.rightBarButtonItem = calendarButton;
}

- (IBAction)showCalendar:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    calendarVC.state = CalendarPickerStateMonth;
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _dateSelected = dateSelected;
        self.labelTimes.text = [[DateFormatter sharedInstance] stringMonthYearFromDate:dateSelected];
        [self filterMeetingsWithMonth:_dateSelected];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

- (void)filterMeetingsWithMonth:(NSDate *)dateSelected {
    NSString *dateSelectedString = [[DateFormatter sharedInstance] stringMonthYearFromDate:dateSelected];
    self.arrMeetingFilters = [NSMutableArray array];
    for (Meeting *meeting in self.arrMeetings) {
        NSString *fromDateString = [[DateFormatter sharedInstance] stringMonthYearFromDateString:meeting.fromDate];
        if ([dateSelectedString isEqualToString:fromDateString]) {
            [self.arrMeetingFilters addObject:meeting];
        }
    }
    _totalShifts = 0;
    _totalNoShifts = 0;
    _totalSalary = 0;
    double currentTimes = [dateSelected timeIntervalSince1970];
    for (Meeting *meeting in self.arrMeetingFilters) {
        NSDate *fromDate = [[DateFormatter sharedInstance] dateFormatterHourDateMonthYearWithString:meeting.fromDate];
        double fromTimes = [fromDate timeIntervalSince1970];
        if (currentTimes > fromTimes) {
            _totalShifts += 1;
        } else {
            _totalNoShifts += 1;
        }
    }
    _totalSalary = _totalShifts * self.trainer.meetingMoney;
    NSString *meetingMoneyString = [GymManagerConstant separateNumberBySemiColon:self.trainer.meetingMoney];
    NSString *salaryString = [GymManagerConstant separateNumberBySemiColon:_totalSalary];
    self.labelTotalShift.text = [NSString stringWithFormat:@"%ld", _totalShifts];
    self.labelTotalNoShift.text = [NSString stringWithFormat:@"%ld", _totalNoShifts];
    self.labelIncomePerShift.text = [NSString stringWithFormat:@"%@", meetingMoneyString];
    self.labelTotalSalary.text = [NSString stringWithFormat:@"%@", salaryString];
}

@end
