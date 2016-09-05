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
    NSError *error;
    Trainer *trainer = [[Trainer alloc] initWithDictionary:dict[@"trainer"] error:&error];
    if (!error) {
        meeting.trainer = trainer;
    }
    Customer *customer = [[Customer alloc] initWithDictionary:dict[@"customer"] error:&error];
    if (!error) {
        meeting.customer = customer;
    }
    return meeting;
}

@end
