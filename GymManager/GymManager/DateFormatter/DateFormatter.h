//
//  DateFormatter.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
