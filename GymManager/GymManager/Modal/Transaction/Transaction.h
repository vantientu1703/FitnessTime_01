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
@property (strong, nonatomic) NSArray<Item,Optional> *items;
@property (strong, nonatomic) NSString<Optional> *customerName;
@property (strong, nonatomic) NSString<Optional> *userId;
@property (strong, nonatomic) NSDate<Optional> *createdAt;
@property (strong, nonatomic) Customer<Optional> *user;
@property (nonatomic) NSInteger totalPrice;

@end
