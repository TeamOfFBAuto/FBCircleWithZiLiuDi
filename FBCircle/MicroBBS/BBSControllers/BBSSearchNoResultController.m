//
//  BBSSearchNoResultController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSSearchNoResultController.h"
#import "CreateNewBBSViewController.h"

@interface BBSSearchNoResultController ()
{
    UIView *custom_view;
}

@end

@implementation BBSSearchNoResultController

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
    self.titleLabel.text = @"创建新论坛";
    
    UILabel *hello = [LTools createLabelFrame:CGRectMake(0, 334/2.f - (iPhone5 ? 0 : 88), self.view.width, 20) title:@"越野e族联盟,微论坛尚未创建" font:16 align:NSTextAlignmentCenter textColor:[UIColor colorWithHexString:@"69737f"]];
    [self.view addSubview:hello];
    
    UIButton *create_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake((self.view.width - 574/2.f)/2.f, hello.bottom + 35, 574/2.f, 83/2.f) normalTitle:nil image:nil backgroudImage:[UIImage imageNamed:@"chuangjian"] superView:nil target:self action:@selector(clickToCreateBBS:)];
    [[self view]addSubview:create_btn];
    
    custom_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 379/2.f, 225/2.f)];
    custom_view.backgroundColor = [UIColor blackColor];
    custom_view.layer.cornerRadius = 5.f;
    custom_view.alpha = 0.7f;
    custom_view.center = [[UIApplication sharedApplication].keyWindow center];
    [[UIApplication sharedApplication].keyWindow addSubview:custom_view];
    
    UILabel *title1 = [LTools createLabelFrame:CGRectMake(0, 35, custom_view.width, 20) title:@"该论坛还未建立," font:14 align:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
    [custom_view addSubview:title1];
    
    UILabel *title2 = [LTools createLabelFrame:CGRectMake(0, title1.bottom, custom_view.width, 20) title:@"去看看其他微论坛吧" font:14 align:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
    [custom_view addSubview:title2];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

- (void)hide
{
    [custom_view removeFromSuperview];
    custom_view = nil;
}

- (void)clickToCreateBBS:(UIButton *)sender
{
    CreateNewBBSViewController * createBBS = [[CreateNewBBSViewController alloc] init];
    [self.navigationController pushViewController:createBBS animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    custom_view = nil;
}

@end
