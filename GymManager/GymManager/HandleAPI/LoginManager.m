//
//  Service.m
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "LoginManager.h"
#import "User.h"

@implementation LoginManager

- (void)doLoginWithEmail:(NSString *)email password:(NSString *)password {
    //TODO check input before request
    NSDictionary *params = @{@"email": email, @"password": password};
    NSString *url = [NSString stringWithFormat:@"%@%@", URLRequest, kLoginRequest];
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        User *user = [[User alloc] initWithDictionary:responseObject[@"user"] error:&error];
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnUser:)]) {
            if (error) {
                [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnUser:nil];
            } else {
                [self.delegate didResponseWithMessage:@"OK" withError:nil returnUser:user];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnUser:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnUser:nil];
        }
    }];
}

@end
