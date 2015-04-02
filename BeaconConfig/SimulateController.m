//
//  SimulateController.m
//  BeaconConfig
//
//  Created by skyming on 15/4/1.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "SimulateController.h"
#import "BroadcastConfig.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "MultiplePulsingHaloLayer.h"
#import "SVProgressHUD.h"

@interface SimulateController ()<CBPeripheralManagerDelegate>
{
    CAGradientLayer *_gradient;
}
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHalo;
@property (nonatomic, strong) UIImageView *beaconViewMuti;

@end

@implementation SimulateController

- (instancetype)init{
    self = [super init];
    if (self) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SIMULATING", @"模拟中");
    [self setGradientbgColor];
    
    self.beaconViewMuti = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yunzi"]];
    self.beaconViewMuti.frame = CGRectMake(0, 0, 100, 100);
    self.beaconViewMuti.center = CGPointMake(kScreen_CenterX, kScreen_CenterY);
    [self.view addSubview:_beaconViewMuti];
    
    [self settingMultiHalo];
    
    UIImage *backImage = [[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backToPro)];
    
}

- (void)settingMultiHalo{
    
    self.mutiHalo = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:4 andStartInterval:1];
    self.mutiHalo.radius = 200.0f;
    self.mutiHalo.pulseInterval = 1.5f;
    self.mutiHalo.animationDuration = 3.0f;
    self.mutiHalo.startInterval = 0.6f;
    self.mutiHalo.position = self.beaconViewMuti.center;
    self.mutiHalo.haloLayerColor = [[UIColor whiteColor] CGColor];
    self.mutiHalo.useTimingFunction = NO;
    [self.mutiHalo buildSublayers];
    [self.view.layer insertSublayer:self.mutiHalo below:self.beaconViewMuti.layer];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startServerce];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopServerce];
    
}


// =============================================================================
#pragma mark - Private

- (void)setGradientbgColor{
    
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)RGB(39, 156, 205).CGColor,
                           (id)RGB(125, 71, 220).CGColor,
                           nil];
        
    }
    
    [self.view.layer insertSublayer:_gradient atIndex:0];
    
}
- (void)backToPro{
    
    CATransition *ca = [CATransition animation];
    ca.type = @"oglFlip";
    ca.subtype = kCATransitionFromRight;
    ca.duration = 1.0;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取合法的peripheralData
- (NSDictionary *)getValidRegin_peripheralData{
    
    unsigned int major = -1,minor = -1;

    NSUUID *uuid = [BroadcastConfig sharedBroadcastConfig].uuid;
    major = [BroadcastConfig sharedBroadcastConfig].major;
    minor = [BroadcastConfig sharedBroadcastConfig].minor;
    
    NSLog(@"Data Major: %d %x Minor: %d %x",major,major,minor,minor);
    NSLog(@"UUID: %@",uuid.UUIDString);
    
    NSDictionary *peripheralData = nil;
    
    if(uuid && major != -1 && minor != -1)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:0x9999 minor:0x9999 identifier:@"com.apple.VirtualBeacon"];
        peripheralData = [region peripheralDataWithMeasuredPower:@(-59)];
    }
    else if(uuid && major != -1)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:0x9999  identifier:@"com.apple.VirtualBeacon"];
        peripheralData = [region peripheralDataWithMeasuredPower:@(-59)];
    }
    else if(uuid)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.apple.VirtualBeacon"];
        peripheralData = [region peripheralDataWithMeasuredPower:@(-59)];
    }
    return peripheralData;
    
}

// 开启、关闭广播
- (void)startServerce{
    
    NSDictionary *peripheralData = [self getValidRegin_peripheralData];
        
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
    if(peripheralData){
        [_peripheralManager startAdvertising:peripheralData];
    }
        
}

- (void)stopServerce{
    [_peripheralManager stopAdvertising];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CBPeripheralManager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@"CBPeripheralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"CBPeripheralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"CBPeripheralManagerStateUnsupported");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"CBPeripheralManagerStateUnauthorized");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"CBPeripheralManagerStatePoweredOff");
            break;
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"CBPeripheralManagerStatePoweredOn");
            break;
        default:
            break;
    }
    
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mutiHalo removeFromSuperlayer];
        });
        
    }else if(!_mutiHalo.superlayer){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self settingMultiHalo];
        });
    }
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
    NSLog(@"已广播：%d",peripheral.isAdvertising);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
