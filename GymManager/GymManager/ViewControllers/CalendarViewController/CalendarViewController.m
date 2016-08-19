//
//  CalendarViewController.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CalendarViewController.h"
#import "RSDFDatePickerView.h"
#import "NTMonthYearPicker.h"

@interface CalendarViewController () <RSDFDatePickerViewDelegate>

@property (strong, nonatomic) void(^callBackBlock)(NSDate *date);
@property (strong, nonatomic) RSDFDatePickerView *datePickerView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Calendar";
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.datePickerView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.datePickerView = [[RSDFDatePickerView alloc] initWithFrame:self.view.bounds];
    self.datePickerView.delegate = self;
    self.view = self.datePickerView;
}

#pragma mark - Calendar Delegate
- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date {
    //TODO callback after picked date
    self.callBackBlock(date);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPickDateWithCompletionBlock:(void(^)(NSDate* dateSelected))callBackBlock {
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
