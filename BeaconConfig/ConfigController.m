//
//  ConfigController.m
//  BeaconConfig
//
//  Created by skyming on 15/4/1.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "ConfigController.h"
#import <SensoroBeaconKit/SBKBeacon.h>
#import "SNBeaconObserver.h"
#import "BroadcastConfig.h"
#import "RTSpinKitView.h"
#import "BMMacroDefinition.h"
#import "SVProgressHUD.h"

@interface ConfigController ()<UINavigationControllerDelegate>
{
    CAGradientLayer *_gradient;
}
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) SBKBeacon *configBeacon;
@end

@implementation ConfigController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setGradientbgColor];
    self.title = NSLocalizedString(@"START_CONFIG", @"开始配置");
    
    _configBeacon =  [SNBeaconObserver sharedInstance].configBeacon;
    
    UIImage *backImage = [[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backToPro)];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height * 0.35, 200, 80)];
    _loadingView.center = CGPointMake(kScreen_Width/2.0, _loadingView.center.y);
  
    RTSpinKitView *loadingSpin = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[UIColor whiteColor]];
    loadingSpin.frame = CGRectMake(83, 0, 100, 40);
    [_loadingView addSubview:loadingSpin];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 200, 30)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.text = NSLocalizedString(@"START_CONFIG", @"开始配置");
    [_loadingView addSubview:loadingLabel];
    
    [self.view addSubview:_loadingView];
    
    __block BOOL configSuccess = YES;
    
    if (_configBeacon.beaconID) {
        
        NSLog(@">>>>>>>>>> Start config >>>>>>>>");
        [loadingSpin startAnimating];
        [_configBeacon connectWithCompletion:^(NSError *error) {
            if (!error) {
                NSLog(@"Connect successful %@",[SNBeaconObserver sharedInstance].configBeacon.beaconID);
                __block int count = 0;
                [_configBeacon writeProximityUUID:[BroadcastConfig sharedBroadcastConfig].uuid completion:^(NSError *error) {
                    if (!error) {
                        NSLog(@"UUID <<<<< %@",[BroadcastConfig sharedBroadcastConfig].uuid.UUIDString);
                        configSuccess &= YES;
                    }else{
                        NSLog(@"Error: %@",error.localizedDescription);
                        configSuccess &= NO;
                    }
                    ++count;
                    if (count == 2) {
                        [_loadingView removeFromSuperview];
                        if (configSuccess) {
                            [SVProgressHUD showImage:[UIImage imageNamed:@"success"] status:@"配置成功" maskType:SVProgressHUDMaskTypeNone];
                        }else{
                            [SVProgressHUD showImage:[UIImage imageNamed:@"failure"] status:@"配置失败" maskType:SVProgressHUDMaskTypeNone];
                        }
                        
                        [_configBeacon disconnect];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self backToPro];
                        });
                    }
                }];
                
                NSNumber *major = @([BroadcastConfig sharedBroadcastConfig].major);
                NSNumber *minor = @([BroadcastConfig sharedBroadcastConfig].minor);
                [_configBeacon writeMajor:major minor:minor completion:^(NSError *error) {
                    if (!error) {
                        NSLog(@"Major Minor <<<<< %@ %@",major,minor);
                        configSuccess &= YES;
                    }else{
                        NSLog(@"Error: <<<<<<<<%@",error.localizedDescription);
                        configSuccess &= NO;
                    }
                    ++count;
                    if (count == 2) {
                        [_loadingView removeFromSuperview];
                        if (configSuccess) {
                            [SVProgressHUD showImage:[UIImage imageNamed:@"success"] status:@"配置成功"];
                        }else{
                            [SVProgressHUD showImage:[UIImage imageNamed:@"failure"] status:@"配置失败"];
                        }
                        [_configBeacon disconnect];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self backToPro];
                        });

                    }

                }];
                

            }else{
                NSLog(@"Error: <<<<<<<<%@",error.localizedDescription);
                configSuccess &= NO;
                [_loadingView removeFromSuperview];
                [SVProgressHUD showImage:[UIImage imageNamed:@"failure"] status:@"配置失败"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backToPro];
                });

            };
        }];
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TIP", @"提示")
                                                         message:NSLocalizedString(@"BEACON_NOT_FOUND", @"Beacon尚未发现")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"确定")
                                               otherButtonTitles:nil];
        
        [alert show];

        [_loadingView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_configBeacon disconnect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"");
    [self backToPro];
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
