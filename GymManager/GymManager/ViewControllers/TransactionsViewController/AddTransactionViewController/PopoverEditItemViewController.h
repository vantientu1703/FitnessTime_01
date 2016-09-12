//
//  PopoverEditItemViewController.h
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface PopoverEditItemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *lbName;
@property (weak, nonatomic) IBOutlet DecimalTextField *lbPrice;
@property (strong, nonatomic) Item *item;

- (void)didEditItemWithCompletionBlock:(void(^)(Item *item))block;

@end
