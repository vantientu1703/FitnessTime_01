//
//  DateFormatterDecimal.m
//  GymManager
//
//  Created by Thinh on 9/9/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "NumberFormatterDecimal.h"

@implementation NumberFormatterDecimal

- (instancetype)init {
    if (self = [super init]) {
        [self setMaximumFractionDigits:2];
        [self setMinimumFractionDigits:0];
        [self setAlwaysShowsDecimalSeparator:NO];
        [self setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return self;
}

+ (instancetype)formatter {
    static NumberFormatterDecimal *sharedFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFormatter = [[self alloc] init];
    });
    return sharedFormatter;
}

@end
