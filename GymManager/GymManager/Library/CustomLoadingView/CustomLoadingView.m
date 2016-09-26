//
//  CustomLoadingView.m
//  GymManager
//
//  Created by Thinh on 9/23/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CustomLoadingView.h"

@implementation CustomLoadingView {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    CGPoint center = CGPointMake(self.center.x, self.center.y - 40.0f);
    CGFloat fixSize = self.bounds.size.width / 4.0f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, fixSize, fixSize)];
    view.center = center;
    [self addSubview:view];
    //Add image
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barbell"]];
    [view addSubview:_imageView];
    _imageView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
    //Add label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.size.height +
        view.frame.origin.y, fixSize, 20.0f)];
    label.text = @"Loading...";
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    [self rotateImageView];
}

- (void)rotateImageView {
    [UIView animateWithDuration:1.0 animations:^{
        _imageView.transform = CGAffineTransformMakeRotation(M_PI);
        _imageView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        [self rotateImageView];
    }];
}

+ (void)showInView:(UIView*)view {
    CustomLoadingView *loadingView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:loadingView];
}

+ (void)hideLoadingInView:(UIView *)view {
    CustomLoadingView *hud = [self loadingViewInView:view];
    if (hud != nil) {
        [hud removeFromSuperview];
    }
}

+ (CustomLoadingView *)loadingViewInView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            return (CustomLoadingView *)subview;
        }
    }
    return nil;
}

@end
