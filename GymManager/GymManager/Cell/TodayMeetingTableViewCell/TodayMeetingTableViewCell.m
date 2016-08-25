//
//  TodayMeetingTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TodayMeetingTableViewCell.h"

NSString *const kTrainer = @"trainer";
NSString *const kCustomer = @"customer";
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
    [meeting.users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Trainer *trainer;
        Customer *customer;
        NSError *error;
        if ([obj[@"role"] isEqualToString:kTrainer]) {
            trainer = [[Trainer alloc] initWithDictionary:obj error:&error];
            self.labelNameTrainner.text = trainer.fullName;
        } else if ([obj[@"role"] isEqualToString:kCustomer]){
            customer = [[Customer alloc] initWithDictionary:obj error:&error];
            self.labelNameTrainee.text = customer.fullName;
            self.labelPhoneNumber.text = customer.telNumber;
        }
    }];
}

@end
