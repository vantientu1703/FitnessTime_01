//
//  ViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TodayMeetingsViewController.h"
#import "TodayMeetingTableViewCell.h"
#import "MeetingDetailViewController.h"

@interface TodayMeetingsViewController ()<UITableViewDelegate, UITableViewDataSource, MeetingManagerDelegate, MeetingDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddMeeting;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrMeetings;
@property (weak, nonatomic) IBOutlet UILabel *labelTimes;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;

@end

@implementation TodayMeetingsViewController
{
    NSIndexPath *_indexPath;
    NSDate *_dateSelected;
    BOOL _isRefresh;
}
#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    if ([self.statusDetailMeeting isEqualToString:kDetailMeetingsTrainerVCTitle]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        MeetingManager *meetingManager = [[MeetingManager alloc] init];
        meetingManager.delegate = self;
        [meetingManager getMeetingsWithTrainer:self.trainer];
    } else {
        [self getAllMeetngsWithDate:[NSDate date]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllMeetingsToday:)
        name:kAddNewMeetingTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTrainerChanged:)
        name:kUpdateTrainerTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoCustomerChanged:)
        name:kUpdateCustomer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMeetingToTabMeeting:)
        name:kUpdateMeeting object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMeetingToTabMeeting:)
        name:kDeleteMeetingSuccess object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteMeetingToTabMeeting:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Meeting *meeting = userInfo[@"meeting"];
        [self.arrMeetings removeObject:meeting];
        [self.tableView reloadData];
    }
}

- (void)updateMeetingToTabMeeting:(NSNotification *)notifcation {
    if (notifcation) {
        NSDictionary *userInfo = notifcation.userInfo;
        Meeting *meeting = userInfo[@"meeting"];
        [self.arrMeetings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Meeting *meetingItem = (Meeting *)obj;
            if (meeting.id == meetingItem.id) {
                [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
            }
        }];
        [self.tableView reloadData];
    }
}

- (void)infoCustomerChanged:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Customer *customer = userInfo[@"customer"];
        [self.arrMeetings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Meeting *meeting = (Meeting *)obj;
            Customer *customerInstance = meeting.customer;
            if (customer.id == customerInstance.id) {
                meeting.customer = customer;
                [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
                [self.tableView reloadData];
                return;
            }
        }];
    }
}

- (void)infoTrainerChanged:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Trainer *trainer = userInfo[@"trainer"];
        [self.arrMeetings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Meeting *meeting = (Meeting *)obj;
            Trainer *trainerInstance = meeting.trainer;
            if (trainer.id == trainerInstance.id) {
                meeting.trainer = trainer;
                [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
                return;
            }
        }];
        [self.tableView reloadData];
    }
}

- (void)getAllMeetingsToday:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Meeting *meeting = userInfo[@"meeting"];
        if (!self.arrMeetings) {
            self.arrMeetings = [NSMutableArray array];
        }
        NSString *fromDateStirng = [[DateFormatter sharedInstance]
            dateWithDateMonthYearFormatterFromString:meeting.fromDate];
        NSString *dateSelectedString = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:_dateSelected];
        if ([fromDateStirng isEqualToString:dateSelectedString]) {
            [self.arrMeetings addObject:meeting];
        }
        [self.tableView reloadData];
    }
}

- (void)getAllMeetngsWithDate:(NSDate *)date {
    if (!_isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        _isRefresh = false;
    }
    MeetingManager *meetingManager = [[MeetingManager alloc] init];
    meetingManager.delegate = self;
    [meetingManager getAllMeetingsWithDate:date];
}

#pragma mark - MeetingManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrMeetings {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [self.refreshReloadData endRefreshing];
    if (error) {
        [AlertManager showAlertWithTitle:kRegisterRequest message:message
            viewControler:self reloadAction:^{
            [self getAllMeetngsWithDate:[NSDate date]];
        }];
    } else {
        self.arrMeetings = arrMeetings.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)didResponseWithMessage:(NSString *)message withDate:(NSDate *)date withError:(NSError *)error returnArray:(NSArray *)arrMeetings {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [self.refreshReloadData endRefreshing];
    if (error) {
        [AlertManager showAlertWithTitle:kRegisterRequest message:message
            viewControler:self reloadAction:^{
            [self getAllMeetngsWithDate:date];
        }];
    } else {
        self.arrMeetings = arrMeetings.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)didDeleteMeetingSuccess:(BOOL)success error:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (success) {
        [AlertManager showAlertWithTitle:kReminderTitle message:kDeleteMeetingSuccess
            viewControler:self okAction:^{
            [self.arrMeetings removeObjectAtIndex:_indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else {
        [AlertManager showAlertWithTitle:kReminderTitle message:kDeleteMeetingFail
            viewControler:self okAction:^{
        }];
    }
}

- (void)setupView {
    _dateSelected = [NSDate date];
    if ([self.statusDetailMeeting isEqualToString:kTodayMeetingsVCTitle]) {
        self.title = kTodayMeetingsVCTitle;
    } else {
        self.title = kDetailMeetingsTrainerVCTitle;
    }
    self.labelTimes.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:[NSDate date]];
    if (![self.statusDetailMeeting isEqualToString:kDetailMeetingsTrainerVCTitle]) {
        UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kIconCalendar]
            style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar:)];
        self.navigationItem.rightBarButtonItem = calendarButton;
    }
    self.buttonAddMeeting.layer.cornerRadius = kCornerRadiusButton;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Reload data when disconect internet
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataTableView:)
        forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshReloadData atIndex:0];
}

- (IBAction)reloadDataTableView:(id)sender {
    _isRefresh = true;
    [self getAllMeetngsWithDate:_dateSelected];
}

#pragma mark - Show calendar
- (IBAction)showCalendar:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [self.navigationController pushViewController:calendarVC animated:true];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        self.labelTimes.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:dateSelected];
        _dateSelected = dateSelected;
        [self getAllMeetngsWithDate:dateSelected];
    }];
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrMeetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayMeetingTableViewCell *cell = (TodayMeetingTableViewCell *)[tableView
        dequeueReusableCellWithIdentifier:kTodayMeetingTableViewCellIdentifier forIndexPath:indexPath];
    Meeting *meeting = self.arrMeetings[indexPath.row];
    [cell cellWithMeeting:meeting];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightCellTodayMeetingTableViewCell;
}

#pragma mark - UITableViewDelegate 
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
        title:kEditActionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
            MeetingDetailViewController *meetingDetailVC = [st
                instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
            meetingDetailVC.statusEditMeeting = kEditMeetingTitle;
            meetingDetailVC.meeting = self.arrMeetings[indexPath.row];
            meetingDetailVC.delegate = self;
            _indexPath = indexPath;
            [self.navigationController pushViewController:meetingDetailVC animated:true];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
        title:kDeleteActionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self showAlertControllerWithIndexPath:indexPath];
    }];
    BOOL check = [self checkMeeting:self.arrMeetings[indexPath.row]];
    if (check) {
        return @[deleteAction, editAction];
    } else {
        return @[deleteAction];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
}

- (BOOL)checkMeeting:(Meeting *)meeting {
    NSDate *fromDate = [[DateFormatter sharedInstance] dateWithMonthYearFormatterFromStringUTC:meeting.fromDate];
    double fromDateTime = [fromDate timeIntervalSince1970];
    double currentDateTime = [[NSDate date] timeIntervalSince1970];
    if (currentDateTime < fromDateTime) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - Button add new meeting
- (IBAction)buttonAddMeetingPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    MeetingDetailViewController *meetingDetailVC = [st
        instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
    meetingDetailVC.delegate = self;
    meetingDetailVC.statusEditMeeting = kAddNewMeetingTitle;
    meetingDetailVC.trainer = self.trainer;
    [self.navigationController pushViewController:meetingDetailVC animated:true];
}

#pragma mark - Show alert controller
- (void)showAlertControllerWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kReminderTitle
        message:kMessageReminder preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkActionTitle style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        MeetingManager *meetingManager = [[MeetingManager alloc] init];
        meetingManager.delegate = self;
        [meetingManager deleteMeeting:self.arrMeetings[indexPath.row]];
        _indexPath = indexPath;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kCancelActionTitle style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - MeetingDetailViewControllerDelegate
- (void)reloadDataMeetings:(Meeting *)meeting {
    if (!self.arrMeetings) {
        self.arrMeetings = [NSMutableArray array];
    }
    if ([[[DateFormatter sharedInstance] dateWithDateMonthYearFormatterFromString:meeting.fromDate] isEqualToString:
        [[DateFormatter sharedInstance] dateFormatterDateMonthYear:[NSDate date]]]) {
        [self.arrMeetings addObject:meeting];
        [self.tableView reloadData];
    }
}

- (void)updateMeeting:(Meeting *)meeting {
    [self.arrMeetings replaceObjectAtIndex:_indexPath.row withObject:meeting];
    [self.tableView reloadData];
}

@end
