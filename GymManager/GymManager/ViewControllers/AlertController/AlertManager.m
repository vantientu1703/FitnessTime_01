//
//  AlertController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AlertManager.h"

NSString *const kActionReload = @"Reload";
NSString *const kActionQuit = @"Quit";

@implementation AlertManager
{
    UIImagePickerController *_imagePickerController;
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController takePhotoFromLibrary:(void(^)())takePhotoFromLibrary
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

- (void)showChooseImageAlertWithTitle:(NSString *)title message:(NSString *)message
    vieController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
        message:kChoosenTypeTitle preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:kChoseFromLibraryTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhotoFromLibrary];
    }];
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:kChoseFromCameraTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhotoFromCamera:viewController];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:kCancelTitle
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:chooseFromCamera];
    [alertController addAction:chooseFromLibrary];
    [alertController addAction:cancelButton];
    [viewController presentViewController:alertController animated:true completion:nil];
}

- (void)showChooseImageAlertWithTitle:(NSString *)title vieController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
        message:kChoosenTypeTitle preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:kChoseFromLibraryTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoQBImagePickerController];
    }];
    UIAlertAction *chooseFromCamera = [UIAlertAction actionWithTitle:kChoseFromCameraTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera:viewController];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:kCancelTitle
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:chooseFromCamera];
    [alertController addAction:chooseFromLibrary];
    [alertController addAction:cancelButton];
    [viewController presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Take photo from QBImagePickerController
- (void)takePhotoQBImagePickerController {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    if ([self.delegate respondsToSelector:@selector(showQBImagePikcerController:)]) {
        [self.delegate showQBImagePikcerController:imagePickerController];
    }
}

#pragma mark - Take photo
- (void)takePhotoFromLibrary {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([self.delegate respondsToSelector:@selector(showImagePickerController:)]) {
        [self.delegate showImagePickerController:_imagePickerController];
    }
}

- (void)takePhotoFromCamera:(UIViewController *)viewController {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *cameraErrorAlert = [UIAlertController alertControllerWithTitle:@""
            message:kMessageNotFoundCamera preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cameraNotFound = [UIAlertAction actionWithTitle:kOkActionTitle
            style:UIAlertActionStyleDestructive handler:nil];
        [cameraErrorAlert addAction:cameraNotFound];
        [viewController presentViewController:cameraErrorAlert animated:YES completion:nil];
    } else {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self.delegate respondsToSelector:@selector(showImagePickerController:)]) {
            [self.delegate showImagePickerController:_imagePickerController];
        }
    }
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController reloadAction:(void(^)())complete {
    UIAlertController *alerController;
    alerController = [UIAlertController alertControllerWithTitle:title
        message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:kActionReload
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:kCancelTitle
        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alerController addAction:reloadAction];
    [alerController addAction:quitAction];
    [viewController presentViewController:alerController animated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
    viewControler:(UIViewController *)viewController okAction:(void (^)())complete {
    UIAlertController *alerController;
    alerController = [UIAlertController alertControllerWithTitle:title
        message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:kOkActionTitle
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (complete) {
            complete();
        }
    }];
    [alerController addAction:reloadAction];
    [viewController presentViewController:alerController animated:YES completion:nil];
}

@end
