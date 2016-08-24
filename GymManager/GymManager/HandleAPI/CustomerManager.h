//
//  CustomerManager.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"

@protocol CustomerManagerDelegate <NSObject>
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrCustomers;
- (void)createdCustomerWithMessage:(BOOL)success withError:(NSError *)error returnCustomer:(Customer *)customer;
- (void)updateCustomerWithMessage:(BOOL)success withError:(NSError *)error returnCustomer:(Customer *)customer;
@end

@interface CustomerManager : Manager

- (void)getAllCustomers;
- (void)createCustomer:(Customer *)customer;
@property (weak, nonatomic) id<CustomerManagerDelegate> delegate;

@end
