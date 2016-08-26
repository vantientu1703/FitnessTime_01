//
//  RegisterManager.m
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "RegisterManager.h"

@implementation RegisterManager

- (void)doRegisterWithUser:(User *)user {
     //TODO check input before request
    NSString *url = [NSString stringWithFormat:@"%@%@", URLRequest, kRegisterRequest];
    //TODO : Params
    NSDictionary *params = @{@"email": user.email, @"password": user.password, @"full_name": user.fullName,
                             @"birthday": user.birthday, @"address": user.address};
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        User *user = [[User alloc] initWithDictionary:responseObject[@"user"] error:nil];
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnUser:)]) {
            [self.delegate didResponseWithMessage:@"OK" withError:nil returnUser:user];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnUser:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnUser:nil];
        }
    }];
}

@end
