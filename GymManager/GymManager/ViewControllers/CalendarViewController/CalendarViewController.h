//
//  CalendarViewController.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarPickerState) {
    CalendarPickerStateDay,
    CalendarPickerStateMonth,
    CalendarPickerStateYear,
    CalendarPickerStateTime
};

@interface CalendarViewController : UIViewController

@property (nonatomic) CalendarPickerState state;
- (void)didPickDateWithCompletionBlock:(void(^)(NSDate* dateSelected, CalendarPickerState state))callBackBlock;

@end
