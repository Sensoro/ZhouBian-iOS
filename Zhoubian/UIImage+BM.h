//
//  UIImage+BM.h
//  Sensoro Configuration Utility
//
//  Created by admin on 14-4-12.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BM)

// 剪切图片大小
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
@end
