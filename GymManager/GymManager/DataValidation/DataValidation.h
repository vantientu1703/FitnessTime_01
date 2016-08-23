//
//  DataValidation.h
//  Elearning
//

#import <Foundation/Foundation.h>

@interface DataValidation : NSObject
+ (NSString *)isValidEmailAddress:(NSString *)emailAddress;
+ (NSString *)isValidPassword:(NSString *)password;
+ (NSString *)isValidConfirmedPassword:(NSString *)confirmedPassword password:(NSString *)password;
+ (NSString *)isValidName:(NSString *)name;
@end
