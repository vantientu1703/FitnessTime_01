//
//  ParseJson.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ParseJson.h"

@implementation ParseJson

+ (Meeting *)meetingWithDictionary:(NSDictionary *)dict {
    Meeting *meeting = [[Meeting alloc] init];
    meeting.id = dict[@"id"];
    meeting.fromDate = dict[@"from_date"];
    meeting.toDate = dict[@"to_date"];
    meeting.users = dict[@"users"];
    meeting.userMeetings = dict[@"user_meetings"];
    return meeting;
}

@end
