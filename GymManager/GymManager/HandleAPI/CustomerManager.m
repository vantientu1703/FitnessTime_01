//
//  CustomerManager.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CustomerManager.h"

@implementation CustomerManager

- (void)getAllCustomers {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kAPIUser];
    NSDictionary *params = @{@"auth_token": user.authToken, @"role": @"customer"};
    [self.manager GET:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSArray *customers = [self customersByResponseArray:responseObject error:error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
                [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:customers];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(didResponseWithMessage:withError:returnArray:)]) {
            [self.delegate didResponseWithMessage:error.localizedDescription withError:error returnArray:nil];
        }
    }];
}

- (void)createCustomer:(Customer *)customer {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@", kURLAPI, kAPIUser];
    NSDictionary *params = @{@"auth_token": user.authToken, @"user[full_name]": customer.fullName,
                             @"user[birthday]": customer.birthday, @"user[tel_number]": customer.telNumber,
                             @"user[address]": customer.address, @"user[registry_date]": customer.registryDate,
                             @"user[expiry_date]": customer.expiryDate, @"user[avatar]": customer.avatar,
                             @"user[role]": @"customer"};
    [self.manager POST:url parameters:params progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Customer *customer = [[Customer alloc] initWithDictionary:responseObject error:&error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(createdCustomerWithMessage:withError:returnCustomer:)]) {
                [self.delegate createdCustomerWithMessage:true withError:error returnCustomer:customer];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(createdCustomerWithMessage:withError:returnCustomer:)]) {
            [self.delegate createdCustomerWithMessage:false withError:error returnCustomer:nil];
        }
    }];
}

- (void)updateTrainer:(Customer *)customer {
    User *user = (User *)[[DataStore sharedDataStore] getUserManage];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", kURLAPI, kAPIUser, customer.id];
    NSDictionary *params = @{@"user[full_name]": customer.fullName, @"user[birthday]": customer.birthday,
                             @"user[tel_number]": customer.telNumber, @"user[address]": customer.address,
                             @"user[registry_date]": customer.registryDate, @"user[expiry_date]": customer.expiryDate,
                             @"user[avatar]": customer.avatar, @"user[role]": @"customer",
                             @"auth_token": user.authToken};
    [self.manager PUT:url parameters:params
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        Customer *customer = [[Customer alloc] initWithDictionary:responseObject error:&error];
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(updateCustomerWithMessage:withError:returnCustomer:)]) {
                [self.delegate updateCustomerWithMessage:true withError:error returnCustomer:customer];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(updateCustomerWithMessage:withError:returnCustomer:)]) {
            [self.delegate updateCustomerWithMessage:false withError:error returnCustomer:nil];
        }
    }];
}

- (NSArray *)customersByResponseArray:(NSArray *)responseArr error:(NSError*)error {
    NSMutableArray *customers = @[].mutableCopy;
    for (NSDictionary *dict in responseArr) {
        Customer *customer = [[Customer alloc] initWithDictionary:dict error:&error];
        if (!error) {
            [customers addObject:customer];
        }
    }
    return customers;
}

@end
