//
//  TrainerManager.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TrainerManager.h"

@implementation TrainerManager
- (void)getAllTrainers {
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kAPIUser];
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSDictionary *params = @{@"auth_token": user.authToken, @"role": @"trainer"};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *allTrainers = [self trainersByResponseArray:responseObject error:error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
                [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:allTrainers];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:nil];
        }
    }];
}

- (void)createNewTrainer:(Trainer *)trainer {
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kAPIUser];
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSDictionary *params = @{@"auth_token": user.authToken, @"user[full_name]": trainer.fullName,
                             @"user[tel_number]": trainer.telNumber, @"user[address]": trainer.address,
                             @"user[role]": @"trainer",
                             @"user[birthday]": [[DateFormatter sharedInstance]
                                dateFormatterDateMonthYear:trainer.birthday],
                             @"user[avatar]": trainer.avatar,
                             @"user[meeting_money]": [NSString stringWithFormat:@"%f", trainer.meetingMoney]};
    
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Trainer *trainer = [[Trainer alloc] initWithDictionary:responseObject error:&error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(createdTrainerWithMessage:withError:returnTrainer:)]) {
                [self.delegate createdTrainerWithMessage:true withError:error returnTrainer:trainer];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(createdTrainerWithMessage:withError:returnTrainer:)]) {
            [self.delegate createdTrainerWithMessage:false withError:error returnTrainer:nil];
        }
    }];
}

- (void)updateTrainer:(Trainer *)trainer {
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", kURLAPI, kAPIUser,trainer.id];
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSDictionary *params = @{@"auth_token": user.authToken, @"user[full_name]": trainer.fullName,
                             @"user[birthday]": trainer.birthday, @"user[tel_number]": trainer.telNumber,
                             @"user[address]": trainer.address,
                             @"user[meeting_money]": [NSString stringWithFormat:@"%f",trainer.meetingMoney],
                             @"user[avatar]": trainer.avatar, @"user[role]": @"trainer"};
    [self.manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Trainer *trainer = [[Trainer alloc] initWithDictionary:responseObject error:&error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(updateTrainerWithMessage:withError:returnTrainer:)]) {
                [self.delegate updateTrainerWithMessage:true withError:error returnTrainer:trainer];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(updateTrainerWithMessage:withError:returnTrainer:)]) {
            [self.delegate updateTrainerWithMessage:true withError:error returnTrainer:trainer];
        }
    }];
}

- (NSArray *)trainersByResponseArray:(NSArray *)responseArr error:(NSError*)error {
    NSMutableArray *trainers = @[].mutableCopy;
    for (NSDictionary *dict in responseArr) {
        Trainer *trainer = [[Trainer alloc] initWithDictionary:dict error:&error];
        if (!error) {
            [trainers addObject:trainer];
        }
    }
    return trainers;
}
     
@end
