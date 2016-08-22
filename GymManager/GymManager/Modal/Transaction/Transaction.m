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

- (void)setDateWithNSString:(NSString*)string {
    DateFormatter *formatter = [[DateFormatter alloc] init];
    self.date = [formatter dateWithMonthYearFormatterFromString:string];
}

@end
