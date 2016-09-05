//
//  Customer.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Customer.h"

@implementation Customer

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

- (void)setRegistryDateWithNSString:(NSString *)string {
    DateFormatter *formatter = [[DateFormatter alloc] init];
    self.registryDate = [formatter dateWithMonthYearFormatterFromString:string];
}

- (void)setExpiryDateWithNSString:(NSString *)string {
    DateFormatter *formatter = [[DateFormatter alloc] init];
    self.expiryDate = [formatter dateWithMonthYearFormatterFromString:string];
}

- (NSURL *)avatarURL{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLImage, self.avatar]];
}

@end
