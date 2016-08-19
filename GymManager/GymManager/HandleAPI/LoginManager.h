//
//  Service.h
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "User.h"
#import "Manager.h"

@protocol LoginManagerDelegate <NSObject>

- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnUser:(User*)user;

@end

@interface LoginManager : Manager

@property (weak, nonatomic) id<LoginManagerDelegate> delegate;

- (void)doLoginWithEmail:(NSString *)email password:(NSString *)password;

@end
