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

@interface PTMeetingViewController : UIViewController
@property (weak, nonatomic) id<PTMeetingViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *statusAddNewMeeting;
@end
