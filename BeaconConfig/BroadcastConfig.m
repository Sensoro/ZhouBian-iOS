//
//  BroadcastConfig.m
//  BeaconConfig
//
//  Created by skyming on 15/4/1.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "BroadcastConfig.h"

NSString * const UUID_IR = @"id";
NSString * const Major_IR = @"mj";
NSString * const Minor_IR = @"mi";

@interface BroadcastConfig ()

@end

@implementation BroadcastConfig

singleton_implementation(BroadcastConfig)

- (void)configSetting:(NSString *)uuid major:(NSString *)major minor:(NSString *)minor{
    
    [[NSScanner scannerWithString:[self HanderHex:major]] scanHexInt:&_major];
    [[NSScanner scannerWithString:[self HanderHex:minor]] scanHexInt:&_minor];
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    
}

- (void)configSetting:(NSDictionary *)setting{
    
    NSString *uuid = setting[UUID_IR];
    NSString *major = setting[Major_IR];
    NSString *minor = setting[Minor_IR];
    
    [self configSetting:uuid major:major minor:minor];
}

// 去掉十六进制前缀 0x
- (NSString *)HanderHex:(NSString *)hex{
    if ([hex hasPrefix:@"0x"]) {
        return  [hex substringFromIndex:2];
    }
    return hex;
}
@end
