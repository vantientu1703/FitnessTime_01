//
//  TransactionsViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableTableView.h"

@interface TransactionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbNumOfTrans;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalIncome;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintTableViewCell;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnLoadMore;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicaLoadMore;

@end
