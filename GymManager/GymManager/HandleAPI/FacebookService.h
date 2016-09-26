//
//  FacebookService.h
//  FRWeather_02
//
//  Created by framgia on 6/21/16.
//  Copyright © 2016 framgia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookService : NSObject

+ (void)login:(UIViewController *)viewController completion:(void (^)(NSDictionary *userData))handlerBlock;
+ (void)shareImage:(UIImage *)image message:(NSString *)message withViewController:(UIViewController *)viewController;
+ (void)shareImages:(NSArray *)images withViewController:(UIViewController *)viewController;

@end
