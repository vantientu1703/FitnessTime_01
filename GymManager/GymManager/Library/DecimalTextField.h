//
//  DecimalTextField.h
//  GymManager
//
//  Created by Thinh on 9/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecimalTextField : UITextField <UITextFieldDelegate>

@property (nonatomic) double value;
@property (nonatomic) NSUInteger maxLength;
@property (nonatomic) NSUInteger maximumFractionDigits;
@property (nonatomic) NSUInteger minimumFractionDigits;
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@end
