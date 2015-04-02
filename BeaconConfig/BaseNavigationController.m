//
//  BaseNavigationController.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-22.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Color.h"
#import "BMMacroDefinition.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
	// Do any additional setup after loading the view.
    __weak BaseNavigationController *weakSelf = self;


    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // 导航栏 背景色 TintColor
    [[UINavigationBar appearance] setBackgroundColor:RGB(26, 26, 26)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];

    // Title 颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [UINavigationBar appearance].titleTextAttributes = dict;
    

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Back"]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    // 导航栏&状态栏 一致性颜色
    // 方式一：
    // ios7 Crash
//    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)]) {
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
    
    
    [[UINavigationBar appearance] setBarTintColor:RGB(26, 26, 26)];
    
    // 方式二：
//    UIImage *image = [UIImage imageWithColor:RGB(31, 37, 42) andSize:CGSizeMake(kScreen_Width, 66)];
//    [[UINavigationBar appearance] setBackgroundImage:image forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

    
    
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance] setTitleTextAttributes: @{
//                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
//                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
//                                                            }];
//    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"nav"]  stretchableImageWithLeftCapWidth:1 topCapHeight:1]forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (IsAfterIOS7) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (IsAfterIOS7) {
        
    }
    
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        if (self.viewControllers.count ==1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        else
        {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)//关闭主界面的右滑返回
        return NO;
    return YES;
}



@end
