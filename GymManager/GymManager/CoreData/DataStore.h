//
//  DataStore.h
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"
#import "User.h"
#import "UserManager.h"
#import "Item.h"

@interface DataStore : NSObject

+ (instancetype)sharedDataStore;
- (void)setNewUserManagefromUser:(User *)user WithCompletionblock:(void(^)(BOOL success))completion;
- (User *)getUserManage;
- (BOOL)isLoged;
- (void)clearUser;
- (void)updateProfile:(User *)user complete:(void(^)(BOOL success))complete;
- (void)setItemsList:(NSArray *)items;
- (NSArray *)getItemsListWithSelectedItemsList:(NSArray *)selectedItems;
- (void)deleteItem:(Item *)item;
- (void)addItem:(Item *)item;
- (void)updateItem:(Item *)item;

@end
