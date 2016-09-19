//
//  UILabelNoData.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "UILabelNoData.h"
@implementation UILabelNoData

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithFrame:frame];
    }
    return self;
}

- (void)setupViewWithFrame:(CGRect)frame {
    UILabel *_labelNoData;
    _labelNoData = [[UILabel alloc] init];
    _labelNoData.text = @"No data :)~";
    _labelNoData.frame = CGRectMake(0.0f, 0.0f, 150.0f, 100.0f);
    [_labelNoData setFont:[UIFont systemFontOfSize:25.0f]];
    _labelNoData.textColor = [UIColor lightGrayColor];
    _labelNoData.center = self.center;
    _labelNoData.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelNoData];
}

+ (UILabelNoData *)lableNoData {
    UILabelNoData *labelNoData = [[UILabelNoData alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 100.0f)];
    labelNoData.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0f,
                                     CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0f - 50.0f);
    return labelNoData;
}

@end
