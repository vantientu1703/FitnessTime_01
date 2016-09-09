//
//  DetailMeetingPTViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/6/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DetailMeetingPTViewController.h"
#import "TodayMeetingTableViewCell.h"
#import "MeetingDetailViewController.h"

NSString *const kMessageSelectType = @"Select filter type";
NSString *const kAllMeetingTitle = @"All meetings";
NSString *const kSelectDateTitle = @"Select date";

@interface DetailMeetingPTViewController ()<MeetingDetailViewControllerDelegate, MeetingManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewMeeting;
@property (strong, nonatomic) NSMutableArray *arrMeetings;
@property (weak, nonatomic) IBOutlet UILabel *labelTimes;
@property (strong, nonatomic) NSMutableArray *arrMeetingFilters;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;

@end

@implementation DetailMeetingPTViewController
{
    NSIndexPath *_indexPath;
    NSString *_filter;
    NSDate *_dateSelected;
    BOOL _isRefresh;
    Meeting *_meetingInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self getAllMeetingsOfTrainer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoTrainerChanged:)
        name:kUpdateTrainerTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMeeting:)
        name:kAddNewMeetingTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoCustomerChanged:)
        name:kUpdateCustomer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMeetingToTabMeeting:)
        name:kUpdateMeeting object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        if ([_filter isEqualToString:kFilterTitle]) {
            [self.arrMeetingFilters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Meeting *meeting = (Meeting *)obj;
                Customer *customerInstance = meeting.customer;
                if (customer.id == customerInstance.id) {
                    meeting.customer = customer;
                    [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
                    return;
                }
            }];
        }
        [self.arrMeetings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Meeting *meeting = (Meeting *)obj;
            Customer *customerInstance = meeting.customer;
            if (customer.id == customerInstance.id) {
                meeting.customer = customer;
                [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
                return;
            }
        }];
        [self.tableView reloadData];
    }
}

- (void)createMeeting:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Meeting *meeting = userInfo[@"meeting"];
        if (!self.arrMeetings) {
            self.arrMeetings = [NSMutableArray array];
        }
        if (!self.arrMeetingFilters) {
            self.arrMeetingFilters = [NSMutableArray array];
        }
        NSString *fromDateString = [[DateFormatter sharedInstance]
            dateWithDateMonthYearFormatterFromString:meeting.fromDate];
        NSString *dateSelectedString = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:_dateSelected];
        if ([fromDateString isEqualToString:dateSelectedString] || [_filter isEqualToString:kFilterTitle]) {
            [self.arrMeetingFilters addObject:meeting];
        }
        [self.arrMeetings addObject:meeting];
        [self.tableView reloadData];
    }
}

- (void)infoTrainerChanged:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Trainer *trainer = userInfo[@"trainer"];
        if ([_filter isEqualToString:kFilterTitle]) {
            [self.arrMeetingFilters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Meeting *meeting = (Meeting *)obj;
                Trainer *trainerInstance = meeting.trainer;
                if (trainer.id == trainerInstance.id) {
                    meeting.trainer = trainer;
                    [self.arrMeetings replaceObjectAtIndex:idx withObject:meeting];
                    return;
                }
            }];
        }
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
#pragma mark - Button add new meeting
- (IBAction)addNewMeetingPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    MeetingDetailViewController *meetingDetailVC = [st
        instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
    meetingDetailVC.delegate = self;
    meetingDetailVC.statusEditMeeting = kAddNewMeetingTitle;
    meetingDetailVC.trainer = self.trainer;
    [self.navigationController pushViewController:meetingDetailVC animated:true];
}

- (void)getAllMeetingsOfTrainer {
    if (!_isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        _isRefresh = false;
    }
    MeetingManager *meetingManager = [[MeetingManager alloc] init];
    meetingManager.delegate = self;
    [meetingManager getMeetingsWithTrainer:self.trainer];
}

#pragma mark - MeetingManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrMeetings {
    [self.refreshReloadData endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (error) {
        [AlertManager showAlertWithTitle:kRegisterRequest message:message
            viewControler:self reloadAction:^{
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
            if ([_filter isEqualToString:kFilterTitle]) {
                [self.arrMeetingFilters removeObjectAtIndex:_indexPath.row];
            }
            [self.arrMeetings removeObject:_meetingInstance];
            [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSDictionary *userInfo = @{@"meeting": _meetingInstance};
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteMeetingSuccess object:nil
                userInfo:userInfo];
        }];
    } else {
        [AlertManager showAlertWithTitle:kReminderTitle message:kDeleteMeetingFail
            viewControler:self okAction:^{
        }];
    }
}

- (void)setupView {
    _dateSelected = [NSDate date];
    self.labelTimes.text = kAllMeetingTitle;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = kDetailMeetingsTrainerVCTitle;
    self.buttonAddNewMeeting.layer.cornerRadius = kCornerRadiusButton;
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kIconCalendar]
        style:UIBarButtonItemStylePlain target:self action:@selector(showAlertFilter)];
    self.navigationItem.rightBarButtonItem = calendarButton;
    // Reload data when disconect internet
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataTableView:)
        forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshReloadData atIndex:0];
}

- (IBAction)reloadDataTableView:(id)sender {
    _isRefresh = true;
    [self getAllMeetingsOfTrainer];
    if ([_filter isEqualToString:kFilterTitle]) {
        [self filterMeetingsWithDate:_dateSelected];
    }
}

- (void)showAlertFilter {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kReminderTitle
        message:kMessageSelectType preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allMeetingFilterAction = [UIAlertAction actionWithTitle:kAllMeetingTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _filter = @"";
        self.labelTimes.text = kAllMeetingTitle;
        [self.tableView reloadData];
    }];
    UIAlertAction *selectDateAction = [UIAlertAction actionWithTitle:kSelectDateTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCalendar];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kCancelActionTitle style:UIAlertActionStyleCancel
        handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:allMeetingFilterAction];
    [alertController addAction:selectDateAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)showCalendar {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        _filter = kFilterTitle;
        _dateSelected = dateSelected;
        self.labelTimes.text = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:dateSelected];
        [self filterMeetingsWithDate:dateSelected];
    }];
    [self.navigationController pushViewController:calendarVC animated:true];
}

#pragma mark - Filter meetings
- (void)filterMeetingsWithDate:(NSDate *)dateSelected {
    self.arrMeetingFilters = [NSMutableArray array];
    for (Meeting *meeting in self.arrMeetings) {
        NSString *fromDateString = [[DateFormatter sharedInstance]
            dateWithDateMonthYearFormatterFromString:meeting.fromDate];
        NSString *dateSelectedString = [[DateFormatter sharedInstance] dateFormatterDateMonthYear:dateSelected];
        if ([fromDateString isEqualToString:dateSelectedString]) {
            [self.arrMeetingFilters addObject:meeting];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_filter isEqualToString:kFilterTitle]) {
        return self.arrMeetingFilters.count;
    }
    return self.arrMeetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayMeetingTableViewCell *cell = (TodayMeetingTableViewCell *)[tableView
        dequeueReusableCellWithIdentifier:kTodayMeetingTableViewCellIdentifier forIndexPath:indexPath];
    Meeting *meeting;
    if ([_filter isEqualToString:kFilterTitle]) {
        meeting = self.arrMeetingFilters[indexPath.row];
    } else {
        meeting = self.arrMeetings[indexPath.row];
    }
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

#pragma mark - Show alert controller
- (void)showAlertControllerWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kReminderTitle
        message:kMessageReminder preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkActionTitle style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        MeetingManager *meetingManager = [[MeetingManager alloc] init];
        meetingManager.delegate = self;
        if ([_filter isEqualToString:kFilterTitle]) {
            _meetingInstance = self.arrMeetingFilters[indexPath.row];
        } else {
            _meetingInstance = self.arrMeetings[_indexPath.row];
        }
        [meetingManager deleteMeeting:_meetingInstance];
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
    [self.arrMeetings addObject:meeting];
    [self.tableView reloadData];
}

- (void)updateMeeting:(Meeting *)meeting {
    [self.arrMeetings replaceObjectAtIndex:_indexPath.row withObject:meeting];
    [self.tableView reloadData];
}

@end
