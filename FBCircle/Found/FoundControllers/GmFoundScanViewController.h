//
//  GmFoundScanViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//扫一扫界面
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class AddFriendViewController;
@class FoundViewController;

@interface GmFoundScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIImageView * line;

@property(nonatomic,assign)FoundViewController *delegate;
@property(nonatomic,assign)AddFriendViewController *delegate2;

@end
