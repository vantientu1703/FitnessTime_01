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

NSString *const kTodayMeetingTableViewCellIdentifier = @"TodayMeetingTableViewCell";
CGFloat const kHeightCellTodayMeetingTableViewCell = 102.0f;

@interface TodayMeetingsViewController ()<UITableViewDelegate, UITableViewDataSource, MeetingManagerDelegate, MeetingDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddMeeting;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrMeetings;

@end

@implementation TodayMeetingsViewController

#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self getAllMeetngsToday];
}

- (void)getAllMeetngsToday {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    MeetingManager *meetingManager = [[MeetingManager alloc] init];
    meetingManager.delegate = self;
    [meetingManager getAllMeetings];
}

#pragma mark - MeetingManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrMeetings {
    if (error) {
        [AlertManager showAlertWithTitle:kRegisterRequest message:message
            viewControler:self reloadAction:^{
            [self getAllMeetngsToday];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        self.arrMeetings = arrMeetings.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)setupView {
    if ([self.statusDetailMeeting isEqualToString:kTodayMeetingsVCTitle]) {
        self.title = kTodayMeetingsVCTitle;
    } else {
        self.title = kDetailMeetingsTrainerVCTitle;
    }
    if (![self.statusDetailMeeting isEqualToString:kDetailMeetingsTrainerVCTitle]) {
        UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kIconCalendar]
            style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar:)];
        self.navigationItem.rightBarButtonItem = calendarButton;
    }
    self.buttonAddMeeting.layer.cornerRadius = kCornerRadiusButton;
}

#pragma mark - Show calendar
- (IBAction)showCalendar:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil];
    CalendarViewController *calendarVC = [st instantiateInitialViewController];
    [self.navigationController pushViewController:calendarVC animated:true];
    [calendarVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        //TODO
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
            [self.navigationController pushViewController:meetingDetailVC animated:true];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
        title:kDeleteActionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self showAlertController];
    }];
    return @[deleteAction, editAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Button add new meeting
- (IBAction)buttonAddMeetingPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    MeetingDetailViewController *meetingDetailVC = [st
        instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
    meetingDetailVC.delegate = self;
    meetingDetailVC.statusEditMeeting = kAddNewMeetingTitle;
    [self.navigationController pushViewController:meetingDetailVC animated:true];
}

#pragma mark - Show alert controller
- (void)showAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kReminderTitle
        message:kMessageReminder preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkActionTitle style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
        //TODO
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

@end
