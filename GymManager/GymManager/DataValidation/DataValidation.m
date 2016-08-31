//
//  DataValidation.m
//  Elearning
//

#import "DataValidation.h"

NSString *const kErrorEmailRequired = @"Email address required";
NSString *const kErrorEmailInvalid = @"Email invalid";
NSString *const kEmailFilterRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
NSInteger const kMaxLenght = 255;
NSString *const kLimitLenghtTitle = @"Limit email";
NSString *const kErrorPasswordRequired = @"Password required";
NSInteger const kMinLenghtReguired = 6;
NSString *const kMinLenghtReguiredTitle = @"Password should be at least is 6";
NSString *const kNotEquals = @"Confirm password not equals";
NSString *const kNameRequired = @"Name required";
NSInteger const kMaxLenghtNames = 50;
NSString *const kPhoneNumber = @"Phone number invalid";
NSString *const kPhoneNumberLength = @"Length phone number from 10 to 11 text";

@implementation DataValidation

+ (NSString *)isValidEmailAddress:(NSString *)emailAddress{
    // Check if email is empty
    if (![emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        return kErrorEmailRequired;
    } else if (emailAddress.length) {
        // Create predicate with format matching your regex string
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kEmailFilterRegex];
        // Check if email is invalid
        if (![emailPredicate evaluateWithObject:emailAddress]) {
            return kErrorEmailInvalid;
        }
    } else if (emailAddress.length > kMaxLenght) {
        return kLimitLenghtTitle;
    }
    return nil;
}

+ (NSString *)isValidPassword:(NSString *)password {
    // Check if password is empty
    if (![password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        return kErrorPasswordRequired;
    } else if (password.length < kMinLenghtReguired) {
        return kMinLenghtReguiredTitle;
    }
    return nil;
}

+ (NSString *)isValidConfirmedPassword:(NSString *)confirmedPassword password:(NSString *)password{
    if(![password isEqualToString:confirmedPassword]){
        return kNotEquals;
    }
    return nil;
}

+ (NSString *)isValidName:(NSString *)name {
    // Check if name is empty
    if (![name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        return kNameRequired;
    } else if (name.length > kMaxLenghtNames) {
        return kNameRequired;
    }
    return nil;
}

+ (NSString *)isValidPhoneNumber:(NSMutableString *)phoneNumber {
    if (phoneNumber.length < 10 || phoneNumber.length > 11) {
        return kPhoneNumberLength;
    }
    NSString *phoneNumberRegex = @"0[0-9]{9,10}";
    NSPredicate *phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumberRegex];
    if (![phoneNumberPredicate evaluateWithObject:phoneNumber]) {
        return kPhoneNumber;
    }
    return nil;
}

+ (NSString *)replaceSpaceInEmail:(NSMutableString *)email {
    return [email stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
