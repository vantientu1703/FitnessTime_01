//
//  PhotoShareManagerCollectionViewCell.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PhotoShareManagerCollectionViewCell.h"

@implementation PhotoShareManagerCollectionViewCell

- (IBAction)deletePress:(id)sender {
    UIView *view = [sender superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(PhotoShareManagerCollectionViewCell *)view.superview];
    if ([self.delegate respondsToSelector:@selector(didDeleteImage:)]) {
        [self.delegate didDeleteImage:indexPath];
    }
}

@end
