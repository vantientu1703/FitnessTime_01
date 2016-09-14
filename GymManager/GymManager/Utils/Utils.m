//
//  Utils.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIImage *)convertImageToThumbnailImage:(UIImage *)image withSize:(CGSize)size {
    CGFloat x0 = size.width * 5.f;
    CGFloat y0 = size.height * 5.f;
    CGFloat x1 = image.size.width;
    CGFloat y1 = image.size.height;
    CGFloat x2 = 0.f;
    CGFloat y2 = 0.f;
    if (x1 > y1) {
        x2 = x0;
        y2 = (x2 * y1) / x1;
    } else {
        y2 = y0;
        x2 = (y2 * x1) / y1;
    }
    CGSize viewSize = CGSizeMake(x2, y2);
    UIGraphicsBeginImageContext(viewSize);
    [image drawInRect:CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:strEncodeData
        options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSString *)convertImageToBase64:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.4f)
        base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
