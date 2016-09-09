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
@property (weak, nonatomic) IBOutlet UILabel *labelFromHour;
@property (weak, nonatomic) IBOutlet UILabel *labelToHour;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainner;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainee;
- (void)cellWithMeeting:(Meeting *)meeting;

@end
