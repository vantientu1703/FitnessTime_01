//
//  CategoryManager.m
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CategoryManager.h"

@implementation CategoryManager

- (void)getAllItemsByUser:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@%@", URLRequest, kGetAllItemsRequest];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO Catch Network error, handle data
        NSError *error;
        NSArray *items = [self itemsByResponseArray:(NSArray *)responseObject error:error];
        if ([self.delegate respondsToSelector:@selector(didFetchAllItemsWithMessage:withError:returnItems:)]) {
            [self.delegate didFetchAllItemsWithMessage:error.localizedDescription withError:error returnItems:items];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didFetchAllItemsWithMessage:withError:returnItems:)]) {
            [self.delegate didFetchAllItemsWithMessage:error.localizedDescription withError:error returnItems:nil];
        }
    }];
}

- (void)createItem:(Item *)item ByUser:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@%@", URLRequest, kGetAllItemsRequest];
    NSDictionary *params = @{@"auth_token": user.authToken, @"item[name]": item.name,
        @"item[price]": [NSString stringWithFormat:@"%.0f", item.price], @"item[manager_id]": user.id};
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Item *newItem = [[Item alloc] initWithDictionary:responseObject error:&error];
        if ([self.delegate respondsToSelector:@selector(didCreateItem:WithMessage:withError:)]) {
            [self.delegate didCreateItem:newItem WithMessage:error.localizedDescription withError:error];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didCreateItem:WithMessage:withError:)]) {
            [self.delegate didCreateItem:item WithMessage:error.localizedDescription withError:error];
        }
    }];
}

- (void)updateItem:(Item *)item ByUser:(User *)user atIndexPath:(NSIndexPath *)indexPath{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", URLRequest, kGetAllItemsRequest, item.id];
    NSDictionary *params = @{@"auth_token": user.authToken, @"item[name]": item.name,
        @"item[price]": [NSString stringWithFormat:@"%.0f", item.price], @"item[manager_id]": user.id};
    [self.manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(didUpdateItem:WithMessage:withError:atIndexPath:)]) {
            [self.delegate didUpdateItem:item WithMessage:nil withError:nil atIndexPath:indexPath];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didUpdateItem:WithMessage:withError:atIndexPath:)]) {
            [self.delegate didUpdateItem:item WithMessage:error.localizedDescription withError:error
                atIndexPath:indexPath];
        }
    }];
}

- (void)deleteItem:(Item *)item ByUser:(User *)user atIndexPath:(NSIndexPath *)indexPath {
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", URLRequest, kGetAllItemsRequest, item.id];
    NSDictionary *params = @{@"auth_token": user.authToken};
    [self.manager DELETE:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(didDeleteItemWithMessage:withError:atIndexPath:)]) {
            [self.delegate didDeleteItemWithMessage:responseObject[@"messages"] withError:nil atIndexPath:indexPath];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didDeleteItemWithMessage:withError:atIndexPath:)]) {
            [self.delegate didDeleteItemWithMessage:error.localizedDescription withError:error atIndexPath:indexPath];
        }
    }];
}

- (NSArray *)itemsByResponseArray:(NSArray *)response error:error{
    NSMutableArray *items = @[].mutableCopy;
    for (NSDictionary *dict in response) {
        Item *item = [[Item alloc] initWithDictionary:dict error:&error];
        if (!error) {
            [items addObject:item];
        }
    }
    return items;
}

@end
