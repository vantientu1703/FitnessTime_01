//
//  ProfileManager.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/24/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"

@protocol ProfileManagerDelegate <NSObject>

- (void)updateProfile:(User *)user success:(BOOL)success error:(NSError *)error;
- (void)logoutSuccess:(BOOL)success error:(NSError *)error;

@end

@interface ProfileManager : Manager

@property (weak, nonatomic) id<ProfileManagerDelegate> delegate;
- (void)updateProfile:(User *)user;
- (void)logout;
@end
