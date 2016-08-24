//
//  Manager.h
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface Manager : NSObject

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) UIAlertView *alert;
- (void)showAlertByMessage:(NSString *)message title:(NSString *)title;

@end
