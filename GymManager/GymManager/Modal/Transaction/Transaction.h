//
//  Transaction.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface Transaction : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) Customer *customer;

@end
