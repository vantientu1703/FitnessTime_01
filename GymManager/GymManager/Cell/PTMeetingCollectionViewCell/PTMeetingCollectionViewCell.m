//
//  PTMeetingCollectionViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PTMeetingCollectionViewCell.h"

CGFloat const kCornerRadiusImageViewCell = 30.0f;

@implementation PTMeetingCollectionViewCell

- (void)initWithImageName:(UIImage *)image withNameTrainer:(NSString *)nameTrainer {
    self.imageViewPTMeetingCell.layer.cornerRadius = kCornerRadiusImageViewCell;
    self.imageViewPTMeetingCell.layer.masksToBounds = YES;
    self.imageViewPTMeetingCell.image = image;
    self.labelNameTrainer.text = nameTrainer;
}

@end
