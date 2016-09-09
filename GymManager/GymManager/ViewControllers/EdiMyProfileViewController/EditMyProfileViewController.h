//
//  EditMyProfileViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditMyProfileViewControllerDelegate <NSObject>

- (void)updateUser:(User *)user;

@end

@interface EditMyProfileViewController : BaseViewController
@property (weak, nonatomic) id<EditMyProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) User *user;
@end
