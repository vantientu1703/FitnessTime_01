//
//  ClipButton.m
//  GymManager
//
//  Created by Thinh on 9/8/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ClipButton.h"

@implementation ClipButton

- (void)drawRect:(CGRect)rect {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.f;
}

@end
