//
//  PT.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Trainer.h"

@implementation Trainer

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLImage, self.avatar]];
}

@end
