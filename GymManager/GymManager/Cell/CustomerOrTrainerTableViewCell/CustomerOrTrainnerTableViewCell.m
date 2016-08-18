//
//  CustomerOrTrainnerTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CustomerOrTrainnerTableViewCell.h"

@implementation CustomerOrTrainnerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configCellWithName:(NSString *)name {
    self.labelNameCustomOrTrainer.text = name;
}

@end
