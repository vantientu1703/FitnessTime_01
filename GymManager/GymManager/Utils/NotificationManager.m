//
//  NotificationManager.m
//  GymManager
//
//  Created by Thinh on 9/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager {
    NSString *_kNotificationDicKey;
    NSString *_kMeetingKey;
}

+ (instancetype)sharedManager {
    static NotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _kNotificationDicKey = @"MeetingDictionary";
        _kMeetingKey = @"Meeting";
    }
    return self;
}

- (void)addNewMeeting:(Meeting *)meeting {
    DateFormatter *formatter = [DateFormatter sharedInstance];
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.category = kNotiCallActionIdent;
    noti.alertBody = [NSString stringWithFormat:@"Trainer: %@\nCustomer: %@\nMeeting at: %@", meeting.trainer.fullName,
        meeting.customer.fullName, [formatter stringHourDayMonthYearFromDateString:meeting.fromDate]];
    //Set fire time sooner than 3 seconds
    NSDate *startMeetingDate = [formatter dateWithMonthYearFormatterFromStringUTC:meeting.fromDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *fireTime = [cal dateByAddingUnit:NSCalendarUnitSecond value:-3 toDate:startMeetingDate options:0];
    noti.fireDate = fireTime;
    //Set sound
    noti.soundName = UILocalNotificationDefaultSoundName;
    noti.userInfo = @{kNotiDictKeyId:meeting.id, kNotiDictKeyTrainer:meeting.trainer.fullName,
        kNotiDictKeyCustomer:meeting.customer.fullName, kNotiDictKeyTrainerPhone:meeting.trainer.telNumber};
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)editMeeting:(Meeting *)meeting {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *notifications = application.scheduledLocalNotifications;
    for (UILocalNotification *noti in notifications) {
        if ([meeting.id isEqualToString:noti.userInfo[kNotiDictKeyId]]) {
            noti.userInfo = @{kNotiDictKeyId:meeting.id, kNotiDictKeyTrainer:meeting.trainer.fullName,
                kNotiDictKeyCustomer:meeting.customer.fullName, kNotiDictKeyTrainerPhone:meeting.trainer.telNumber};
            break;
        }
    }
}

- (void)removeMeeting:(Meeting *)meeting {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *notifications = application.scheduledLocalNotifications;
    for (UILocalNotification *noti in notifications) {
        if ([meeting.id isEqualToString:noti.userInfo[kNotiDictKeyId]]) {
            [application cancelLocalNotification:noti];
            break;
        }
    }
}

@end
