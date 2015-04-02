//
//  BMDefineUtils.h
//  Sensoro Configuration Utility
//  @discussion 常用宏定义
//  Created by skyming on 14-4-15.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#ifndef Sensoro_Configuration_Utility_BMDefineUtils_h
#define Sensoro_Configuration_Utility_BMDefineUtils_h

#pragma mark- 颜色
//----------------------颜色----------------------------
// 获取颜色--RGBA
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 获取颜色--RGB
#define RGB(r,g,b)          RGBA(r,g,b,1.0f)
// 获取颜色--十六进制（十六进制->十进制）0xFFEEAA
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//----------------------颜色----------------------------


#pragma mark- 系统版本
//----------------------系统版本----------------------------
// 系统版本号
#define isIOS4 ([[[UIDevice currentDevice] systemVersion] intValue]==4)
#define isIOS5 ([[[UIDevice currentDevice] systemVersion] intValue]==5)
#define isIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]==6)
#define isIOS7 ([[[UIDevice currentDevice] systemVersion] intValue]==7)
#define isIOS8 ([[[UIDevice currentDevice] systemVersion] intValue]==8)

#define isAfterIOS4 ([[[UIDevice currentDevice] systemVersion] intValue] >= 4)
#define isAfterIOS5 ([[[UIDevice currentDevice] systemVersion] intValue] >= 5)
#define isAfterIOS6 ([[[UIDevice currentDevice] systemVersion] intValue] >= 6)
#define IsAfterIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)
#define IsAfterIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)

#define iOSCurrentVersion ([[UIDevice currentDevice] systemVersion])
//----------------------系统版本----------------------------



#pragma mark- 屏幕类型
//----------------------屏幕类型----------------------------
// Retina屏幕判断
#define isRetina ([[UIScreen mainScreen] scale]==2)
// Pad设备判断--Xib或Storyboard
#define isPad_XIB (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isPad ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)

// 5.5屏幕判断
#define isIPhone6S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
// 4.7屏幕判断
#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 4.0屏幕判断
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 3.5屏幕判断
#define isIphone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//  已弃用
#define kScaleWidth5(n) (n * 320.0f /375.0f)
#define kScaleWidth6S(n) (n * 414.0f/375.0f)
#define kScaleHeight5(n) (n * 1.0f /1.174f)
#define kScaleHeight6S(n) (n * 1.43f)
//----------------------屏幕类型----------------------------


#pragma mark- 屏幕大小
//----------------------屏幕大小----------------------------
//应用尺寸(不包括状态栏,通话时状态栏高度不是20，所以需要知道具体尺寸)
#define kContent_Height   ([UIScreen mainScreen].applicationFrame.size.height)
#define kContent_Width    ([UIScreen mainScreen].applicationFrame.size.width)
#define kContent_Frame    (CGRectMake(0, 0 ,kContent_Width,kContent_Height))
#define kContent_CenterX  kContent_Width/2
#define kContent_CenterY  kContent_Height/2

//设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

//屏幕固定高度
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
//----------------------屏幕大小----------------------------


#pragma mark- Frame
//----------------------Frame----------------------------
//获取 Frame 的 x，y 坐标
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
//获取 Frame 的宽高
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)
//----------------------Frame----------------------------



#pragma mark- UIView Frame
//----------------------UIView Frame----------------------------
//获取 UIView Frame 的 x，y 坐标
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)
//获取 UIView Frame 的宽高
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)
//----------------------UIView Frame----------------------------




#pragma mark---- 文件路径
//----------------------文件路径----------------------------
// 文件相关路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_CacheDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define PATH_OF_LibraryDirectory [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define DocumentsSubDirectory(dir) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dir]

#define LibrarySubDirectory(dir) [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dir]

#define CacheSubDirectory(dir) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dir]

#define TempSubDirectory(dir) [NSTemporaryDirectory() stringByAppendingPathComponent:dir]

//----------------------文件路径----------------------------




#pragma mark-自定义输出
//----------------------自定义输出----------------------------
//自定义输出
#ifdef DEBUG

#define MyLog(...) NSLog(__VA_ARGS__)

//重写NSLog,Debug模式下打印日志和当前行数
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#else
#define MyLog(...)
#define ULog(...)

#endif


// 输出frame(frame是结构体，没法%@)
#define LOGRECT(f) NSLog(@"Rect: \nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
// 输出BOOL值
#define LOGBOOL(b)  NSLog(@"%@",b?@"YES":@"NO");
// 输出对象方法
#define DNSLogMethod    NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
// 点
#define DNSLogPoint(p)  NSLog(@"%f,%f", p.x, p.y);
// Size
#define DNSLogSize(p)   NSLog(@"%f,%f", p.width, p.height);
//----------------------自定义输出----------------------------



//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil

//----------------------内存----------------------------



//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,有缓存，性能高于后者
//----------------------图片----------------------------





// 代理
#define APPDELEGATE [UIApplication sharedApplication]  delegate]
//获取当前语言
#define CurrentLanguage ([[NSLocale currentLocale] localeIdentifier])

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件 根据具体项目修改
#define MyLocal(x, ...) NSLocalizedString(x, nil)


//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


#pragma mark- Action
// openURL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define openURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])

// telphone
#define canTel   ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]])

#define tel(phoneNumber)       ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])

#define telprompt(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]])


//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]


/*
 专门用来保存单例代码
 最后一行不要加 \
 */
//----------------------单粒----------------------------
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
//----------------------单粒----------------------------

#endif
