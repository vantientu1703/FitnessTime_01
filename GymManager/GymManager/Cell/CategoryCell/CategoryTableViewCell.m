//
//  CategoryTableViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)cellWithName:(NSString *)name andPrice:(NSString *)price {
    self.labelName.text = name;
    self.labelPrice.text = price;
}

@end
