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

- (void)cellWithCustomer:(Customer *)customer {
    self.imageViewCustomer.layer.cornerRadius = kCornerRadiusImageViewCustomer;
    self.imageViewCustomer.layer.masksToBounds = YES;
    NSURL *url = [NSURL URLWithString:customer.avatar];
    [self.imageViewCustomer sd_setImageWithURL:url
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewCustomer.image = [UIImageConstant imageUserConstant];
        }
    }];
    self.labelNameCustomer.text = customer.fullName;
}

@end
