//
//  CustomerManagerCollectionViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CustomerManagerCollectionViewCell.h"

CGFloat const kCornerRadiusImageViewCustomer = 30.0f;

@implementation CustomerManagerCollectionViewCell

- (void)cellWithName:(NSString *)nameCustomer avatar:(UIImage *)image {
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageViewCustomer;
    self.imageViewCustomer.layer.masksToBounds = YES;
    self.imageViewCustomer.image = image;
    self.labelNameCustomer.text = nameCustomer;
}

@end
