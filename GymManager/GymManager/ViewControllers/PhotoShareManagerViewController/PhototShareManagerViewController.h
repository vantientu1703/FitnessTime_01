//
//  PhototShareManagerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 9/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhototShareManagerViewControllerDelegate <NSObject>

- (void)fillImageToViewWithArrayImages:(NSArray *)images;

@end

@interface PhototShareManagerViewController : BaseViewController
@property (strong, nonatomic) id<PhototShareManagerViewControllerDelegate> delegate;
@end
