//
//  AnimationTabbarController.m
//  GymManager
//
//  Created by Thinh on 9/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AnimationTabbarController.h"

@interface AnimationTabbarController () <UITabBarControllerDelegate>

@end

@implementation AnimationTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (self.animated) {
        UIImageView *imageView;
        NSInteger count = tabBar.subviews.count;
        if (!item.tag) {
            imageView = (UIImageView*)tabBar.subviews[count - 1].subviews.firstObject;
        } else {
            imageView = (UIImageView*)tabBar.subviews[item.tag].subviews.firstObject;
        }
        imageView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5f animations:^{
            imageView.transform =  CGAffineTransformMakeRotation(M_PI);
            imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController != tabBarController.selectedViewController) {
        UIViewController *fromVC =  (UINavigationController*)[tabBarController selectedViewController].
            childViewControllers.firstObject;
        UIViewController *toVC =  (UINavigationController*)viewController.childViewControllers.firstObject;
        [UIView transitionFromView:fromVC.view toView:toVC.view duration:0.2f options:
            UIViewAnimationOptionTransitionCrossDissolve completion:nil];
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
