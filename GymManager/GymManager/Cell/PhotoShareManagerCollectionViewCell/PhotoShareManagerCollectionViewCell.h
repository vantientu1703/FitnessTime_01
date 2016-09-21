//
//  PhotoShareManagerCollectionViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 9/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoShareManagerCollectionViewCellDelegate <NSObject>

- (void)didDeleteImage:(NSIndexPath *)indexPath;

@end

@interface PhotoShareManagerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<PhotoShareManagerCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewShare;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
