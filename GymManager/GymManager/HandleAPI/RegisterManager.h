//
//  RegisterManager.h
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Manager.h"
#import "User.h"

@protocol RegisterManagerDelegate <NSObject>

- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnUser:(User*)user;

@end

@interface RegisterManager : Manager

@property (weak, nonatomic) id<RegisterManagerDelegate> delegate;

- (void)doRegisterWithUser:(User *)user;

@end
