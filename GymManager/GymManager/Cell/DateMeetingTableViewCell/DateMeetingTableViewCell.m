//
//  DateMeetingTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DateMeetingTableViewCell.h"

@implementation DateMeetingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configForCellWithDate:(NSString *)dateString andTitleFrom:(NSString *)fromTitle{
    self.labelDateMeeting.text = dateString;
    self.labelFromTitle.text = fromTitle;
}

@end
