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
NSString *const kMessageDuplicate = @"Duplicate Location";
NSString *const kMessageReachLimit = @"Reach to maximun number of location";

@interface DataStore ()

@property (strong, nonatomic) dispatch_queue_t transactionQueue;
@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) NSMutableArray *arrItems;

@end

@implementation DataStore

- (instancetype)init {
    if (self = [super init]) {
        self.keychain = [UICKeyChainStore keyChainStoreWithService:kBundleID];
        self.arrItems = @[].mutableCopy;
        self.transactionQueue = dispatch_queue_create("transaction_queue", DISPATCH_QUEUE_SERIAL);
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

- (void)setNewGymLocation:(NSString *)address lat:(NSNumber *)latitue long:(NSNumber *)longitue complete:(void(^)(BOOL success, NSString *message, GymLocation *location))complete {
    NSPredicate *predict = [NSPredicate
        predicateWithFormat:@"(latitue == %@) AND (longtitue == %@)", latitue, longitue];
    NSArray *arrLocation = [GymLocation MR_findAll];
    if (arrLocation.count >= 5) { // Limit to 5
        complete(NO, kMessageReachLimit, nil);
        return;
    }
    GymLocation *tempLocation = [GymLocation MR_findFirstWithPredicate:predict sortedBy:nil ascending:NO];
    if (tempLocation) {
        complete(NO, kMessageDuplicate, nil);
        return;
    }
    GymLocation *newLocation = [GymLocation MR_createEntity];
    newLocation.latitue = latitue;
    newLocation.longtitue = longitue;
    newLocation.address = address;
    [[NSManagedObjectContext MR_defaultContext]
    MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        complete(contextDidSave, error.localizedDescription, newLocation);
    }];
}

- (void)removeGymLocation:(GymLocation *)location complete:(void(^)(BOOL success))complete {
    [location MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext]
        MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        complete(contextDidSave);
    }];
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
    userManager.fullName = user.fullName;
    [self.keychain setString:user.authToken forKey:kTokenChainKey];
    [[NSManagedObjectContext MR_defaultContext]
     MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        complete(contextDidSave);
    }];
}

- (void)setUserLoginWithFB:(NSDictionary *)userData {
    NSString *name = userData[@"name"];
    NSString *urlAvartar = [[[userData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    NSString *ID = userData[@"id"];
    NSString *email = userData[@"email"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"name"];
    [defaults setObject:urlAvartar forKey:@"url"];
    [defaults setObject:ID forKey:@"id"];
    [defaults setObject:email forKey:@"email"];
    [defaults synchronize];
}

- (User *)getUSerLoginWithFB {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [[User alloc] init];
    user.id = [defaults objectForKey:@"id"];
    user.fullName = [defaults objectForKey:@"name"];
    user.email = [defaults objectForKey:@"email"];
    user.avatar = [defaults objectForKey:@"url"];
    return user;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:true forKey:@"isloged"];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"isloged"];
}

- (void)setItemsList:(NSArray *)items {
    dispatch_sync(self.transactionQueue, ^{
        self.arrItems = items.mutableCopy;
    });
}

- (NSArray *)getItemsListWithSelectedItemsList:(NSArray *)selectedItems {
    if (selectedItems) {
        NSMutableArray *returnItems = @[].mutableCopy;
        for (Item *item in self.arrItems) {
            BOOL contain = NO;
            for (Item *curItem in selectedItems) {
                if ([curItem.id isEqualToString:item.id]) {
                    contain = YES;
                    break;
                }
            }
            if (!contain) {
                [returnItems addObject:item];
            }
        }
        return returnItems;
    }
    return self.arrItems;
}

- (void)deleteItem:(Item *)item {
    for (Item *curItem in self.arrItems) {
        if ([curItem.id isEqualToString:item.id]) {
            dispatch_sync(self.transactionQueue, ^{
                [self.arrItems removeObject:curItem];
            });
            break;
        }
    }
}

- (void)addItem:(Item *)item {
    dispatch_sync(self.transactionQueue, ^{
        [self.arrItems addObject:item];
    });
}

- (void)updateItem:(Item *)item {
    for (Item *curItem in self.arrItems) {
        if ([curItem.id isEqualToString:item.id]) {
            dispatch_sync(self.transactionQueue, ^{
                curItem.name = item.name;
                curItem.price = item.price;
                curItem.quantity = item.quantity;
            });
            break;
        }
    }
}

@end
