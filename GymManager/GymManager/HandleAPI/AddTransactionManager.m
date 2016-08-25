//
//  AddTransactionManager.m
//  GymManager
//
//  Created by Thinh on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddTransactionManager.h"

@implementation AddTransactionManager

- (void)createTransaction:(Transaction *)transaction byUser:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kTransactionRequest];
    NSMutableDictionary *params = @{@"auth_token": user.authToken,
                                    @"order[user_id]": transaction.customerId}.mutableCopy;
    for (NSUInteger index = 0; index < transaction.items.count; index++) {
        Item *item = transaction.items[index];
        [params setValue:item.id
            forKey:[NSString stringWithFormat:@"order[order_items_attributes][%d][item_id]",index]];
        [params setValue:item.quantity.stringValue
            forKey:[NSString stringWithFormat:@"order[order_items_attributes][%d][quantity]",index]];
        index++;
    }
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        Transaction *tran = [[Transaction alloc] initWithDictionary:responseObject error:&error];
        if ([self.delegate respondsToSelector:@selector(didCreateTransaction:withMessage:withError:)]) {
            [self.delegate didCreateTransaction:tran withMessage:responseObject[@"messages"] withError:error];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didCreateTransaction:withMessage:withError:)]) {
            [self.delegate didCreateTransaction:nil withMessage:error.localizedDescription withError:error];
    }}];
}

@end
