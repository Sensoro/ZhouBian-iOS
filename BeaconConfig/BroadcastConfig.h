//
//  BroadcastConfig.h
//  BeaconConfig
//
//  Created by skyming on 15/4/1.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMacroDefinition.h"

@interface BroadcastConfig : NSObject

@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic) unsigned int major,minor;

singleton_interface(BroadcastConfig)

- (void)configSetting:(NSString *)uuid major:(NSString *)major minor:(NSString *)minor;
- (void)configSetting:(NSDictionary *)setting;

@end
