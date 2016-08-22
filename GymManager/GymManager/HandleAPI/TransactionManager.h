//
//  TransactionManager.h
//  GymManager
//
//  Created by Thinh on 8/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"
#import "Transaction.h"

@protocol TransactionManagerDelegate <NSObject>

- (void)didFetchAllTransctionWithMessage:(NSString *)message withError:(NSError *)error returnTransactions:(NSArray*)
    transactions;

@end

@interface TransactionManager : Manager

@property (strong, nonatomic) id<TransactionManagerDelegate> delegate;
- (void)fetchAllTransaction;

@end
