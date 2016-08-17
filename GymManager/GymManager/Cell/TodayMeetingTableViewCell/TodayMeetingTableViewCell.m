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

- (void)setupCellWithNameTrainer:(NSString *)nameTrainer nameTrainee:(NSString *)nameTrainee
    withDate:(NSString *)date andHour:(NSString *)hour andPhoneNumber:(NSString *)phoneNumber {
    self.labelDateMothYear.text = date;
    self.labelHour.text = hour;
    self.labelNameTrainee.text = nameTrainee;
    self.labelNameTrainner.text = nameTrainer;
    self.labelPhoneNumber.text = phoneNumber;
}

@end
