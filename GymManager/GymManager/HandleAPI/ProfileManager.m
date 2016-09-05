//
//  ProfileManager.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ProfileManager.h"

@implementation ProfileManager

- (void)updateProfile:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", kURLAPI, kManager, user.id];
    NSDictionary *params = @{@"auth_token": user.authToken, @"manager[full_name]": user.fullName,
                             @"manager[address]": user.address, @"manager[tel_number]": user.telNumber,
                             @"manager[avatar]": user.avatar, @"manager[birthday]": [[DateFormatter sharedInstance]
                                dateFormatterDateMonthYear:user.birthday]};
    [self.manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        User *user = [[User alloc] initWithDictionary:responseObject[@"manager"] error:&error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(updateProfile:success:error:)]) {
                [self.delegate updateProfile:user success:true error:error];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(updateProfile:)]) {
            [self.delegate updateProfile:nil success:false error:error];
        }
    }];
}

- (void)logout {
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kLogout];
    User *user = [[DataStore sharedDataStore] getUserManage];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager DELETE:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(logoutSuccess:error:)]) {
            [self.delegate logoutSuccess:false error:error];
        }
    }];
}

@end
