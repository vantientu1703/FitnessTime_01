//
//  AddTransactionManager.m
//  GymManager
//
//  Created by Thinh on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddTransactionManager.h"

NSString *const kOrderAtribute = @"order[order_items_attributes]";
NSString *const kOrderKeyId = @"[item_id]";
NSString *const kOrderkeyQuantity = @"[quantity]";

@implementation AddTransactionManager

- (void)createTransaction:(Transaction *)transaction byUser:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@", URLRequestTransaction];
    NSMutableDictionary *params = @{@"auth_token": user.authToken, @"order[user_id]": transaction.userId}.mutableCopy;
    [transaction.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Item *item = (Item*)obj;
        [params setValue:item.id forKey:[self itemKey:kOrderKeyId atIndex:idx]];
        [params setValue:item.quantity.stringValue forKey:[self itemKey:kOrderkeyQuantity atIndex:idx]];
    }];
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        Transaction *tran = [self transactionByResponse:responseObject error:error];
        if ([self.delegate respondsToSelector:@selector(didCreateTransaction:withMessage:withError:)]) {
            [self.delegate didCreateTransaction:tran withMessage:responseObject[@"messages"] withError:error];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didCreateTransaction:withMessage:withError:)]) {
            [self.delegate didCreateTransaction:nil withMessage:error.localizedDescription withError:error];
    }}];
}

- (void)editTransaction:(Transaction *)transaction byUser:(User *)user atIndexPath:(NSIndexPath *)indexPath {
    NSString *url = [NSString stringWithFormat:@"%@/%@", URLRequestTransaction, transaction.id];
    NSMutableDictionary *params = @{@"auth_token": user.authToken, @"order[user_id]": transaction.userId}.mutableCopy;
    [transaction.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Item *item = (Item*)obj;
        [params setValue:item.id forKey:[self itemKey:kOrderKeyId atIndex:idx]];
        [params setValue:item.quantity.stringValue forKey:[self itemKey:kOrderkeyQuantity atIndex:idx]];
    }];
    [self.manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Transaction *tran = [[Transaction alloc] initWithDictionary:responseObject error:&error];
        if ([self.delegate respondsToSelector:@selector(didEditTransaction:withMessage:withError:atIndexPath:)]) {
            [self.delegate didEditTransaction:tran withMessage:responseObject[@"messages"] withError:error
                atIndexPath:indexPath];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didEditTransaction:withMessage:withError:atIndexPath:)]) {
            [self.delegate didEditTransaction:nil withMessage:error.localizedDescription withError:error
                atIndexPath:indexPath];
        }
    }];
}

- (Transaction *)transactionByResponse:(NSDictionary *)response error:(NSError*)error {
    Transaction *transaction = [[Transaction alloc] initWithDictionary:response error:&error];
    if (!error) {
        NSMutableArray *items = @[].mutableCopy;
        NSArray *orderItems = response[@"order_items"];
        for (NSDictionary *itemDict in orderItems) {
            NSError *itemError;
            Item *item = [[Item alloc] initWithDictionary:itemDict[@"item"] error:&itemError];
            if (!itemError) {
                item.quantity = @(((NSString*)itemDict[@"quantity"]).integerValue);
                [items addObject:item];
            }
        }
        transaction.items = items.copy;
    }
    return transaction;
}

- (NSString *)itemKey:(NSString *)key atIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%@[%lu]%@", kOrderAtribute, (unsigned long)index, key];
}

@end
