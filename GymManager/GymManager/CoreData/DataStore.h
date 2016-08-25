//
//  DataStore.h
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"
#import "User.h"
#import "UserManager.h"

@interface DataStore : NSObject

+ (instancetype)sharedDataStore;
- (void)setNewUserManagefromUser:(User *)user WithCompletionblock:(void(^)(BOOL success))completion;
- (User *)getUserManage;
- (BOOL)isLoged;
- (void)clearUser;
- (void)updateProfile:(User *)user complete:(void(^)(BOOL success))complete;

@end
