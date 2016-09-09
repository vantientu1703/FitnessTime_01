//
//  CustomerManagerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerManagerViewControllerDelegate <NSObject>
- (void)selectedCustomer:(Customer *)customer;
@end

@interface CustomerManagerViewController : BaseViewController
@property (weak, nonatomic) id<CustomerManagerViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *statusCustomerManagerTitle;
@end
