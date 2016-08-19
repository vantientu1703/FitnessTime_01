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
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet RSDFDatePickerView *datePickerView;
@property (weak, nonatomic) IBOutlet SRMonthPicker *monthYearPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;
@property (nonatomic) NSInteger startYear;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Calendar";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //Setup Day View
    self.dateSelected = [NSDate date];
    self.datePickerView.delegate = self;
    //Setup Month view
    self.monthYearPicker.delegate = self;
    self.formatter = [[NSDateFormatter alloc] init];
    [self didSelectDaySegment];
    //Setup Year view
    self.formatter.dateFormat = @"yyyy";
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *startYear = [cal dateByAddingUnit:NSCalendarUnitYear value:-(kYearPickerRange / 2) toDate:[NSDate date]
        options:0];
    self.startYear = [self.formatter stringFromDate:startYear].integerValue;
    self.dateSelected = [self.formatter dateFromString:[NSString stringWithFormat:@"%d", self.startYear]];
    self.yearPicker.dataSource = self;
    self.yearPicker.delegate = self;
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
    return [NSString stringWithFormat:@"%d", (self.startYear + row)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.dateSelected = [self.formatter dateFromString:[NSString stringWithFormat:@"%d", (self.startYear + row)]];
}

#pragma mark - Day picker implementation
- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date {
    self.callBackBlock(date, CalendarPickerStateDay);
}

#pragma mark - action hanlder
- (IBAction)btnPickClick:(id)sender {
    CalendarPickerState state;
    NSDate *date;
    switch (self.segment.selectedSegmentIndex) {
        case CalendarPickerStateMonth:
            state = CalendarPickerStateMonth;
            date = self.monthYearPicker.date;
            break;
        default:
            state = CalendarPickerStateYear;
            date = self.dateSelected;
            break;
    }
    self.callBackBlock(date, state);
}

- (IBAction)segmentClicked:(id)sender {
    UISegmentedControl *segment = sender;
    switch (segment.selectedSegmentIndex) {
        case CalendarPickerStateDay:
            [self didSelectDaySegment];
            break;
        case CalendarPickerStateMonth:
            [self didSelectMonthSegment];
            break;
        default:
            [self didSelectYearSegment];
            break;
    }
}

- (void)didSelectDaySegment {
    self.formatter.dateFormat = @"dd\nMMMM\nyyyy";
    self.lbDateSelected.text =[self.formatter stringFromDate:[NSDate date]];
    self.datePickerView.hidden = NO;
    self.monthYearPicker.hidden = YES;
    self.yearPicker.hidden = YES;
    self.btnPick.hidden = YES;
}

- (void)didSelectMonthSegment {
    self.datePickerView.hidden = YES;
    self.monthYearPicker.hidden = NO;
    self.yearPicker.hidden = YES;
    self.btnPick.hidden = NO;
}

- (void)didSelectYearSegment {
    self.datePickerView.hidden = YES;
    self.monthYearPicker.hidden = YES;
    self.yearPicker.hidden = NO;
    self.btnPick.hidden = NO;
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
