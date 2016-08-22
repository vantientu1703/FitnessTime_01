//
//  Category.h
//  GymManager
//
//  Created by Thinh on 8/16/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

//This protocol is requied by JSONModel
@protocol Item
@end

@interface Item : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) double price;
@property (nonatomic) NSInteger quantity;

@end
