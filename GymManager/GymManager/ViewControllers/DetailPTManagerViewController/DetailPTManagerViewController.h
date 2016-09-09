//
//  DetailPTManagerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailPTManagerViewControllerDelegate <NSObject>

@optional
- (void)reloadDataCollectionView:(Trainer *)trainer;

@end

@interface DetailPTManagerViewController : BaseViewController
@property (weak, nonatomic) id<DetailPTManagerViewControllerDelegate> delegate;
@property (strong, nonatomic) Trainer *trainer;
@end
