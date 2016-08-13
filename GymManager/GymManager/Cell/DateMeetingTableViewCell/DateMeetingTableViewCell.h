//
//  DateMeetingTableViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateMeetingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDateMeeting;
@property (weak, nonatomic) IBOutlet UILabel *labelFromTitle;
- (void)configForCellWithDate:(NSString *)dateString andTitleFrom:(NSString *)fromTitle;

@end
