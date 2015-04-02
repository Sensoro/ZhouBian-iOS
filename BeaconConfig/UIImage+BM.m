//
//  UIImage+BM.m
//  Sensoro Configuration Utility
//
//  Created by admin on 14-4-12.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "UIImage+BM.h"

@implementation UIImage (BM)
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
