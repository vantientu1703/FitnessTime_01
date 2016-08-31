//
//  EditPTManagerViewController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditPTManagerViewControllerDelegate <NSObject>

@optional
- (void)createNewTrainer:(Trainer *)trainer;
- (void)updateTrainer:(Trainer *)trainer;

@end

@interface EditPTManagerViewController : UIViewController
@property (weak, nonatomic) id<EditPTManagerViewControllerDelegate> delegate;
@property (strong, nonatomic) Trainer *trainer;
@property (strong, nonatomic) NSString *statusEditString;
@end
