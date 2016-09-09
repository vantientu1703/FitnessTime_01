//
//  PushViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTMeetingViewControllerDelegate <NSObject>
- (void)selectedTrainer:(Trainer *)trainer;
@end

@interface PTMeetingViewController : BaseViewController
@property (weak, nonatomic) id<PTMeetingViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *statusAddNewMeeting;
@property (strong, nonatomic) Trainer *trainer;
@end
