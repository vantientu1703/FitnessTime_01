//
//  InfoCustomerManagerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoCustomerManagerViewControllerDelegate <NSObject>

- (void)reloadDataCustomers:(Customer *)customer;

@end

@interface InfoCustomerManagerViewController : BaseViewController
@property (weak, nonatomic) id<InfoCustomerManagerViewControllerDelegate> delegate;
@property (strong, nonatomic) Customer *customer;
@end
