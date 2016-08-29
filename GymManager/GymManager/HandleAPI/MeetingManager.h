//
//  MeetingManager.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"
#import "Meeting.h"

@protocol MeetingManagerDelegate <NSObject>

- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrMeetings;
- (void)didResponseWithMessage:(NSString *)message withDate:(NSDate *)date
    withError:(NSError *)error returnArray:(NSArray *)arrMeetings;
- (void)createMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error;
- (void)updateMeetingItem:(Meeting *)meeting success:(BOOL)success error:(NSError *)error;

@end

@interface MeetingManager : Manager
@property (weak, nonatomic) id<MeetingManagerDelegate> delegate;
- (void)getAllMeetings;
- (void)createMeetingWithTrainer:(Trainer *)trainer withTrainee:(Customer *)customer
    fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)getAllMeetingsWithDate:(NSDate *)date;
@end
