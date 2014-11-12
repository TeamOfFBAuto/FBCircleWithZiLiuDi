//
//  FBCircleWebViewController.h
//  FBCircle
//
//  Created by soulnear on 14-6-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MyViewController.h"
#import "ZSNAlertView.h"
#import "FBQuanAlertView.h"


@interface FBCircleWebViewController : MyViewController<UIWebViewDelegate>
{
    AFHTTPRequestOperation * requestOperation;
    
    FBQuanAlertView * myAlertView;
}


@property(nonatomic,strong)UIWebView * myWebView;

@property(nonatomic,strong)NSString * web_url;



//保存读取到的链接信息

@property(nonatomic,strong)NSString * web_title;

@property(nonatomic,strong)NSString * web_image;

@property(nonatomic,strong)NSString * web_content;



@end
