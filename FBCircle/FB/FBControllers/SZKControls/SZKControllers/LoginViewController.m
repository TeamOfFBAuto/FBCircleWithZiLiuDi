//
//  LoginViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LoginViewController.h"
#import "FbLoginView.h"
#import "RegistViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden=YES;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isPhoneNumber=YES;//默认是手机登录
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDismiss) name:@"successRegist" object:nil];
    
    FbLoginView *loginV=[[FbLoginView alloc]initWithFrame:CGRectMake(0, 0,320 , iPhone5?568:480)];
    
    [self.view addSubview:loginV];
    
    __weak  typeof(self) _weakself=self;
    __weak  typeof(loginV) _weakloginV=loginV;
    
    [loginV setBloc:^(long flag) {
        
        switch (flag) {
            case 101:
            {
                
                [_weakself loginwithUserName:_weakloginV.userLabel.text passWord:_weakloginV.passWordLabel.text deviceToken:[SzkAPI getDeviceToken] theview:_weakloginV];
            }
                break;
            case 102:
            {
                [_weakself turnToChangWordVC];
            }
                break;
            case 103:
            {
                [_weakself turnToNewregeistVC];
                
                
                
            }
                break;
            case 201:
            {
                //切换成手机登录
                
                isPhoneNumber=YES;
                
            }
                break;
            case 202:
            {
                //切换成e族账号登录登录
                isPhoneNumber=NO;
            }
                break;
            default:
                break;
        }
        
        
    }];
    
	// Do any additional setup after loading the view.
}

#pragma mark-注册成功，让自己dismiss
-(void)loginDismiss{
    [self dismissViewControllerAnimated:NO completion:NULL];
    //注册成功，主页刷新数据
    [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESSLOGIN object:nil];

}

#pragma mark---登录
-(void)loginwithUserName:(NSString*)stringUname passWord:(NSString *)passWord deviceToken:(NSString *)_deviceToken theview:(FbLoginView *)_loginV{
//    stringUname=@"ivyandrich";
//    passWord=@"yangjinli";
    
    if (stringUname.length==0||passWord.length==0) {
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:nil message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"请重新输入" otherButtonTitles:nil, nil];
        [alv show];
        return;
    }
    
    _loginV.zhuanquanview.hidden=NO;

    SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
    __weak typeof(self)_weakself=self;

    
    
    NSLog(@"登录的接口===%@",[NSString stringWithFormat:LOGINAPI,[stringUname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[passWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[SzkAPI getDeviceToken],isPhoneNumber?1:2] );
    
    [_loadRegist SeturlStr:[NSString stringWithFormat:LOGINAPI,[stringUname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[passWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[SzkAPI getDeviceToken],isPhoneNumber?1:2] block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
    
        _loginV.zhuanquanview.hidden=YES;

        if (errcode==0) {
            NSDictionary *dic=(NSDictionary *)arrayinfo;
            NSString *authkey=[dic objectForKey:@"authkey"];
            NSString *uid=[dic objectForKey:@"uid"];
            NSString * authkey_gbk = [dic objectForKey:@"authkey_gbk"];
            
            NSLog(@"skjaflk===%@",dic);
            NSString *strcomeName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
            
            NSLog(@"strCOMname===%@",strcomeName);
            
            
            NSUserDefaults *standUDef=[NSUserDefaults standardUserDefaults];
            [standUDef setObject:authkey forKey:AUTHERKEY];
            [standUDef setObject:uid forKey:USERID];
            [standUDef setObject:authkey_gbk forKey:AUTHERKEY_GBK];
           [standUDef setObject:strcomeName forKey:USERNAME];
            
            [standUDef synchronize];
            
            if ([[dic objectForKey:@"isnew"] integerValue]==1) {
                //新用户，要匹配通讯录,和注册成功的逻辑是一样的

                [[NSNotificationCenter defaultCenter]postNotificationName:@"successRegist" object:nil];
                
            }
            //登录成功后，要刷新数据
            [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESSLOGIN object:nil];

            
           [_weakself testttt];
        }else{
        
            UIAlertView *alerV=[[UIAlertView alloc]initWithTitle:nil message:errorindo delegate:nil cancelButtonTitle:@"请重新输入" otherButtonTitles:nil, nil];
            [alerV show];
        
        }
        
        
    }];
    
    
}

#pragma mark--登录成功，退下吧
//功能暂时不做

-(void)testttt{
//    NSString *striing_auth=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:AUTHERKEY]];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"tishi" message:striing_auth delegate:nil cancelButtonTitle:@"test" otherButtonTitles:nil, nil];
//    [alert show];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)turnToChangWordVC{
    
}

#pragma mark---新用户注册

-(void)turnToNewregeistVC{
    
    
    RegistViewController *_registVC=[[RegistViewController alloc]init];
    
    
    [self.navigationController pushViewController:_registVC animated:YES];
    
    
    
    NSLog(@"新用户注册");
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
