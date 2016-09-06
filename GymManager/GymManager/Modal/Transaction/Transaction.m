//
//  Transaction.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Transaction.h"
#import "DateFormatter.h"

@implementation Transaction

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

- (void)setCreatedAtWithNSString:(NSString *)string {
    self.createdAt = [[DateFormatter sharedInstance] dateFromString:string withFormat:DateFormatterTypeUTC];
}

@end
