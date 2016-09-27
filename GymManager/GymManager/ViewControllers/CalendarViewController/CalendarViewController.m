//
//  CalendarViewController.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CalendarViewController.h"
#import "RSDFDatePickerView.h"
#import "SRMonthPicker.h"

NSInteger const kYearConstBySecond = 31536000;
NSInteger const kYearPickerRange = 20;

@interface CalendarViewController () <RSDFDatePickerViewDelegate,SRMonthPickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (copy, nonatomic) void(^callBackBlock)(NSDate *date, CalendarPickerState state);
@property (weak, nonatomic) IBOutlet UIButton *btnPick;
@property (weak, nonatomic) IBOutlet UILabel *lbDateSelected;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet SRMonthPicker *monthYearPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;
@property (nonatomic) NSInteger startYear;
@property (strong, nonatomic) DateFormatter *formatter;
@property (strong, nonatomic) NSDate *dateSelected;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Calendar";
    self.navigationItem.backBarButtonItem.title = @"";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //Setup Day
    self.formatter = [DateFormatter sharedInstance];
    self.dateSelected = [NSDate date];
    [self setTodayLabel];
    [self pickerWithState:self.state];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Year picker implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kYearPickerRange;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (self.startYear + row)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.dateSelected = [self.formatter dateFromYearString:[NSString stringWithFormat:@"%ld", (self.startYear + row)]];
}

#pragma mark - Day picker implementation
- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date {
    self.callBackBlock(date, CalendarPickerStateDay);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action hanlder
- (IBAction)btnPickClick:(id)sender {
    NSDate *date;
    switch (self.state) {
        case CalendarPickerStateYear:
            date = self.dateSelected;
            break;
        case CalendarPickerStateMonth:
            date = self.monthYearPicker.date;
            break;
        default:
            date = self.datePickerView.date;
            break;
    }
    self.callBackBlock(date, self.state);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerWithState:(CalendarPickerState)state {
    switch (state) {
        case CalendarPickerStateDay:
            [self didSelectDaySegment];
            break;
        case CalendarPickerStateMonth:
            [self didSelectMonthSegment];
            break;
        case CalendarPickerStateTime:
            [self didSelectTimeSegment];
            break;
        default:
            [self didSelectYearSegment];
            break;
    }
}

- (void)setTodayLabel {
    self.lbDateSelected.text = [self.formatter stringFromDate:[NSDate date] withFormat:DateFormatterTypeCalendarToday];
}

- (void)didSelectDaySegment {
    self.datePickerView.hidden = NO;
    self.monthYearPicker.hidden = YES;
    self.yearPicker.hidden = YES;
}

- (void)didSelectMonthSegment {
    //Setup Month view
    self.monthYearPicker.delegate = self;
    self.datePickerView.hidden = YES;
    self.monthYearPicker.hidden = NO;
    self.yearPicker.hidden = YES;
}

- (void)didSelectYearSegment {
    //Set fisrt year in list
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *startYearDate = [cal dateByAddingUnit:NSCalendarUnitYear value:-(kYearPickerRange / 2) toDate:[NSDate date]
        options:0];
    self.startYear = [self.formatter yearStringFromDate:startYearDate].integerValue;
    self.dateSelected = [self.formatter dateFromYearString:[NSString stringWithFormat:@"%ld", self.startYear]];
    self.yearPicker.dataSource = self;
    self.yearPicker.delegate = self;
    self.datePickerView.hidden = YES;
    self.monthYearPicker.hidden = YES;
    self.yearPicker.hidden = NO;
}

- (void)didSelectTimeSegment {
    self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePickerView.hidden = NO;
    self.monthYearPicker.hidden = YES;
    self.yearPicker.hidden = YES;
}

- (void)didPickDateWithCompletionBlock:(void(^)(NSDate* dateSelected, CalendarPickerState state))callBackBlock {
    self.callBackBlock = callBackBlock;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
