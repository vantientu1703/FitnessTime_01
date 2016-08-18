//
//  Customer.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : Person

@property (strong, nonatomic) NSDate *registerDate;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSArray *meetings;

@end
