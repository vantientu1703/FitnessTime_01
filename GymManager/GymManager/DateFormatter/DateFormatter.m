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
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
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
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeYear];
    return [_dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromYearString:(NSString *)string {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeYear];
    return [_dateFormatter dateFromString:string];
}

- (NSString *)dateFormatterDateMonthYear:(NSDate *)date {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeDayMonthYear];
    return [_dateFormatter stringFromDate:date];
}

- (NSDate *)dateByServerFormatFromString:(NSString *)string {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeUTC];
    return [_dateFormatter dateFromString:string];
}

- (NSDate *)dateWithMonthYearFormatterFromString:(NSString*)string {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeDayMonthYear];
    return [_dateFormatter dateFromString:string];
}

- (NSString *)dateFormatterFullInfo:(NSDate *)date {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeHourDayMonthYear];
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)dateFormatterHour:(NSDate *)date {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeHour];
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)dateFormatterHourDateMonthYear:(NSDate *)date {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:DateFormatterTypeHourDayMonthYear];
    return [_dateFormatter stringFromDate:date];
}

- (NSString *)dateWithHourFormatterFromString:(NSString *)string {
    NSDate *date = [self dateFromString:string withFormat:DateFormatterTypeUTC];
    return [self stringFromDate:date withFormat:DateFormatterTypeHour];
}

- (NSString *)dateWithDateMonthYearFormatterFromString:(NSString *)string {
    NSDate *date = [self dateFromString:string withFormat:DateFormatterTypeUTC];
    return [self stringFromDate:date withFormat:DateFormatterTypeDayMonthYear];
}

- (NSString *)dateWithHourDayMonthYearFormatterFromString:(NSString *)string {
    NSDate *date = [self dateFromString:string withFormat:DateFormatterTypeUTC];
    return [self stringFromDate:date withFormat:DateFormatterTypeHourDayMonthYear];
}

- (NSDate *)dateFormatterHourDateMonthYearWithString:(NSString *)string {
    return [self dateFromString:string withFormat:DateFormatterTypeUTC];;
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(DateFormatterType)format {
    _dateFormatter.dateFormat = [self dateFormatterTypeString:format];
    return [_dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)dateString withFormat:(DateFormatterType)format {
    NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setTimeZone:inputTimeZone];
    [inputDateFormatter setDateFormat:[self dateFormatterTypeString:format]];
    return [inputDateFormatter dateFromString:dateString];
}

- (NSString *)dateFormatterTypeString:(DateFormatterType)format {
    switch (format) {
        case DateFormatterTypeHour: {
            return @"hh:mm a";
        }
        case DateFormatterTypeHourDayMonthYear: {
            return @"hh:mm a dd/MM/yyyy";
        }
        case DateFormatterTypeDayMonthYear: {
            return @"dd/MM/yyyy";
        }
        case DateFormatterTypeUTC: {
            return @"YYYY-MM-dd'T'HH:mm:ss.SSS'Z'";
        }
        case DateFormatterTypeYear: {
            return @"yyyy";
        }
        default:
            return nil;
    }
}

@end
