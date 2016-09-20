//
//  NotificationManager.h
//  GymManager
//
//  Created by Thinh on 9/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (instancetype)sharedManager;
- (void)addNewMeeting:(Meeting *)meeting;
- (void)removeMeeting:(Meeting *)meeting;
- (void)editMeeting:(Meeting *)meeting;

@end
