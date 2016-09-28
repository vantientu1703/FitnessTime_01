//
//  AlertController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBImagePickerController.h"
#import "ELCImagePickerController.h"

@protocol AlertManagerDelegate <NSObject>
@optional
- (void)showImagePickerController:(UIImagePickerController *)imagePickerController;
- (void)showQBImagePikcerController:(ELCImagePickerController *)qbImagePickerController;
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
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController okAction:(void(^)())complete;
- (void)showChooseImageAlertWithTitle:(NSString *)title vieController:(UIViewController *)viewController;
@end
