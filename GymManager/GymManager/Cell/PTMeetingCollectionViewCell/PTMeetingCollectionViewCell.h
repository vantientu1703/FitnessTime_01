//
//  PTMeetingCollectionViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTMeetingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPTMeetingCell;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainer;
- (void)initWithImageName:(UIImage *)image withNameTrainer:(NSString *)nameTrainer;

@end
