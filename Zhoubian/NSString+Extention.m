//
//  NSString+Contain.m
//  Sensoro Deployment Utility
//
//  Created by skyming on 3/25/15.
//  Copyright (c) 2015 Sensoro. All rights reserved.
//

#import "NSString+Extention.h"
#import <UIKit/UIKit.h>

static NSString * const kIDQrcodePrefix = @"http://k6.lc/";
static NSString * const kIDQrcodePrefixSecret = @"https://k6.lc/";


@implementation NSString (Extention)
- (BOOL)containsSubString:(NSString *)aString{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return  [self containsString:aString];
    }else{
#ifndef __IPHONE_8_0
        return ([string rangeOfString:aString] == 0)
#endif//__IPHONE_8
    }
    return NO;
}

- (NSString*) getRealPartOfQRCode{
    
    NSArray* prefixes = @[kIDQrcodePrefix,
                          kIDQrcodePrefixSecret
                          ];
    
    NSString* result = self;
    
    for (NSString* prefix in prefixes) {
        if ([self hasPrefix:prefix]) {
            result = [self substringFromIndex:prefix.length];//删除掉前缀。
            break;
        }
    }
    
    return result;
}

@end
