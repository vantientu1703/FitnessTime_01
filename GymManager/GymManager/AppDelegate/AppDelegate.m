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
#import "MeetingDetailViewController.h"

NSString *const kTodayViewControllerTitle = @"Today";
NSString *const kPTMeetingViewControllerTitle = @"PT Meeting";
NSString *const kTransactionsViewControllerTitle = @"Transactions";
NSString *const kMenuViewControllerTitle = @"Menu";

@interface AppDelegate ()

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    LoginViewController *loginVC = [st instantiateViewControllerWithIdentifier:kLoginViewControllerIdentifier];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    // TODO
    //    UITabBarController *tabVC = [[UITabBarController alloc] init];
    //    //TODO TodayViewController
    //    TodayMeetingsViewController *todayMeetingsVC = [[TodayMeetingsViewController alloc] init];
    //    todayMeetingsVC.title = kTodayViewControllerTitle;
    //    UINavigationController *navTodayMeetingsVC = [[UINavigationController alloc] initWithRootViewController:todayMeetingsVC];
    //    //TODO PTMeetingViewController
    //    PTMeetingViewController *ptMeetingVC = [[PTMeetingViewController alloc] init];
    //    ptMeetingVC.title = kPTMeetingViewControllerTitle;
    //    UINavigationController *navPTMeetingVC = [[UINavigationController alloc] initWithRootViewController:ptMeetingVC];
    //    //TODO TransactionsViewController
    //    TransactionsViewController *transVC = [[TransactionsViewController alloc] init];
    //    transVC.title = kTransactionsViewControllerTitle;
    //    UINavigationController *navTransactionVC = [[UINavigationController alloc] initWithRootViewController:transVC];
    //    //TODO MenuViewController
    //    MenuViewController *menuVC = [[MenuViewController alloc] init];
    //    menuVC.title = kMenuViewControllerTitle;
    //    UINavigationController *navMenuVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    //    //TODO Set viewcontrollers for tabbar controller
    //    [tabVC setViewControllers:[NSArray arrayWithObjects:navTodayMeetingsVC,navPTMeetingVC,navTransactionVC,navMenuVC, nil]];
    //    self.window.rootViewController = tabVC;
    //    [self.window makeKeyAndVisible];
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
