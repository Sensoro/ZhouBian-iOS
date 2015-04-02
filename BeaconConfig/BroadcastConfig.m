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
    
    _uuid = [[NSUUID alloc]initWithUUIDString:uuid];
    _major = major.intValue;
    _minor = minor.intValue;
    
}

- (void)configSetting:(NSDictionary *)setting{
    
    NSString *uuid = setting[UUID_IR];
    NSString *major = setting[Major_IR];
    NSString *minor = setting[Minor_IR];
    
    [self configSetting:uuid major:major minor:minor];
}
@end
