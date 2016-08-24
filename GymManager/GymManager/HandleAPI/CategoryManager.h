//
//  CategoryManager.h
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"
#import "Item.h"
#import "User.h"

@protocol CategoryManagerDelegate <NSObject>

- (void)didFetchAllItemsWithMessage:(NSString *)message withError:(NSError *)error returnItems:(NSArray*)items;
- (void)didDeleteItemWithMessage:(NSString *)message withError:(NSError *)error atIndexPath:(NSIndexPath *)indexPath;
- (void)didCreateItem:(Item*)item WithMessage:(NSString *)message withError:(NSError *)error;
- (void)didUpdateItem:(Item*)item WithMessage:(NSString *)message withError:(NSError *)error
    atIndexPath:(NSIndexPath *)indexPath;

@end

@interface CategoryManager : Manager

@property (strong, nonatomic) id<CategoryManagerDelegate> delegate;
- (void)getAllItemsByUser:(User *)user;
- (void)createItem:(Item *)item ByUser:(User *)user;
- (void)deleteItem:(Item *)item ByUser:(User *)user atIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(Item *)item ByUser:(User *)user atIndexPath:(NSIndexPath *)indexPath;

@end
