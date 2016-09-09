//
//  EditNumberOfCategoryViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditNumberOfCategoryViewControllerDelegate <NSObject>

@optional
- (void)setNumberOfCategory:(NSInteger)number;
- (void)removeEditVCFromParentViewController;

@end

@interface EditNumberOfCategoryViewController : UIViewController
@property (weak, nonatomic) id<EditNumberOfCategoryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumberOfCategory;
@end
