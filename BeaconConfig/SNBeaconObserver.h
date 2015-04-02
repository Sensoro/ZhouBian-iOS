//
//  SNBeaconObserver.h
//  SensoroTriggerConfig
//
//  Created by skyming on 14-6-25.
//  Copyright (c) 2014年 Senroro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class SBKBeaconID;
@class SBKBeacon;
@protocol SNBeaconObserverDelegate <NSObject>
- (void)beaconObserverScanDidFinishWithBeacons:(NSArray *)beacons;

@end

@interface SNBeaconObserver : NSObject


@property (nonatomic) id<SNBeaconObserverDelegate>delegate;

@property (strong, nonatomic) NSMutableDictionary *allYunziDict;
@property (strong, nonatomic) SBKBeacon *configBeacon;
@property (nonatomic) CBCentralManagerState bluetoothStatus;

+ (instancetype)sharedInstance;

- (void)startService:(BOOL)isTips;
- (void)stopService:(BOOL)isTips;
+ (NSString* )queryString:(SBKBeaconID *)beaconID;

@end
