//
//  Meeting.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"
#import "Trainer.h"

@interface Meeting : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) Customer *customer;
@property (strong, nonatomic) Trainer *trainer;

@end
