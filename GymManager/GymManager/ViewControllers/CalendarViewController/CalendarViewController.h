//
//  CalendarViewController.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarType) {
    CalendarTypeDay,
    CalendarTypeMonth,
    CalendarTypeYear
};

@interface CalendarViewController : UIViewController

@property (nonatomic) CalendarType calendarType;

- (void)didPickDateWithCompletionBlock:(void(^)(NSDate* dateSelected))callBackBlock;

@end
