//
//  AddNewCategoryViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNewCategoryViewControllerDelegate <NSObject>

- (void)removeAddNewCategoryVCFromParentViewController;
- (void)createNewCategory:(NSString *)categoryItem;

@end

@interface AddNewCategoryViewController : UIViewController
@property (weak, nonatomic) id<AddNewCategoryViewControllerDelegate> delegate;
@end
