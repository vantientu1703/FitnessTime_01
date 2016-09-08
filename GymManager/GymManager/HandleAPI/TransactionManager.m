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
    NSString *url = [NSString stringWithFormat:@"%@", URLRequestTransaction];
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

- (void)fetchAllTransactionByUser:(User *)user withFilterState:(CalendarPickerState)state date:(NSDate *)date {
    NSString *url = [NSString stringWithFormat:@"%@", URLRequestTransaction];
    NSDictionary *params = @{@"auth_token": user.authToken, @"filter_type": [self stringFilterTypeByEnum:state],
        @"date": [[DateFormatter sharedInstance] dateFormatterDateMonthYear:date]};
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

- (void)deleteTransaction:(Transaction *)transaction byUser:(User *)user  atSection:(NSInteger)section{
    NSString *url = [NSString stringWithFormat:@"%@/%@", URLRequestTransaction, transaction.id];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager DELETE:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(didDeleteTransctionWithMessage:withError:atSection:)]) {
            [self.delegate didDeleteTransctionWithMessage:responseObject[@"messages"] withError:nil atSection:section];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didDeleteTransctionWithMessage:withError:atSection:)]) {
            [self.delegate didDeleteTransctionWithMessage:nil withError:error atSection:section];
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
                    item.orderItemId = itemDict[@"id"];
                    [items addObject:item];
                }
            }
            tran.items = items.copy;
            [trans addObject:tran];
        }
    }
    return trans;
}

- (NSString *)stringFilterTypeByEnum:(CalendarPickerState)state {
    switch (state) {
        case CalendarPickerStateDay:
            return @"day";
        case CalendarPickerStateYear:
            return @"year";
        default:
            return @"month";
    }
}

@end
