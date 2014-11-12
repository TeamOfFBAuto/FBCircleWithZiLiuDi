//
//  FBCircleWebViewController.m
//  FBCircle
//
//  Created by soulnear on 14-6-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleWebViewController.h"

@interface FBCircleWebViewController ()

@end

@implementation FBCircleWebViewController
@synthesize myWebView = _myWebView;
@synthesize web_url = _web_url;
@synthesize web_content = _web_content;
@synthesize web_image = _web_image;
@synthesize web_title = _web_title;



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
    //张少南 这里需要一个转发图片
    self.rightImageName = @"pinglun-zhuanfa_up-24_24.png";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    self.my_right_button.userInteractionEnabled = NO;
    self.my_right_button.hidden = YES;
    
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)-64)];
    
    _myWebView.delegate = self;
    
    [self.view addSubview:_myWebView];
    
    
    NSURL * myUrl = [NSURL URLWithString:_web_url];
    
    [_myWebView loadRequest:[NSURLRequest requestWithURL:myUrl]];
    
}


#pragma mark - 点击右上角按钮进行分享


-(void)otherRightTypeButton:(UIButton *)sender
{
    ZSNAlertView * alertView = [[ZSNAlertView alloc] init];
    
    alertView.backgroundColor = RGBACOLOR(248,248,248,0.9);
    
    CGRect frame = alertView.userName_label.frame;
    
    frame.size.height = 40;
    
    alertView.userName_label.frame = frame;
    
    
    __weak typeof(self) bself = self;
    
    [alertView setInformationWithUrl:self.web_image WithUserName:self.web_title WithContent:@"" WithBlock:^(NSString *theString) {
        
        [bself initHttpShareToFBCircleWithContent:theString];
        
    }];
    
    [alertView show];
}


#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.web_title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.titleLabel.text = self.web_title;
    if (self.titleLabel.text.length>0) {
        self.my_right_button.hidden = NO;
    }else{
        self.my_right_button.hidden = YES;
    }
    
    NSString * content = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    NSString * regular_string = @"<img.+src=\"([^\"]+\\.jpg)\"";
    
    NSError* error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular_string options:NSRegularExpressionCaseInsensitive  error:&error];
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    
    if (firstMatch)
    {
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        //从urlString中截取数据
        NSString *result = [content substringWithRange:resultRange];
        
        result = [result stringByReplacingOccurrencesOfString:@"<img src=\"" withString:@""];
        
        NSRange range = [result rangeOfString:@".jpg\""];
        
        self.web_image = [result substringToIndex:range.location+4];
    }
    
    self.my_right_button.userInteractionEnabled = YES;
}



#pragma mark - 分享到FB圈

-(void)initHttpShareToFBCircleWithContent:(NSString *)theContent
{
    if (myAlertView)
    {
        [myAlertView removeFromSuperview];
        
        myAlertView = nil;
    }
    
    
    myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
    
    myAlertView.center = CGPointMake(160,(iPhone5?568:480)/2-50);
    
    [myAlertView setType:FBQuanAlertViewTypeHaveJuhua thetext:@"正在转发"];
    
    [self.view addSubview:myAlertView];
    
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_SHARE_URL,[theContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.web_title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.web_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.web_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.web_content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[SzkAPI getAuthkey]];
    
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];

    
    requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __weak AFHTTPRequestOperation * request = requestOperation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"转发成功"];
            
            [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1.0];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESSUPDATA object:nil userInfo:nil];
            
        }else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"转发失败" message:[allDic objectForKey:@"errinfo"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            
            [alertView show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"转发失败,请检查您当前网络" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        
        [alertView show];
    }];
    
    [requestOperation start];
}


-(void)dismissPromptView
{
    [myAlertView removeFromSuperview];
    
    myAlertView = nil;
}


-(void)dealloc
{
    [_myWebView stopLoading];
    
    _myWebView = nil;
    
    _web_content = nil;
    
    _web_image = nil;
    
    _web_title = nil;
    
    _web_url = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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

@end
