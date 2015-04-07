//
//  SENQRCodeViewController.m
//  Sensoro Beacon Utility
//
//  Created by Zihua Li on 8/6/14.
//  Copyright (c) 2014 Sensoro. All rights reserved.
//

#import "SENQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZBarSDK.h"
#import "BMMacroDefinition.h"
#import "FunctionSelectController.h"
#import "BroadcastConfig.h"
#import "SVProgressHUD.h"
#import "ConfigController.h"


static NSString * const kWeChatConfigPrefix = @"http://zb.weixin.qq.com/nearby/device/";
static NSString * const kWeChatConfigPrefixs = @"https://zb.weixin.qq.com/nearby/device/";


@interface SENQRCodeViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL _finished;
    ZBarImageScanner * scanner;
    int num;
    BOOL upOrdown;
    NSTimer * timer;

}
@property (nonatomic, strong) UIView *previewView;
@property (strong, nonatomic)  UIActivityIndicatorView *loadingActivityIndicatorView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) UIButton *openFlashLightButton ;
@end

@implementation SENQRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _keepShow = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _edgeInsetTop = 35;
    _edgeInsetleft = 25;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    
    self.title = NSLocalizedString(@"QR_SCAN_TITLE_CONFIG", @"获取配置");
    if(self.type == ScanTypeQR){
        self.title = @"扫描设备二维码";
    }
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width,kScreen_Height)];
    [self.view addSubview:self.previewView];
    
    self.loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 150, 10, 10)];
    [self.view addSubview:self.loadingActivityIndicatorView];
    self.captureSession = nil;
    
    if (self.type == ScanTypeQR) {
        UIImage *backImage = [[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backToPro)];
    }

    
//    UIImage * image = [UIImage imageNamed:@"photo"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(openPhotoLibrary)];
    if(!self.allowedBarcodeTypes){
        self.allowedBarcodeTypes = @[@"org.iso.QRCode"];
    }
    
    [self setupMaskBackground];
    
    [self lineAnimation];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopReading];
    [timer invalidate];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [self restartScan];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(autoMoveUpandDown) userInfo:nil repeats:YES];
}

- (void)autoMoveUpandDown{
    
    CGFloat weight = kScreen_Width - _edgeInsetleft * 2 -10;
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 40+2*num, weight, 2);
        _line.center = CGPointMake(kScreen_Width/2.0, _line.center.y);
        if (2*num > weight) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 40+2*num, weight, 2);
        _line.center = CGPointMake(kScreen_Width/2.0, _line.center.y);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (void)lineAnimation{
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, -15, 270, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
}
- (void)setupMaskBackground{
    
    // 背景图片
    CGFloat weight = kScreen_Width - _edgeInsetleft * 2;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_edgeInsetleft, _edgeInsetTop, weight, weight)];
    imageView.image = [[UIImage imageNamed:@"pick_bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageView.tintColor = [UIColor whiteColor];
    
    // 说明文字7
    CGFloat labelFrameY = imageView.frame.origin.y + imageView.frame.size.height + 20;
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(_edgeInsetleft, labelFrameY, weight, 44)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text = self.tipSring;

    
    CGFloat interval = 5.0;
    CALayer *top = [[CALayer alloc]init];
    top.frame = CGRectMake(0, 0, kScreen_Width, _edgeInsetTop+interval);
    top.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5].CGColor;
    [self.view.layer addSublayer:top];
    
    CALayer *bottom = [[CALayer alloc]init];
    bottom.frame = CGRectMake(0, labelFrameY-20-interval, kScreen_Width, kScreen_Height-labelFrameY+20+interval);
    bottom.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5].CGColor;
    [self.view.layer addSublayer:bottom];
    
    CALayer *left = [[CALayer alloc]init];
    left.frame = CGRectMake(0, _edgeInsetTop+interval, (kScreen_Width-imageView.frame.size.width)/2.0+interval, imageView.frame.size.height-interval*2);
    left.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5].CGColor;
    [self.view.layer addSublayer:left];
    
    CALayer *right = [[CALayer alloc]init];
    right.frame = CGRectMake(kScreen_Width - _edgeInsetleft-interval,_edgeInsetTop+interval, _edgeInsetleft+interval, imageView.frame.size.height-interval*2);
    right.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5].CGColor;
    [self.view.layer addSublayer:right];
    
  
    [self.view addSubview:labIntroudction];
    [self.view addSubview:imageView];

    // 开灯
    _openFlashLightButton = [self buttonWithImage:@"fresh_on_iphone5"];
    _openFlashLightButton.center = CGPointMake(labIntroudction.center.x -80, labIntroudction.center.y + 80);
    [_openFlashLightButton addTarget:self action:@selector(openFlashlight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_openFlashLightButton];
    
    // 二维码来自相册
    UIButton *fromAlumButton = [self buttonWithImage:@"photo"];
    [fromAlumButton setImageEdgeInsets:UIEdgeInsetsMake(12.5, 10, 12.5, 10)];
    fromAlumButton.center = CGPointMake(labIntroudction.center.x+80, labIntroudction.center.y + 80);
    [fromAlumButton addTarget:self action:@selector(openPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fromAlumButton];
    
    if(isIphone4){
        labIntroudction.center = CGPointMake(labIntroudction.center.x, kScreen_Height-150);
        _openFlashLightButton.center = CGPointMake(_openFlashLightButton.center.x,kScreen_Height-95);
        fromAlumButton.center = CGPointMake(fromAlumButton.center.x, kScreen_Height-95);
    }
    
}

- (UIButton *)buttonWithImage:(NSString *)image{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 25;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    return button;
}

- (void)backToPro{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openFlashlight
{
    if (_captureDevice.torchMode == AVCaptureTorchModeOff) {
        [_captureDevice lockForConfiguration:nil];
        [_captureDevice setTorchMode:AVCaptureTorchModeOn];
        [_captureDevice unlockForConfiguration];
//        [_openFlashLightButton setTitle:@"关灯" forState:UIControlStateNormal];
    }else{
        [_captureDevice lockForConfiguration:nil];
        [_captureDevice setTorchMode:AVCaptureTorchModeOff];
        [_captureDevice unlockForConfiguration];
//        [_openFlashLightButton setTitle:@"开灯" forState:UIControlStateNormal];
    }
}

- (void) restartScan{
    [self startReading];
    
    _finished = NO;
}

- (BOOL)startReading {
    NSError *error;
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Ipad 无灯处理
    if (![_captureDevice hasTorch]) {
        _openFlashLightButton.enabled = NO;
        _openFlashLightButton.layer.borderColor = [UIColor grayColor].CGColor;
    }
    // IOS 7 下 自动对焦 Near
    if ([_captureDevice respondsToSelector:@selector(isAutoFocusRangeRestrictionSupported)] && _captureDevice.autoFocusRangeRestrictionSupported) {
        // If we are on an iOS version that supports AutoFocusRangeRestriction and the device supports it
        // Set the focus range to "near"
        if ([_captureDevice lockForConfiguration:nil]) {
            _captureDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            [_captureDevice unlockForConfiguration];
        }
    }
    
    // IOS 8 下固定焦距 0.35 最佳距离 15~20 cm
    if (IsAfterIOS8) {
        
        if ([_captureDevice lockForConfiguration:nil]) {
            [_captureDevice setFocusModeLockedWithLensPosition:0.35 completionHandler:^(CMTime syncTime) {
            }];
            [_captureDevice unlockForConfiguration];
            
        }
        
    }

    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:captureMetadataOutput.availableMetadataObjectTypes];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
//    CGRect viewPort = CGRectMake(50, 50, 100, 100);
//    [_videoPreviewLayer setFrame:viewPort];
    [_previewView.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    [_loadingActivityIndicatorView stopAnimating];
    
    //[_placeholderView setHidden:YES];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (_finished) return;
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([self.allowedBarcodeTypes containsObject:metadataObj.type]) {
            _finished = YES;
            NSString *value = [metadataObj stringValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_keepShow == NO) {

                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    [self checkConfig:value];

                }
                
                [self stopReading];
                
                if (self.completion != nil) {
                    self.completion(value);
                }

                
            });
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)openPhotoLibrary{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    // Don't forget to add UIImagePickerControllerDelegate in your .h
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        NSInteger ret = [self scanImage:originalImage.CGImage withScaling:0];
        
        if (ret > 0) {
            if (_keepShow == NO) {
                
//                CATransition *ca = [CATransition animation];
//                ca.type = @"oglFlip";
//                ca.subtype = kCATransitionFromRight;
//                ca.duration = 1.0;
//                [self.navigationController.view.layer addAnimation:ca forKey:nil];
//                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            ZBarSymbol *symbol = nil;
            for(symbol in scanner.results)
                break;
            NSString * value = symbol.data;
            if (self.completion != nil) {
                self.completion(value);
            }
            if (_keepShow == YES) {
                [self checkConfig:value];
            }
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TIP", @"提示")
                                                             message:NSLocalizedString(@"QR_CODE_INCORRECT", @"二维码错误，请扫描正确的二维码")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"确定")
                                                   otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (NSInteger) scanImage: (CGImageRef) image
            withScaling: (CGFloat) scale
{
    const CGRect scanCrop = CGRectMake(0, 0, 1, 1);
    const CGFloat maxScanDimension = 640;
    
    size_t w = CGImageGetWidth(image);
    size_t h = CGImageGetHeight(image);
    CGRect crop;
    if(w >= h)
        crop = CGRectMake(scanCrop.origin.x * w, scanCrop.origin.y * h,
                          scanCrop.size.width * w, scanCrop.size.height * h);
    else
        crop = CGRectMake(scanCrop.origin.y * w, scanCrop.origin.x * h,
                          scanCrop.size.height * w, scanCrop.size.width * h);
    
    CGSize size;
    if(crop.size.width >= crop.size.height &&
       crop.size.width > maxScanDimension)
        size = CGSizeMake(maxScanDimension,
                          crop.size.height * maxScanDimension / crop.size.width);
    else if(crop.size.height > maxScanDimension)
        size = CGSizeMake(crop.size.width * maxScanDimension / crop.size.height,
                          maxScanDimension);
    else
        size = crop.size;
    
    if(scale) {
        size.width *= scale;
        size.height *= scale;
    }
    
    if (scanner == nil) {
        scanner = [ZBarImageScanner new];
    }
    
    [scanner setSymbology: 0
                   config: ZBAR_CFG_X_DENSITY
                       to: 2];
    [scanner setSymbology: 0
                   config: ZBAR_CFG_Y_DENSITY
                       to: 2];
    
    
    int density;
    if(size.width > 720)
        density = (size.width / 240 + 1) / 2;
    else
        density = 1;
    [scanner setSymbology: 0
                   config: ZBAR_CFG_X_DENSITY
                       to: density];
    
    if(size.height > 720)
        density = (size.height / 240 + 1) / 2;
    else
        density = 1;
    [scanner setSymbology: 0
                   config: ZBAR_CFG_Y_DENSITY
                       to: density];
    
    ZBarImage *zimg = [[ZBarImage alloc]
                       initWithCGImage: image
                       crop: crop
                       size: size];
    NSInteger nsyms = [scanner scanImage: zimg];
    
    return(nsyms);
}

- (void)checkConfig:(NSString *)value{
    
    if (self.type == ScanTypeQR) {
        [self checkYunzi:value];
    }
    
    if ([value hasPrefix:kWeChatConfigPrefix] ||[value hasPrefix:kWeChatConfigPrefixs]){
        NSURL * url = [NSURL URLWithString:value];
        
        void (^errorTip)(void) = ^{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TIP", @"提示")
                                                             message:NSLocalizedString(@"CONFIG_FORMAT_WRONG", @"配置格式错误!")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"确定")
                                                   otherButtonTitles:nil];
            
            [alert show];
            
        };
        
        if (url == nil) {
            dispatch_async(dispatch_get_main_queue()
                           , errorTip);
            return ;
        }
        
        NSString * query = url.query;
        __block NSString* uuid,*major,*minor;
        
        NSArray * parameters = [query componentsSeparatedByString:@"&"];
        [parameters enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            
            NSRange range = [obj rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString* name = [obj substringToIndex:range.location];
                NSString* value = [obj substringFromIndex:range.location + 1];
                
                if ([name isEqualToString:@"uuid"]) {
                    uuid = value;
                }else if ([name isEqualToString:@"major"]){
                    major = value;
                }else if ([name isEqualToString:@"minor"]){
                    minor = value;
                }
            }
        }];
        
        if (uuid != nil && major != nil && minor != nil) {
            
            [[BroadcastConfig sharedBroadcastConfig] configSetting:uuid major:major minor:minor];
            FunctionSelectController *controller =[[FunctionSelectController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            
            
        }else{
            dispatch_async(dispatch_get_main_queue()
                           , errorTip);
            return;
        }
    }else{
        NSError *error;
        NSDictionary * result = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:0 error:&error];
        if (!error && result != nil && [result isKindOfClass:[NSDictionary class]]) {
        
            [[BroadcastConfig sharedBroadcastConfig]configSetting:result];
            FunctionSelectController *controller =[[FunctionSelectController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"二维码配置信息格式不对"];
                [self stopReading];
                [self restartScan];
            });
        }
    }

}

- (void)checkYunzi:(NSString *)value{
    
    NSLog(@"Value: %@",value);
    
    // 判断云子是否合法
    BOOL isYunzi = NO;
    // A0
    if ([value hasPrefix:@"A0"]&&value.length == 42 ) {
        isYunzi = YES;
    }
    // B0 、C0
    if (value.length == 39) {
        isYunzi = YES;
    }
    
    
    if (!isYunzi) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"YunziInvalid", nil)];
        return ;
    }
    

}
@end
