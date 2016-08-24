//
//  TrainerManager.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"
#import "DataStore.h"
#import "Trainer.h"
#import "User.h"

@protocol TrainerManagerDelegate <NSObject>
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrTrainer;
- (void)createdTrainerWithMessage:(BOOL)success withError:(NSError *)error returnTrainer:(Trainer *)trainer;
- (void)updateTrainerWithMessage:(BOOL)success withError:(NSError *)error returnTrainer:(Trainer *)trainer;
@end

@interface TrainerManager : Manager
@property (weak, nonatomic) id<TrainerManagerDelegate> delegate;
- (void)createNewTrainer:(Trainer *)trainer;
- (void)getAllTrainers;
- (void)updateTrainer:(Trainer *)trainer;
@end
