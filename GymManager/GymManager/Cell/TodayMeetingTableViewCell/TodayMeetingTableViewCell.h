//
//  TodayMeetingTableViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayMeetingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelHour;
@property (weak, nonatomic) IBOutlet UILabel *labelDateMothYear;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainner;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainee;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
- (void)setupCellWithNameTrainer:(NSString *)nameTrainer nameTrainee:(NSString *)nameTrainee
    withDate:(NSString *)date andHour:(NSString *)hour andPhoneNumber:(NSString *)phoneNumber;

@end
