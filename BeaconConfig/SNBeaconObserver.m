//
//  SNBeaconObserver.m
//  SensoroTriggerConfig
//
//  Created by skyming on 14-6-25.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "SNBeaconObserver.h"
#import <SensoroBeaconKit/SensoroBeaconKit.h>
#import "SVProgressHUD.h"


//static NSString * const kBroadcastKeyStore = @"kBroadcastKeyStore";


@interface SNBeaconObserver()<SBKBeaconManagerDelegate,CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothStateManger;
@property (strong, nonatomic) NSArray * supportedProximityUUIDs; // 支持的UUID

@end

@implementation SNBeaconObserver

#pragma mark- LifeCycle

+ (instancetype) sharedInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark- Private

+ (NSString* )queryString:(SBKBeaconID *)beaconID{
    return [NSString stringWithFormat:@"%@-%@-%@",[beaconID.proximityUUID UUIDString],beaconID.major,beaconID.minor];
}

- (void)startService:(BOOL)isTips{
    
    // start SBK Serverce
    [[SBKBeaconManager sharedInstance] requestAlwaysAuthorization];

    _supportedProximityUUIDs =
    @[[[NSUUID alloc] initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"], //Sensoro
      [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"], //AirLocate
      [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] ,// Estimote
      [[NSUUID alloc] initWithUUIDString:@"63EA09C2-5345-4E6D-9776-26B9C6FC126C"],// Random for C54
      [[NSUUID alloc] initWithUUIDString:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825"]// weixin
      ];
    
        
    //添加解密用密钥
    [[SBKBeaconManager sharedInstance] addBroadcastKey:@"7b4b5ff594fdaf8f9fc7f2b494e400016f461205"];
    
    for (NSUUID *uuid  in _supportedProximityUUIDs) {
        SBKBeaconID *beaconId = [SBKBeaconID beaconIDWithProximityUUID:uuid];
        [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconId wakeUpApplication:NO];
    }
    
    [SBKBeaconManager sharedInstance].delegate = self;
    
    _allYunziDict = [NSMutableDictionary dictionary];
    _configBeacon = [[SBKBeacon alloc]init];
    
    
    // Monitor bluetoothState
    self.bluetoothStateManger = [[CBCentralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

- (void)stopService:(BOOL)isTips
{
    [[SBKBeaconManager sharedInstance] stopRangingAllBeacons];
}

#pragma mark- SBKBeacon Delegate

- (void)beaconManager:(SBKBeaconManager *)beaconManager scanDidFinishWithBeacons:(NSArray *)beacons
{
    [self enumerate:beacons];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *tips = nil;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            tips = NSLocalizedString(@"BlueToothStatePoweredOff", @"蓝牙状态关闭");
            _bluetoothStatus = CBCentralManagerStateUnsupported;
            break;
        case CBCentralManagerStatePoweredOff:
            tips = NSLocalizedString(@"BlueToothStatePoweredOff", @"蓝牙状态关闭");
            _bluetoothStatus = CBCentralManagerStatePoweredOff;
            break;

        case CBCentralManagerStateResetting:
//            tips = NSLocalizedString(@"BlueToothStateResetting", @"蓝牙重置");
            _bluetoothStatus = CBCentralManagerStateResetting;
            break;
        case CBCentralManagerStateUnsupported:
            tips = NSLocalizedString(@"BlueToothStateUnsupported", @"不支持BLE");
            _bluetoothStatus = CBCentralManagerStateUnsupported;
            break;
        case CBCentralManagerStateUnauthorized:
            tips = NSLocalizedString(@"BlueToothStateUnauthorized", @"应用未授权使用BLE");
            _bluetoothStatus = CBCentralManagerStateUnauthorized;
            break;
        case CBCentralManagerStatePoweredOn:
            _bluetoothStatus = CBCentralManagerStatePoweredOn;
            break;

        default:
            break;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (tips) {
            [SVProgressHUD showErrorWithStatus:tips];
        }
    });
    

}

#pragma mark- Private

- (void)enumerate:(NSArray *)beacons{
   
    if(beacons.count <= 0){
        return ;
    }
    
    // Enumerate

    for (SBKBeacon *beacon in beacons) {
        
        // SN == nil contine;
        if(!beacon.serialNumber || !beacon.beaconID){
            continue ;
        }

        if ([beacon.serialNumber isEqualToString:@"0117C53A2F26"]) {
            NSLog(@"-------------------->%@",beacon.serialNumber);
        }
        [self.allYunziDict setObject:beacon forKey:beacon.serialNumber];
        
    }
}

@end
