//
//  DecimalTextField.m
//  GymManager
//
//  Created by Thinh on 9/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DecimalTextField.h"

const double kDefaultMaxLength = 10;

@implementation DecimalTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.value = 0.0;
        [self addTarget:self action:@selector(textfieldCashDidChangeText)
            forControlEvents:UIControlEventEditingChanged];
        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.delegate = self;
        self.currencyFormatter = [[NSNumberFormatter alloc] init];
        [self.currencyFormatter setMaximumFractionDigits:self.maximumFractionDigits];
        [self.currencyFormatter setMinimumFractionDigits:self.minimumFractionDigits];
        [self.currencyFormatter setAlwaysShowsDecimalSeparator:NO];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        if (!self.maxLength) {
            self.maxLength = kDefaultMaxLength;
        }
    }
    return self;
}

- (void)textfieldCashDidChangeText {
    if (self.text.length) {
        if(![self.text hasSuffix:@"."]) {
            NSString *currentCost = [[self.text componentsSeparatedByCharactersInSet:[NSCharacterSet
                characterSetWithCharactersInString:@","]] componentsJoinedByString:@""];
            self.value = currentCost.doubleValue;
            //set textfield to currency style
            NSString *string = [self.currencyFormatter stringFromNumber:@(self.value)];
            self.text = string;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Limit characters for textfield
    if (textField.text.length >= self.maxLength && range.length) {
        return NO; // return NO to not change text
    } else if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        //if textfield already has "." , cancel.
        return NO;
    } else if (textField.text.length && [string isEqualToString:@"."]) {
        //if textfield isn't have anything and string is "." , cancel
        return NO;
    }
    return YES;
}

- (void)setValue:(double)value {
    _value = value;
    NSString *string = [self.currencyFormatter stringFromNumber:@(value)];
    self.text = string;
}

@end
