//
//  PT.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Trainer.h"

@interface Trainer : Person

@property (strong, nonatomic) NSDate<Optional> *startWorkDate;
@property (strong, nonatomic) NSArray<Optional> *meetings;
@property (assign, nonatomic) CGFloat meetingMoney;
- (NSURL *)avatarURL;

@end
