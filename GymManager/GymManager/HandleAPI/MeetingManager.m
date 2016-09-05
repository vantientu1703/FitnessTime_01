//
//  MeetingManager.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "MeetingManager.h"

@implementation MeetingManager

- (void)getAllMeetings {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kMeetings];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *meetings = [self meetingsByResponseArray:responseObject error:error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
                [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:meetings];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:nil];
        }
    }];
}

- (void)getAllMeetingsWithDate:(NSDate *)date {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kMeetings];
    NSDictionary *params = @{@"auth_token": user.authToken, @"date": date};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *meetings = [self meetingsByResponseArray:responseObject error:error];
        if (!error && [self.delegate respondsToSelector:@selector(didResponseWithMessage:withDate:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withDate:date withError:error returnArray:meetings];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:nil];
        }
    }];
}

- (void)getMeetingsWithTrainer:(Trainer *)trainer {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", kURLAPI, kAPIUser, trainer.id];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO
        NSError *error;
        NSArray *meetings = [self meetingsByResponseArray:responseObject error:error];
        if (!error && [self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:meetings];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!error && [self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:nil];
        }
    }];
}

- (void)createMeetingWithTrainer:(Trainer *)trainer withTrainee:(Customer *)customer fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    User *user = [[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kMeetings];
    NSDictionary *params = @{@"auth_token": user.authToken, @"meeting[from_date]": fromDate,
                             @"meeting[to_date]": toDate,
                             @"meeting[trainer_id]": trainer.id,
                             @"meeting[customer_id]": customer.id};
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject[@"errors"]) {
            Meeting *meeting = [ParseJson meetingWithDictionary:responseObject];
            if ([self.delegate respondsToSelector:@selector(createMeetingItem:success:error:)]) {
                [self.delegate createMeetingItem:meeting success:true error:nil];
            }
        } else {
            NSArray *errors = responseObject[@"errors"];
            if (errors.count) {
                if ([self.delegate respondsToSelector:@selector(createMeetingFaileWithMessage:)]) {
                    [self.delegate createMeetingFaileWithMessage:errors[0]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(createMeetingItem:success:error:)]) {
            [self.delegate createMeetingItem:nil success:false error:error];
        }
    }];
}

- (void)updateMeetingItem:(Meeting *)meeting withTrainer:(Trainer *)trainer withCustomer:(Customer *)customer fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    User *user = [[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", kURLAPI, kMeetings, meeting.id];
    NSDictionary *params = @{@"manager[id]": user.id, @"auth_token": user.authToken,
                             @"meeting[from_date]": fromDate, @"meeting[to_date]": toDate,
                             @"meeting[trainer_id]": trainer.id, @"meeting[customer_id]": customer.id};
    [self.manager PATCH:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject[@"errors"] && [self.delegate
            respondsToSelector:@selector(updateMeetingItem:success:error:)]) {
            Meeting *meeting = [ParseJson meetingWithDictionary:responseObject];
            [self.delegate updateMeetingItem:meeting success:true error:nil];
        } else {
            NSArray *errors = responseObject[@"errors"];
            if (errors.count && [self.delegate respondsToSelector:@selector(updateMeetingFailWithMessage:)]) {
                [self.delegate updateMeetingFailWithMessage:errors[0]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(updateMeetingItem:success:error:)]) {
            [self.delegate updateMeetingItem:nil success:true error:error];
        }
    }];
}

- (void)deleteMeeting:(Meeting *)meeting {
    User *user = [[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", kURLAPI, kMeetings, meeting.id];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager DELETE:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(didDeleteMeetingSuccess:error:)]) {
            [self.delegate didDeleteMeetingSuccess:true error:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didDeleteMeetingSuccess:error:)]) {
            [self.delegate didDeleteMeetingSuccess:false error:error];
        }
    }];
}

- (NSArray *)meetingsByResponseArray:(NSArray *)responseArr error:(NSError *)error {
    NSMutableArray *meetings = @[].mutableCopy;
    for (NSDictionary *dict in responseArr) {
        Meeting *meeting = [ParseJson meetingWithDictionary:dict];
        if (!error) {
            [meetings addObject:meeting];
        }
    }
    return meetings;
}

@end
