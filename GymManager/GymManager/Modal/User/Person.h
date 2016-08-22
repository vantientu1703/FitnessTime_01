//
//  Person.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Person : JSONModel

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (strong, nonatomic) NSString *avatar;

@end
