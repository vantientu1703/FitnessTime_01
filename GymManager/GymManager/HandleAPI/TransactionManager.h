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
- (void)didDeleteTransctionWithMessage:(NSString *)message withError:(NSError *)error atSection:(NSInteger)section;

@end

@interface TransactionManager : Manager

@property (strong, nonatomic) id<TransactionManagerDelegate> delegate;
- (void)fetchAllTransactionByUser:(User *)user;
- (void)deleteTransaction:(Transaction *)transaction byUser:(User *)user atSection:(NSInteger)section;

@end
