//
//  AlertController.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             viewControler:(UIViewController *)viewController
      takePhotoFromLibrary:(void(^)())takePhotoFromLibrary
       takePhotoFromCamera:(void(^)())takePhotoFromCamera;

@end
