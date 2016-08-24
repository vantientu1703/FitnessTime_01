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

@interface ListCategoryViewController : UIViewController

@property (nonatomic) ItemListMode mode;

@end
