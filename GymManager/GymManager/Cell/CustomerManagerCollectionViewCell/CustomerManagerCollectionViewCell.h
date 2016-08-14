//
//  CustomerManagerCollectionViewCell.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerManagerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomer;
- (void)initWithNameCustomer:(NSString *)nameCustomer avatar:(UIImage *)image;

@end
