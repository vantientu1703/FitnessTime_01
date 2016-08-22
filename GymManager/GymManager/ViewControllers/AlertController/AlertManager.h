//
//  AlertController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertManagerDelegate <NSObject>
- (void)showImagePickerController:(UIImagePickerController *)imagePickerController;
@end

@interface AlertManager : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id<AlertManagerDelegate> delegate;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController
    takePhotoFromLibrary:(void(^)())takePhotoFromLibrary takePhotoFromCamera:(void(^)())takePhotoFromCamera;
- (void)showChooseImageAlertWithTitle:(NSString *)title message:(NSString *)message
    vieController:(UIViewController *)viewController;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController reloadAction:(void(^)())complete;
@end
