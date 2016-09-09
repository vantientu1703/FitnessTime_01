//
//  AddNewCustomerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNewCustomerViewControllerDelegate <NSObject>

@optional
- (void)addNewCustomer:(Customer *)customer;
- (void)updateCustomer:(Customer *)customer;

@end

@interface AddNewCustomerViewController : BaseViewController

@property (weak, nonatomic) id<AddNewCustomerViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *messageEditCustomer;
@property (strong, nonatomic) Customer *customer;

@end
