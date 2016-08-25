//
//  Transaction.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Customer.h"

@interface Transaction : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray<Item> *items;
@property (strong, nonatomic) NSString *customerName;
@property (strong, nonatomic) NSString<Optional> *customerId;
@property (nonatomic) NSInteger totalCost;

@end
