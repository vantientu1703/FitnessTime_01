//
//  User.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "User.h"

@implementation User

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLImage, self.avatar]];
}

@end
