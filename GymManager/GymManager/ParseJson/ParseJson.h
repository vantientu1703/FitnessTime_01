//
//  ParseJson.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/25/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseJson : NSObject
+ (Meeting *)meetingWithDictionary:(NSDictionary *)dict;
@end
