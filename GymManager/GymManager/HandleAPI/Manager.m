//
//  Manager.m
//  GymManager
//
//  Created by Thinh on 8/18/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Manager.h"

@implementation Manager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil
            cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    return self;
}

- (void)showAlertByMessage:(NSString *)message title:(NSString *)title {
    self.alert.title = title;
    self.alert.message = message;
    [self.alert show];
}

@end
