//
//  TransactionManager.m
//  GymManager
//
//  Created by Thinh on 8/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TransactionManager.h"

@implementation TransactionManager

- (void)fetchAllTransactionByUser:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kTransactionRequest];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        NSArray *trans = [self transactionsByResponseArray:responseObject error:error];
        if ([self.delegate
            respondsToSelector:@selector(didFetchAllTransctionWithMessage:withError:returnTransactions:)]) {
            [self.delegate didFetchAllTransctionWithMessage:error.localizedDescription withError:error
                returnTransactions:trans];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate
            respondsToSelector:@selector(didFetchAllTransctionWithMessage:withError:returnTransactions:)]) {
            [self.delegate didFetchAllTransctionWithMessage:error.localizedDescription withError:error
                returnTransactions:nil];
        }
    }];
}

- (NSArray*)transactionsByResponseArray:(NSArray *)responseArr error:(NSError*)error {
    NSMutableArray *trans = @[].mutableCopy;
    for (NSDictionary *dict in responseArr) {
        Transaction *tran = [[Transaction alloc] initWithDictionary:dict error:&error];
        if (!error) {
            NSMutableArray *items = @[].mutableCopy;
            NSArray *orderItems = dict[@"order_items"];
            for (NSDictionary *itemDict in orderItems) {
                NSError *itemError;
                Item *item = [[Item alloc] initWithDictionary:itemDict[@"item"] error:&itemError];
                if (!itemError) {
                    item.quantity = @(((NSString*)itemDict[@"quantity"]).integerValue);
                    [items addObject:item];
                }
            }
            tran.items = items.copy;
            [trans addObject:tran];
        }
    }
    return trans;
}

@end
