//
//  AlertController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
               viewControler:(UIViewController *)viewController
        takePhotoFromLibrary:(void(^)())takePhotoFromLibrary
         takePhotoFromCamera:(void(^)())takePhotoFromCamera {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
        message:kChoosenTypeTitle preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:kChoseFromLibraryTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (takePhotoFromLibrary) {
                takePhotoFromLibrary();
            }
    }];
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:kChoseFromCameraTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (takePhotoFromCamera) {
                takePhotoFromCamera();
            }
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:kCancelTitle
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:chooseFromCamera];
    [alertController addAction:chooseFromLibrary];
    [alertController addAction:cancelButton];
    [viewController presentViewController:alertController animated:true completion:nil];
}

@end
