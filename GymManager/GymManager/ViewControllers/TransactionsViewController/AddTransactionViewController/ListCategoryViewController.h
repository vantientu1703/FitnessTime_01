//
//  ListCategoryViewController.h
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ItemListMode) {
    ItemListModeEdit,
    ItemListModeNormal
};

@interface ListCategoryViewController : BaseViewController

@property (nonatomic) ItemListMode mode;
@property (copy, nonatomic) NSArray *arrCategoryPicked;
@property (strong, nonatomic) NSString *showCategoryTitle;
- (void)didAddItemWithCompletionBlock:(void(^)(Item *item))block;

@end
