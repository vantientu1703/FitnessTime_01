//
//  DataStore.m
//  GymManager
//
//  Created by Thinh on 8/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DataStore.h"

NSString *const kTokenChainKey = @"auth_token";
NSString *const kUserDefaultLoginCheck = @"loged";

@interface DataStore ()

@property (strong, nonatomic) UICKeyChainStore *keychain;

@end

@implementation DataStore

- (instancetype)init {
    if (self = [super init]) {
        self.keychain = [UICKeyChainStore keyChainStoreWithService:kBundleID];
    }
    return self;
}

+ (instancetype)sharedDataStore {
    static DataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    return sharedDataStore;
}

- (void)updateProfile:(User *)user complete:(void(^)(BOOL success))complete {
    UserManager *userManager = [UserManager MR_findFirst];
    userManager.id = user.id;
    userManager.telNumber = user.telNumber;
    userManager.birthday = user.birthday;
    userManager.address = user.address;
    userManager.email = user.email;
    userManager.avatar = user.avatar;
    userManager.userName = user.userName;
    [self.keychain setString:user.authToken forKey:kTokenChainKey];
    [[NSManagedObjectContext MR_defaultContext]
     MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        complete(contextDidSave);
     }];
}

- (User*)getUserManage {
    UserManager *mangerManage = [UserManager MR_findFirst];
    User *user = [[User alloc] init];
    user.id = mangerManage.id;
    user.fullName = mangerManage.fullName;
    user.telNumber = mangerManage.telNumber;
    user.birthday = mangerManage.birthday;
    user.address = mangerManage.address;
    user.email = mangerManage.email;
    user.avatar = mangerManage.avatar;
    user.userName = mangerManage.userName;
    user.authToken = [self.keychain stringForKey:kTokenChainKey];
    return user;
}

- (void)setNewUserManagefromUser:(User *)user WithCompletionblock:(void(^)(BOOL success))completion{
    [self clearUser];
    [UserManager MR_importFromObject:user];
    [[NSManagedObjectContext MR_defaultContext]
        MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            [self.keychain setString:user.authToken forKey:kTokenChainKey];
        }
        completion(contextDidSave);
    }];
}

- (void)clearUser {
    //Remove all current info
    NSArray *currentUserManageArr = [UserManager MR_findAll];
    for (UserManager *mange in currentUserManageArr) {
        [mange MR_deleteEntity];
    }
    [self.keychain removeItemForKey:kTokenChainKey];
}

- (BOOL)isLoged {
    return [self.keychain stringForKey:kTokenChainKey].length;
}

@end
