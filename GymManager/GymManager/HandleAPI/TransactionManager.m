//
//  TransactionManager.m
//  GymManager
//
//  Created by Thinh on 8/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TransactionManager.h"

@implementation TransactionManager

- (void)fetchAllTransaction {
    NSString *url = [NSString stringWithFormat:@"%@%@", URLRequest, kGetAllTransactionRequest];
    NSDictionary *params = @{};
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        NSArray *trans = [self transactionsByResponseArray:responseObject[@"transactions"] error:error];
        if ([self.delegate
            respondsToSelector:@selector(didFetchAllTransctionWithMessage:withError:returnTransactions:)]) {
            if (error) {
                [self.delegate didFetchAllTransctionWithMessage:error.description withError:error
                    returnTransactions:nil];
            } else {
                [self.delegate didFetchAllTransctionWithMessage:@"" withError:nil returnTransactions:trans];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate
            respondsToSelector:@selector(didFetchAllTransctionWithMessage:withError:returnTransactions:)]) {
            [self.delegate didFetchAllTransctionWithMessage:error.description withError:error
                returnTransactions:nil];
        }
    }];
}

- (NSArray*)transactionsByResponseArray:(NSArray *)responseArr error:(NSError*)error {
    NSMutableArray *trans = @[].mutableCopy;
    for (NSDictionary *dict in responseArr) {
        Transaction *tran = [[Transaction alloc] initWithDictionary:dict error:&error];
        if (error) {
            continue;
        } else {
            [trans addObject:tran];
        }
    }
    return trans;
}

@end
