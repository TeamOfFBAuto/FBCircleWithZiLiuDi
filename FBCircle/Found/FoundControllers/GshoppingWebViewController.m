//
//  GshoppingWebViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-27.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GshoppingWebViewController.h"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS7DAOHANGLANBEIJING @"eva.png"
#define IOS6DAOHANGLANBEIJING @"ios7eva320_44.png"
@interface GshoppingWebViewController ()

@end

@implementation GshoppingWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.urlstring = @"http://m.fblife.com/mall/";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
//    [self.navigationController.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
    
    
//    
//    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -3:5, 0, 12, 43/2)];
//    [button_back addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
//    [button_back setBackgroundImage:[UIImage imageNamed:@"ios7_back.png"] forState:UIControlStateNormal];
//    
//    UIButton *leftview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 43/2)];
//    [leftview addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
//    [leftview addSubview:button_back];
//    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:leftview];
//    self.navigationItem.leftBarButtonItem=back_item;
    
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//        
//        
//        [self.navigationController.navigationBar setBackgroundImage:IOS_VERSION>=7?[UIImage imageNamed:IOS7DAOHANGLANBEIJING]: [UIImage imageNamed:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
//    }
    
    

    
    NSURL *url =[NSURL URLWithString:self.urlstring];
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    awebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-64-40:480-64-40)];
    awebview.delegate=self;
    [awebview loadRequest:request];
    awebview.scalesPageToFit = YES;
    [self.view addSubview:awebview];;
    
    UIView *toolview=[[UIView alloc]initWithFrame:CGRectMake(0, iPhone5?568-40-64:480-64-40, 320, 40)];
    toolview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios7_webviewbar.png"]];
    [self.view addSubview:toolview];
    
    
    NSArray *array_imgname=[NSArray arrayWithObjects:@"ios7_goback4032.png",@"ios7_goahead4032.png",@"ios7_refresh4139.png", nil];
    for (int i=0; i<3; i++) {
        UIImage *img=[UIImage imageNamed:[array_imgname objectAtIndex:i]];
        
        UIButton *tool_Button=[[UIButton alloc]initWithFrame:CGRectMake(5+i*70, 5, img.size.width, img.size.height)];
        tool_Button.center=CGPointMake(22+i*i*68.5, 20);
        
        tool_Button.tag=99+i;
        [tool_Button setBackgroundImage:[UIImage imageNamed:[array_imgname objectAtIndex:i]] forState:UIControlStateNormal];
        
        [tool_Button addTarget:self action:@selector(dobuttontool:) forControlEvents:UIControlEventTouchUpInside];
        [toolview addSubview:tool_Button];
        
    }
    
    
}


-(void)dobuttontool:(UIButton *)sender{
    switch (sender.tag) {
        case 99:
            [awebview goBack];
            break;
        case 100:
            [awebview goForward];
            break;
        case 101:
            [awebview reload];
            break;
            
            
        default:
            break;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    string_title=[NSString stringWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
//    
//    self.navigationItem.title = string_title;
//    
//    
//    UIColor * cc = [UIColor blackColor];
//    
//    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:18],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextShadowColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
//    
//    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.titleLabel.text=string_title;
    
    button_comment.userInteractionEnabled=YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

-(void)backto{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
