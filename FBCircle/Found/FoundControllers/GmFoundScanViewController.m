//
//  GmFoundScanViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GmFoundScanViewController.h"

#import "FoundViewController.h"
#import "GpersonInfoViewController.h"

#import "AddFriendViewController.h"


#define ScanKuangFrame CGRectMake(50, 70+89-6, 220, 220)


@interface GmFoundScanViewController ()

@end

@implementation GmFoundScanViewController


- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //上面的view
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    //返回view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 74, 64)];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ttt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tttback)];
    [backView addGestureRecognizer:ttt];
    [topView addSubview:backView];
    //返回箭头
    UIImageView *backImv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12+20, 12, 20)];
    [backImv setImage:[UIImage imageNamed:@"fanhui-daohanglan-20_38.png"]];
    backImv.userInteractionEnabled = YES;
    [backView addSubview:backImv];
    //返回文字
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backImv.frame)+8, backImv.frame.origin.y, 34, 20)];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.userInteractionEnabled = YES;
    backLabel.text = @"发现";
    [backView addSubview:backLabel];
    
    //title
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backLabel.frame)+65, backLabel.frame.origin.y+2, 52, 18)];
    
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = @"二维码";
    titleLable.font = [UIFont boldSystemFontOfSize:17];
    [topView addSubview:titleLable];
    
    
    
    //半透明的浮层
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+5.4-6, 320, 568-64-6)];
    backImageView.image = [UIImage imageNamed:@"saoyisao_bg_640_996.png"];
    [self.view addSubview:backImageView];
    
    
    //四个角
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:ScanKuangFrame];
    imageView.image = [UIImage imageNamed:@"fkuang.png"];
    [self.view addSubview:imageView];
    
    
    //文字提示label
    
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+28, imageView.frame.size.width, 12)];
    tishiLabel.font = [UIFont systemFontOfSize:12];
    tishiLabel.textColor = [UIColor whiteColor];
    tishiLabel.backgroundColor = [UIColor clearColor];
    tishiLabel.text = @"将二维码显示在扫描框内，即可自动扫描";
    [self.view addSubview:tishiLabel];
    
    
    //我的二维码
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(124, CGRectGetMaxY(tishiLabel.frame)+37, 70, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(87, 151, 226) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(myErweima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    upOrdown = NO;
    num =0;
    
    //上下滚动的条
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(40, 70+89-18-6, 240, 18)];
    [_line setImage:[UIImage imageNamed:@"fshan.png"]];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    
    [timer fire];
    
    
}
-(void)animation1
{
    //一个条
    if (upOrdown == NO) {
        num ++;
        
        _line.frame = CGRectMake(40, 70+89-9-6+2*num, 240, 18);
        if (2*num == 220) {
            
            upOrdown = YES;
        }
        
    }
    else {
        num --;
        _line.frame = CGRectMake(40, 70+89-9-6+2*num, 240, 18);
        if (num == 0) {
            upOrdown = NO;
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
         
         
         
         if([stringValue hasPrefix:@"UID"]){//加好友
             NSString *str = [stringValue substringFromIndex:4];
             NSArray *arr = [str componentsSeparatedByString:@"\n"];
             NSString *userId = arr[0];
             
             NSLog(@"%@",userId);
             if ([userId isEqualToString:[SzkAPI getUid]]) {//扫出的二维码是自己
                 if (self.delegate) {//发现vc
                     [self.delegate pushToGrxx4];
                 }else if (self.delegate2){//我vc扫一扫加好友
                     [self.delegate2 pushToGrxx4];
                 }
             }else{//不是自己的二维码
                 if (self.delegate) {//发现vc
                     [self.delegate pushToPersonInfoVcWithStr:userId];
                 }else if (self.delegate2){//我vc扫一扫加好友
                     [self.delegate2 pushToPersonInfoVcWithStr:userId];
                 }
             }
             
         }else{//webView
             if (self.delegate) {//发现vc
                 [self.delegate pushWebViewWithStr:stringValue];
             }else if (self.delegate2){//我vc扫一扫加好友
                 [self.delegate2 pushWebViewWithStr:stringValue];
             }
         }

     }];
    
    
}


//少男二维码
//-(void)findString:(NSString *)stringreplace
//{
//    string_uid=[personal getuidwithstring:stringreplace];
//    
//    
//    if ([string_uid isEqualToString:@"0"] || string_uid.length == 0 || [string_uid isEqual:[NSNull null]])
//    {
//        if ([stringreplace rangeOfString:@"http://"].length && [stringreplace rangeOfString:@"."].length)
//        {
//            
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否打开此链接" message:stringreplace delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//            alert.delegate = self;
//            
//            alert.tag = 100000;
//            
//            [alert show];
//            
//        }else
//        {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未识别的二维码" message:stringreplace delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil,nil];
//            [alert show];
//        }
//    }else
//    {
//        NSLog(@"_____stringuid===%@_____",string_uid);
//        [self pushtonewmine];
//        
//    }
//}





#pragma mark - 点击我的二维码跳转
-(void)myErweima{
    NSLog(@"%s",__FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        if (self.delegate) {
            [self.delegate pushMyerweimaVc];
        }else if (self.delegate2){
            [self.delegate2 pushMyerweimaVc];
        }
        
        
    }];
    
    
}


//点击返回按钮的跳转
-(void)tttback{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
