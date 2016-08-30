//
//  MeetingDetailViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetingDetailViewControllerDelegate <NSObject>
@optional
- (void)reloadDataMeetings:(Meeting *)meeting;
- (void)updateMeeting:(Meeting *)meeting;
@end

@interface MeetingDetailViewController : UIViewController
@property (weak, nonatomic) id<MeetingDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *statusEditMeeting;
@property (strong, nonatomic) Meeting *meeting;
@end
