//
//  DateFormatter.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateFormatterType) {
    DateFormatterTypeHour,
    DateFormatterTypeHourDayMonthYear,
    DateFormatterTypeDayMonthYear,
    DateFormatterTypeUTC,
    DateFormatterTypeYear
};

@interface DateFormatter : NSObject

+ (instancetype)sharedInstance;
- (NSString *)dateFormatterDateMonthYear:(NSDate *)date;
- (NSDate *)dateWithMonthYearFormatterFromString:(NSString*)string;
- (NSString *)dateFormatterFullInfo:(NSDate *)date;
- (NSString *)dateFormatterHour:(NSDate *)date;
- (NSString *)dateWithHourFormatterFromString:(NSString *)string;
- (NSString *)dateWithDateMonthYearFormatterFromString:(NSString *)string;
- (NSString *)yearStringFromDate:(NSDate *)date;
- (NSDate *)dateFromYearString:(NSString *)string;
- (NSDate *)dateByServerFormatFromString:(NSString *)string;
- (NSString *)dateWithHourDayMonthYearFormatterFromString:(NSString *)string;
- (NSString *)dateFormatterHourDateMonthYear:(NSDate *)date;
- (NSDate *)dateFormatterHourDateMonthYearWithString:(NSString *)string;

@end
