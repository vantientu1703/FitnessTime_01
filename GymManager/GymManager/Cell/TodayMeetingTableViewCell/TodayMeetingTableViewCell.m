//
//  TodayMeetingTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TodayMeetingTableViewCell.h"

CGFloat const kCornerRadius = 5.0f;
NSString *const kIconCircleBlue = @"ic_cirlce_blue";
NSString *const kIconCircleRed = @"ic_circle_red";

@implementation TodayMeetingTableViewCell
{
    NSInteger _phoneNumber;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewBackground.layer.cornerRadius = kCornerRadius;
}

- (void)cellWithMeeting:(Meeting *)meeting {
    _phoneNumber = [meeting.trainer.telNumber integerValue];
    self.labelFromHour.text = [[DateFormatter sharedInstance] stringHourDayMonthYearFromDateString:meeting.fromDate];
    self.labelToHour.text = [[DateFormatter sharedInstance] stringHourDayMonthYearFromDateString:meeting.toDate];
    self.labelNameTrainee.text = meeting.customer.fullName;
    self.labelNameTrainner.text = meeting.trainer.fullName;
    NSDate *fromDate = [[DateFormatter sharedInstance] dateWithMonthYearFormatterFromStringUTC:meeting.fromDate];
    double fromDateTime = [fromDate timeIntervalSince1970];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    if (currentTime < fromDateTime) {
        self.imageViewStatus.image = [UIImage imageNamed:kIconCircleBlue];
    } else {
        self.imageViewStatus.image = [UIImage imageNamed:kIconCircleRed];
    }
}

- (IBAction)callPhonePress:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%ld", _phoneNumber]]];
}

@end
