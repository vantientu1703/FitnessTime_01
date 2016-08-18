//
//  CalendarViewController.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController

- (void)didPickDateWithCompletionBlock:(void(^)(NSDate* dateSelected))callBackBlock;

@end
