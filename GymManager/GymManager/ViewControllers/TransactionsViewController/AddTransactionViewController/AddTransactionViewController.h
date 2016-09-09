//
//  AddTransactionViewController.h
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface AddTransactionViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lbCustomerName;
@property (weak, nonatomic) IBOutlet UIView *viewCustomer;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalCost;
- (void)updateTransaction:(Transaction *)transaction withCompleteBlock:(void(^)(Transaction* returnTran))block;

@end
