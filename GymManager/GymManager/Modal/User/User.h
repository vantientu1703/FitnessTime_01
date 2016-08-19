//
//  User.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : Person

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *token;

@end
