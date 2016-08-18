//
//  DateFormatter.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter
{
    NSDateFormatter *_dateFormatter;
}
- (instancetype)init {
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    return self;
}
- (NSString *)dateFormatterDateMonthYear:(NSDate *)date {
    return [_dateFormatter stringFromDate:date];;
}

@end
