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

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *fromDate;
@property (strong, nonatomic) NSString *toDate;
@property (strong, nonatomic) Trainer *trainer;
@property (strong, nonatomic) Customer *customer;

@end
