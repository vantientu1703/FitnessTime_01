//
//  AddTransactionManager.h
//  GymManager
//
//  Created by Thinh on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"
#import "Transaction.h"
#import "Item.h"

@protocol AddTransactionManagerDelegate <NSObject>

- (void)didCreateTransaction:(Transaction *)transaction withMessage:(NSString *)message withError:(NSError *)error;

@end

@interface AddTransactionManager : Manager

@property (strong, nonatomic) id<AddTransactionManagerDelegate> delegate;
- (void)createTransaction:(Transaction *)transaction byUser:(User *)user;

@end
