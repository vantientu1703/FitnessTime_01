//
//  Person.m
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Person.h"
#import "DateFormatter.h"

@implementation Person

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (void)setBirthdayWithNSString:(NSString *)string {
    DateFormatter *formatter = [[DateFormatter alloc] init];
    self.birthday = [formatter dateWithMonthYearFormatterFromString:string];
}

@end
