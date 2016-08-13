//
//  CustomerOrTrainnerTableViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerOrTrainnerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomOrTrainer;
- (void)configForCellWithNameCustomerOrTrainer:(NSString *)name;

@end
