//
//  UKScanQrcodeViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/13.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKScanQrcodeViewController.h"

#import "UKConfig.h"
#import "NSString+Helper.h"
#import "UKWebViewController.h"

@interface UKScanQrcodeViewController () <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate> {
    AVCaptureSession *_captureSession;
    int line_tag;
    int box_width;
}

@property (strong,nonatomic) IBOutlet UIButton *lightButton;

@end

@implementation UKScanQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";
    line_tag  = 1872637;
    box_width = 50;
    
    // 开启扫描
    [self startReading];
}

- (void)startReading {
    // 获取 AVCaptureDevice 实例
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理，在主线程里刷新
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        // 添加输入流
        [_captureSession addInput:input];
    }
    
    if (captureMetadataOutput) {
        // 添加输出流
        [_captureSession addOutput:captureMetadataOutput];
        
        // 设置元数据类型 AVMetadataObjectTypeQRCode
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        // 设置扫描的大小
        CGSize size = self.view.bounds.size;
        CGRect cropRect = CGRectMake(box_width, (self.view.center.y - (SCREEN_WIDTH - box_width*2)/2) , SCREEN_WIDTH - box_width*2, SCREEN_WIDTH - box_width*2);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.; // 使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight  = size.width*1920./1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            captureMetadataOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight, cropRect.origin.x/size.width, cropRect.size.height/fixHeight, cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            captureMetadataOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (cropRect.origin.x + fixPadding)/fixWidth, cropRect.size.height/size.height, cropRect.size.width/fixWidth);
        }
        
    }
    
    // 创建输出对象
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:self.view.layer.bounds];
    
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    
    // 设置覆盖层
    [self setOverlayView];
    
    [_captureSession addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    // 开始会话
    [_captureSession startRunning];
}

- (void)dealloc {
    [_captureSession removeObserver:self forKeyPath:@"running" context:nil];
}

/**
 * 监听扫码状态-修改扫描动画
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self setupAnimation];
        } else {
            [self removeAnimation];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

// 获取扫码结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        [_captureSession stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObject.stringValue;
        } else {
            NSLog(@"扫描对象不是二维码！");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

// 显示结果
- (void)reportScanResult:(NSString *)result {
    // 判断二维码结果是否为链接
    if ([result isValidURL]) {
        // 打开链接
        UKWebViewController *webViewController = [[UKWebViewController alloc] init];
        webViewController.urlString = result;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else if ([result isNumber]) {
        // 数字，打开产品控制器
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二维码扫描结果"
                                                        message:result
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *  未识别(其他)的二维码提示点击"确定",继续扫码
 *
 *  @param alertView
 */
- (void)alertViewCancel:(UIAlertView *)alertView {
    [_captureSession startRunning];
}

/**
 * 创建扫描层
 */
- (void)setOverlayView {
    // 左侧view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, SCREEN_HEIGHT)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    // 右侧View
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, SCREEN_HEIGHT)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    // 最上部view
    UIImageView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, (self.view.center.y -(SCREEN_WIDTH - 100)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    // 底部view
    UIImageView *downView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (self.view.center.y + (SCREEN_WIDTH - 100)/2), (SCREEN_WIDTH - 100), (SCREEN_HEIGHT - (self.view.center.y - (SCREEN_WIDTH - 100)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    // 中心View
    UIImageView *scanPreview = [[UIImageView alloc] initWithFrame:CGRectMake(50, (self.view.center.y - (SCREEN_WIDTH - 100)/2), SCREEN_WIDTH - 100, SCREEN_WIDTH - 100)];
    scanPreview.center = self.view.center;
    scanPreview.image = [UIImage imageNamed:@"scan_box"];
    scanPreview.contentMode = UIViewContentModeScaleAspectFit;
    scanPreview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scanPreview];
    
    // 扫描线
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(upView.frame), SCREEN_WIDTH - 100, 2)];
    imageLine.tag = line_tag;
    imageLine.image = [UIImage imageNamed:@"scan_line"];
    imageLine.contentMode = UIViewContentModeScaleAspectFill;
    imageLine.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageLine];
    
    // 提示信息
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMinY(downView.frame), SCREEN_WIDTH - 100, 50)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
    
    // 添加灯光设置
    _lightButton = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMinY(downView.frame) + 50, SCREEN_WIDTH - 100, 30)];
    _lightButton.tintColor = [UIColor whiteColor];
    _lightButton.tintAdjustmentMode = NSTextAlignmentCenter;
    [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    [self.view addSubview:_lightButton];
    
    // 添加按钮行为
    [_lightButton addTarget:self action:@selector(openSystemLight:) forControlEvents:UIControlEventTouchUpInside];
}

// 扫描动画
- (void)setupAnimation {
    UIView *imageLine = [self.view viewWithTag:line_tag];
    imageLine.hidden = NO;
    CABasicAnimation *animation = [UKScanQrcodeViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:SCREEN_WIDTH - 100 - 2] repeat:1000];
    [imageLine.layer addAnimation:animation forKey:@"LineAnimation"];
}

// 去除扫描动画
- (void)removeAnimation {
    UIView *imageLine = [self.view viewWithTag:line_tag];
    [imageLine.layer removeAnimationForKey:@"LineAnimation"];
    imageLine.hidden = YES;
}


+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY repeat:(int)repeat {
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount = repeat;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animationMove;
}

- (void)dismissOverlayView:(id)sender {
    [self selfRemoveFromSuperview];
}

- (void)selfRemoveFromSuperview {
    [_captureSession removeObserver:self forKeyPath:@"running" context:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

// 打开系统灯光
- (IBAction)openSystemLight:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"打开照明"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
    }
}

- (void)systemLightSwitch:(BOOL)open {
    if (open) {
        [_lightButton setTitle:@"关闭照明" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
