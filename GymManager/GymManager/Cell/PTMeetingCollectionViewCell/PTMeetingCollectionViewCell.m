//
//  PTMeetingCollectionViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PTMeetingCollectionViewCell.h"

NSString *const kIconUserImageName = @"ic_user";
CGFloat const kCornerRadiusImageViewCell = 30.0f;

@implementation PTMeetingCollectionViewCell

- (void)cellWithTrainer:(Trainer *)trainer {
    self.imageViewPTMeetingCell.layer.cornerRadius = kCornerRadiusImageViewCell;
    self.imageViewPTMeetingCell.layer.masksToBounds = YES;
    NSURL *urlImage = [NSURL URLWithString:trainer.avatar];
    [self.imageViewPTMeetingCell sd_setImageWithURL:urlImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewPTMeetingCell.image = [UIIMageConstant imageUserConstant];
        }
    }];
    self.labelNameTrainer.text = trainer.fullName;
}

@end
