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
    }
    return self;
}

+ (instancetype)sharedInstance {
    static DateFormatter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)yearStringFromDate:(NSDate *)date {
    _dateFormatter.dateFormat = @"yyyy";
    return [_dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromYearString:(NSString *)string {
    _dateFormatter.dateFormat = @"yyyy";
    return [_dateFormatter dateFromString:string];
}

- (NSString *)dateFormatterDateMonthYear:(NSDate *)date {
    _dateFormatter.dateFormat = @"dd/MM/yyyy";
    return [_dateFormatter stringFromDate:date];
}

- (NSDate *)dateWithMonthYearFormatterFromString:(NSString *)string {
    _dateFormatter.dateFormat = @"dd/MM/yyyy";
    return [_dateFormatter dateFromString:string];
}

- (NSString *)dateFormatterFullInfo:(NSDate *)date {
    _dateFormatter.dateFormat = @"HH:mm dd/MM/yyyy";
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)dateFormatterHour:(NSDate *)date {
    _dateFormatter.dateFormat = @"HH:mm a";
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)dateWithHourFormatterFromString:(NSString *)string {
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date = [inputDateFormatter dateFromString:string];
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    [_dateFormatter setTimeZone:outputTimeZone];
    return [self dateFormatterHour:date];
}

- (NSString *)dateWithDateMonthYearFormatterFromString:(NSString *)string {
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date = [inputDateFormatter dateFromString:string];
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    [_dateFormatter setTimeZone:outputTimeZone];
    return [self dateFormatterDateMonthYear:date];
}

@end
