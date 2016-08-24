//
//  Utils.h
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (UIImage *)convertImageToThumbnailImage:(UIImage *)image withSize:(CGSize)size;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

@end
