//
//  GscanfViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-6-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GscanfViewController.h"

#import "FBCircleWebViewController.h"


#import "GpersonallSettingViewController.h"

@interface GscanfViewController ()

@end

@implementation GscanfViewController





- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 30, 60, 24)];
    titleLabel.text = @"扫一扫";
    titleLabel.textColor = RGBCOLOR(92, 137, 63);
    [self.view addSubview:titleLabel];
    

    
    
    
    //半透明的浮层
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+5.4, 320, 568-64-6)];
    backImageView.image = [UIImage imageNamed:@"saoyisao_bg_640_996.png"];
    [self.view addSubview:backImageView];
    
    
    
    
    
    
    
    
    
	
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    //labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
//    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 64+8, 320, 568-64-8)];
//    backview.backgroundColor = [UIColor blackColor];
//    backview.alpha = 0.15;
//    [self.view addSubview:backview];
    
    

    
    
    
    
    
    //四个角
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 6+89, 220, 220)];
    imageView.image = [UIImage imageNamed:@"saoyisao_440_440.png"];
    [self.view addSubview:imageView];
    
    
    //文字提示label
    
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+19, imageView.frame.size.width, 12)];
    tishiLabel.font = [UIFont systemFontOfSize:12];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.text = @"将二维码显示在扫描框内，即可自动扫描";
    [self.view addSubview:tishiLabel];
    
    
    
    
    
    //取消按钮
    
    if (iPhone5) {
        UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setBackgroundImage:[UIImage imageNamed:@"quxiao_up_440_78.png"] forState:UIControlStateNormal];
        [scanButton setBackgroundImage:[UIImage imageNamed:@"quxiao_down_440_78.png"] forState:UIControlStateHighlighted];
        [scanButton setTitle:@"取消" forState:UIControlStateNormal];
        scanButton.frame = CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+85, imageView.frame.size.width, 38);
        [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanButton];
    }else{
        UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setBackgroundImage:[UIImage imageNamed:@"quxiao_up_440_78.png"] forState:UIControlStateNormal];
        [scanButton setBackgroundImage:[UIImage imageNamed:@"quxiao_down_440_78.png"] forState:UIControlStateHighlighted];
        [scanButton setTitle:@"取消" forState:UIControlStateNormal];
        scanButton.frame = CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+60, imageView.frame.size.width, 38);
        [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanButton];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    upOrdown = NO;
    num =0;
    
    //上下滚动的条
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 158, 220, num)];
    _line.image = [UIImage imageNamed:@"11.png"];
    [self.view addSubview:_line];
    
    
//    _line = [[UIView alloc]initWithFrame:CGRectMake(20, 110, 280, 1)];
//    _line.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
//    [timer fire];
    
    
}
-(void)animation1
{
    
    
    //一个条
//    if (upOrdown == NO) {
//        num ++;
//        
//        _line.frame = CGRectMake(20, 110+2*num, 280, 70);
//        if (2*num == 280) {
//            
//            upOrdown = YES;
//        }
//        
//    }
//    else {
//        num --;
//        _line.frame = CGRectMake(20, 110+2*num, 280, 70);
//        if (num == 0) {
//            upOrdown = NO;
//        }
//    }
    
    
    
    
    //一个图
    if (upOrdown == NO) {
        num ++;
        
        _line.image = [UIImage imageNamed:@"33.png"];
        _line.frame = CGRectMake(50, 158, 220, num);
        _line.alpha = num/220.0f;
        if (num == 220) {
            upOrdown = YES;
            
            num = 0;
        }

    }
    else {
        num ++;
        
        _line.image = [UIImage imageNamed:@"33.png"];
        _line.frame = CGRectMake(50, 158, 220, num);
        if (num == 220) {
            upOrdown = NO;
            _line.alpha = num/220.0f;
            num = 0;
        }
    }
    
    
    
    
    
    
    
}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if (!TARGET_IPHONE_SIMULATOR) {
        [self setupCamera];
    }
    
}



- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(20,110,280,280);
    _preview.frame = CGRectMake(0, 0, 320, 568);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         NSLog(@"123");
         NSLog(@"%@",stringValue);
         
         [self.delegete pushWebViewWithStr:stringValue];
         
         
         
     }];
    
    
    
    
    
    
    
}


@end
