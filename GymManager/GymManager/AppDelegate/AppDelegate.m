//
//  AppDelegate.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AppDelegate.h"
#import "TodayMeetingsViewController.h"
#import "PTMeetingViewController.h"
#import "MenuViewController.h"
#import "TransactionsViewController.h"
#import "LoginViewController.h"
#import "AnimationTabbarController.h"

NSString *const kMapAPIKey = @"AIzaSyAO6QZDAo1MgcBy92CoF8_7dqbKjln0A20";

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Setup Coredata
    [MagicalRecord setupCoreDataStackWithStoreNamed:kCoreDataModel];
    //Register local notification
    [self setupLocalNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([[DataStore sharedDataStore] isLoged]) {
        [self loadTabbarController];
    } else {
        [self loadLoginViewController];
    }
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [GMSServices provideAPIKey:kMapAPIKey];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadLoginViewController {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    LoginViewController *loginVC = [st instantiateViewControllerWithIdentifier:kLoginViewControllerIdentifier];
    self.window.rootViewController = loginVC;
}

- (void)loadTabbarController {
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor greenColor]];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    AnimationTabbarController *tabVC = [[AnimationTabbarController alloc] init];
    TodayMeetingsViewController *todayMeetingsVC = [st instantiateViewControllerWithIdentifier:
        kTodayMeetinViewControllerIdentifier];
    todayMeetingsVC.title = kTodayViewControllerTitle;
    todayMeetingsVC.statusDetailMeeting = kTodayMeetingsVCTitle;
    UINavigationController *navTodayMeetingsVC = [[UINavigationController alloc] initWithRootViewController:todayMeetingsVC];
    PTMeetingViewController *ptMeetingVC = [st instantiateViewControllerWithIdentifier:
        kPTMeetingViewControllerIdentifier];
    ptMeetingVC.statusAddNewMeeting = kDetailMeetingTitle;
    ptMeetingVC.title = kPTMeetingViewControllerTitle;
    UINavigationController *navPTMeetingVC = [[UINavigationController alloc] initWithRootViewController:ptMeetingVC];
    TransactionsViewController *transVC = [[UIStoryboard storyboardWithName:kNameStoryboardTransaction bundle:nil] instantiateInitialViewController];
    transVC.title = kTransactionsViewControllerTitle;
    UINavigationController *navTransactionVC = [[UINavigationController alloc] initWithRootViewController:transVC];
    MenuViewController *menuVC = [st instantiateViewControllerWithIdentifier:kMenuViewControllerIdentifier];
    menuVC.title = kMenuViewControllerTitle;
    UINavigationController *navMenuVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    //Set viewcontrollers for tabbar controller
    [tabVC setViewControllers:@[navTodayMeetingsVC,navPTMeetingVC,navTransactionVC,navMenuVC]];
    NSArray *arrImages = @[kIconNewsFeed, kIconFriends, kIconTransactions, kIconSetting];
    [tabVC.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = [UIImage imageNamed:arrImages[idx]];
        obj.tag = idx;
    }];
    tabVC.animated = YES;
    self.window.rootViewController = tabVC;
}

- (void)setupLocalNotification {
    //Button call trainer
    UIMutableUserNotificationAction *callAction = [[UIMutableUserNotificationAction alloc] init];
    callAction.title = @"Call Trainer";
    callAction.identifier = kNotiCallActionIdent;
    callAction.destructive = NO;
    callAction.activationMode = UIUserNotificationActivationModeForeground;
    callAction.authenticationRequired = NO;
    //Category buttons
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = kNotiCallActionIdent;
    [category setActions:@[callAction]
        forContext:UIUserNotificationActionContextDefault|UIUserNotificationActionContextMinimal];
    //Settings
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|
        UIUserNotificationTypeSound categories:[NSSet setWithObjects:category, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    completionHandler();
    if ([kNotiCallActionIdent isEqualToString:notification.category]) {
        if ([kNotiCallActionIdent isEqualToString:identifier]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",
                notification.userInfo[kNotiDictKeyTrainerPhone]]];
            if ([application canOpenURL:url]) {
                [application openURL:url];
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
        openURL:url sourceApplication:sourceApplication annotation:annotation];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
