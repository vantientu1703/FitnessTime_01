//
//  PTMeetingCollectionViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trainer.h"

@interface PTMeetingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPTMeetingCell;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTrainer;
- (void)cellWithTrainer:(Trainer *)trainer;

@end
