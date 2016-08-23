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

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString<Optional> *fullName;
@property (strong, nonatomic) NSString<Optional> *telNumber;
@property (strong, nonatomic) NSString<Optional> *address;
@property (strong, nonatomic) NSString<Optional> *email;
@property (strong, nonatomic) NSDate<Optional> *birthday;
@property (strong, nonatomic) NSString<Optional> *avatar;

@end
