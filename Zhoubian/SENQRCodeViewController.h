//
//  SENQRCodeViewController.h
//  Sensoro Beacon Utility
//
//  Created by Zihua Li on 8/6/14.
//  Copyright (c) 2014 Sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_OPTIONS(NSUInteger, ScanType) {
    ScanTypeDefault,
    ScanTypeQR,
    ScanTypeConfig,
};

@interface SENQRCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) CGFloat edgeInsetTop; 
@property (nonatomic) CGFloat edgeInsetleft;

@property BOOL keepShow;//是否在扫描结束后返回。
@property (strong, nonatomic) NSString *tipSring; // 提示
@property (strong, nonatomic) NSArray * allowedBarcodeTypes;// 支持的扫描码类型
@property (nonatomic, copy) void (^completion)(NSString *); // 扫描完成后 Blcok 回调
@property (nonatomic) ScanType type;

- (void) restartScan; // 重新扫描

@end
