//
//  FunctionSelectController.m
//  BeaconConfig
//
//  Created by skyming on 15/4/1.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "FunctionSelectController.h"
#import "BMMacroDefinition.h"
#import "SimulateController.h"
#import "SENQRCodeViewController.h"
#import "SVProgressHUD.h"
#import "ConfigController.h"
#import "SNBeaconObserver.h"
#import <SensoroBeaconKit/SBKBeacon.h>
#import "SelectButton.h"

@interface FunctionSelectController ()
{
    UIButton *_simulateButton;
    UIButton *_startConfigButton;
    CAGradientLayer *_gradient;
}
@end

@implementation FunctionSelectController

#pragma mark- Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"FUNCTION_SELECTED", @"选择功能");
    
    
    // 用iPhone模拟
    _simulateButton = [self buttonWithTitle:NSLocalizedString(@"USE_IPHONE_DEVICE", @"使用iPhone模拟设备")];
    _simulateButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    _simulateButton.center = CGPointMake(kScreen_Width/2.0, kScreen_Height*0.3);
    [_simulateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_simulateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_simulateButton addTarget:self action:@selector(simulateController) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 配置云子
    _startConfigButton = [self buttonWithTitle:NSLocalizedString(@"START_CONFIG_DEVICE", @"开始配置设备（支持云子、云盒、云标）")];
    _startConfigButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [_startConfigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startConfigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [_startConfigButton addTarget:self action:@selector(configController) forControlEvents:UIControlEventTouchUpInside];
    _startConfigButton.center = CGPointMake(kScreen_Width/2.0, 65 + kScreen_Height*0.3);

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addSubview:_simulateButton];
    [self.view addSubview:_startConfigButton];
    [self setGradientbgColor];
    
    // 修改从相册取二维码，状态栏变色问题
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 
    [_simulateButton removeFromSuperview];
    [_startConfigButton removeFromSuperview];
    [_gradient removeFromSuperlayer];
}


// =============================================================================
#pragma mark - Private

- (void)setGradientbgColor{
    
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, kContent_Width, kContent_Height);
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

- (void)simulateController{
    
    CATransition *ca = [CATransition animation];
    ca.type = @"oglFlip";
    ca.subtype = kCATransitionFromRight;
    ca.duration = 1.0;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];
    
    SimulateController *controller = [[SimulateController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)configController{
    
    CATransition *ca = [CATransition animation];
    ca.type = @"oglFlip";
    ca.subtype = kCATransitionFromRight;
    ca.duration = 1.0;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];

    SENQRCodeViewController *controller = [[SENQRCodeViewController alloc]init];
    controller.type = ScanTypeQR;
    controller.tipSring = NSLocalizedString(@"QR_SCAN_TIP_BEACON", @"扫描云子、云盒、云标等硬件设备上的二维码");
    controller.completion = ^(NSString *value){
        NSLog(@"云子%@",value);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkYunzi:value];
        });

    };
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)checkYunzi:(NSString *)value{
    
    NSLog(@"Value: %@",value);

    NSString *sn = [value copy];
    // 判断云子是否合法
    BOOL isYunzi = NO;
    // A0
    if ([value hasPrefix:@"A0"]&&value.length == 42 ) {
        isYunzi = YES;
    }
    // B0 、C0
    if (value.length == 39) {
        isYunzi = YES;
        sn = [value substringWithRange:NSMakeRange(0,12)];
    }
    
    if (!isYunzi) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"YunziInvalid", nil)];
        return ;
    }
    
    SBKBeacon* beaconObject =  [SNBeaconObserver sharedInstance].allYunziDict[sn];

    [SNBeaconObserver sharedInstance].configBeacon = beaconObject;
    
    ConfigController *config = [[ConfigController alloc]init];
    [self.navigationController pushViewController:config animated:YES];
}


- (SelectButton *)buttonWithTitle:(NSString *)title{
    
    SelectButton *button = [SelectButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 280, 50);
//    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 5.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitle:title forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];

    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
