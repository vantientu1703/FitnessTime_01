//
//  PopoverQuatityViewController.h
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCategoryViewController.h"

@interface PopoverQuatityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldQuantity;

- (void)didEnterQuantityWithCompletionBlock:(void(^)(NSUInteger quantity))block;

@end
