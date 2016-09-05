//
//  TodayMeetingTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TodayMeetingTableViewCell.h"

CGFloat const kCornerRadius = 5.0f;

@implementation TodayMeetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewBackground.layer.cornerRadius = kCornerRadius;
}

- (void)cellWithMeeting:(Meeting *)meeting {
    self.labelFromDateMothYear.text = [[DateFormatter sharedInstance]
        dateWithDateMonthYearFormatterFromString:meeting.fromDate];
    self.labelFromHour.text = [[DateFormatter sharedInstance] dateWithHourFormatterFromString:meeting.fromDate];
    self.labelToDateMothYear.text = [[DateFormatter sharedInstance]
        dateWithDateMonthYearFormatterFromString:meeting.toDate];
    self.labelToHour.text = [[DateFormatter sharedInstance] dateWithHourFormatterFromString:meeting.toDate];
    self.labelNameTrainee.text = meeting.customer.fullName;
    self.labelNameTrainner.text = meeting.trainer.fullName;
}

@end
