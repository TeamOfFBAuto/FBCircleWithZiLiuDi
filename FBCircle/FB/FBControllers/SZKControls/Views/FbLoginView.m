//
//  LoginView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//101，代表登录；103注册；201，phonenumber登录;202,id登录

#import "FbLoginView.h"

@implementation FbLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //self.backgroundColor=[UIColor colorWithPatternImage:iPhone5?[UIImage imageNamed:@"denglu-bg640_1136.png"]:[UIImage imageNamed:@"denglu-bg640_960.png"]];
        self.backgroundColor=[UIColor whiteColor];
    
        _imgLogo=[[UIImageView alloc]initWithFrame:CGRectMake(242/2,iPhone5? (175/2):40, 72, 65)];
        _imgLogo.image=[UIImage imageNamed:@"denglu_logo144_130.png"];
        _imgLogo.center = CGPointMake(DEVICE_WIDTH/2.f, _imgLogo.center.y);
        
        [self addSubview:_imgLogo];
        
        
        _centerKuangImgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shurukuang_shouji528_268.png"]];
        [self addSubview:_centerKuangImgV];
        _centerKuangImgV.userInteractionEnabled=YES;
        
        _centerKuangImgV.frame=CGRectMake(28,iPhone5? 300:242, _centerKuangImgV.image.size.width, _centerKuangImgV.image.size.height);

        _centerKuangImgV.center=CGPointMake(DEVICE_WIDTH/2.f,iPhone5? 410:255);

        
        //用手机号登录
        
        _phoneNumberButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 528/4, 45)];
        [_phoneNumberButton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        _phoneNumberButton.tag=201;
        _phoneNumberButton.backgroundColor=[UIColor clearColor];
        
        [_centerKuangImgV addSubview:_phoneNumberButton];
        
        
        //用e族id登录
        
        _fblifeIDButton=[[UIButton alloc]initWithFrame:CGRectMake(528/4, 0, 528/4, 45)];
        [_fblifeIDButton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        _fblifeIDButton.tag=202;
        _fblifeIDButton.backgroundColor=[UIColor clearColor];
        [_centerKuangImgV addSubview:_fblifeIDButton];
        
        
        _passWordLabel=[[UITextField alloc]init];
        _passWordLabel.secureTextEntry=YES;
        _passWordLabel.placeholder=@"请输入密码";
        _passWordLabel.textColor=[UIColor whiteColor];
        _passWordLabel.backgroundColor=[UIColor clearColor];
        _passWordLabel.delegate=self;
        _passWordLabel.textColor=RGBACOLOR(58, 58, 58, 1);

        [_centerKuangImgV addSubview:_passWordLabel];
        
        _userLabel=[[UITextField alloc]init];
        _userLabel.backgroundColor=[UIColor clearColor];
        _userLabel.textColor=[UIColor whiteColor];
        _userLabel.placeholder=@"请输入手机号码";
        _userLabel.keyboardType=UIKeyboardTypeNumberPad;
        [_centerKuangImgV addSubview:_userLabel];
        _userLabel.delegate=self;
        _userLabel.textColor=RGBACOLOR(58, 58, 58, 1);
        _userLabel.returnKeyType=UIReturnKeyDone;
        
        _loginButton=[[UIButton alloc]init];
        _loginButton.tag=101;
        
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"Loginbutton528_88.png"] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"Loginbutton_downs528_88.png"] forState:UIControlStateHighlighted];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"Loginbutton_downs528_88.png"] forState:UIControlStateSelected];

        
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
        
        
        //        _forgetPassWordButton=[[UIButton alloc]init];
        //        _forgetPassWordButton.tag=102;
        //        [self addSubview:_forgetPassWordButton];
        
        
        _regeistbutton=[[UIButton alloc]init];
        [self addSubview:_regeistbutton];
        _regeistbutton.tag=103;
        
       // [_regeistbutton setBackgroundImage:[UIImage imageNamed:@"FBQuanRegist640_87.png"] forState:UIControlStateNormal];
        
        [_regeistbutton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_regeistbutton setTitleColor:RGBCOLOR(92, 137, 63) forState:UIControlStateNormal];
        
        [_regeistbutton setTitle:@"新用户注册" forState:UIControlStateNormal];
        
        [_regeistbutton setTitleEdgeInsets:UIEdgeInsetsMake(0,DEVICE_WIDTH - 320 + 120,0,0)];//上左下右
        
        //右边的向右的小箭头
        
        UIImageView *imgrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"denglu_jiantou16_30.png"]];
        imgrow.center=CGPointMake(DEVICE_WIDTH - 40, 22);
        [_regeistbutton addSubview:imgrow];
        
        //
//        _theFbquanalertV=[[FBQuanAlertView alloc]initWithFrame:CGRectMake(0, 0, 140, 100)];
//        _theFbquanalertV.center=CGPointMake(160, iPhone5?568/2:240);
//        [_theFbquanalertV setType:FBQuanAlertViewTypeHaveJuhua thetext:@"正在登录"];
//        _theFbquanalertV.hidden=YES;
//        [self addSubview:_theFbquanalertV];
        _zhuanquanview=[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_zhuanquanview];
        _zhuanquanview.hidden=YES;
        
        UIActivityIndicatorView *_juhuazhuan=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_juhuazhuan startAnimating];
        _juhuazhuan.center = CGPointMake(DEVICE_WIDTH/2.f,iPhone5? 190.0f: 130.0f);//只能设置中心，不能设置大小
        _juhuazhuan.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入

        [_zhuanquanview addSubview:_juhuazhuan];
        //测试
    }
    return self;
}

-(void)layoutSubviews{
    
    _userLabel.frame=CGRectMake(20,45, 200, 45);
    
    _passWordLabel.frame=CGRectMake(20, 90, 200, 45);
    
    _loginButton.frame=CGRectMake((DEVICE_WIDTH - 528/2)/2, _centerKuangImgV.frame.origin.y+_centerKuangImgV.frame.size.height, 528/2, 44);
    
    _regeistbutton.frame=CGRectMake(0,DEVICE_HEIGHT - 44, DEVICE_WIDTH, 44);
    
}


-(void)setBloc:(LoginViewBloc)chuanrubloc{
    
    _bloc=chuanrubloc;
}


-(void)dobutton:(UIButton *)sender{
    
    switch (sender.tag) {
        case 101:
        {
            _bloc(sender.tag);
            
          //  _zhuanquanview.hidden=NO;
            
           // [self startAnimation:self.rightimg];
            
            [self setnormal];
            
        
        }
            break;
        case 103:
        {
            _bloc(sender.tag);
            
            [self setnormal];
            
            
        }
            break;
        case 201:
        {
            _userLabel.placeholder=@"请输入手机号码";
            _userLabel.text=@"";
            _passWordLabel.text=@"";
            _userLabel.keyboardType=UIKeyboardTypeNumberPad;
            [_userLabel resignFirstResponder];
            [_userLabel becomeFirstResponder];
            _centerKuangImgV.image=[UIImage imageNamed:@"shurukuang_shouji528_268.png"];
            _bloc(sender.tag);

            
        }
            break;
        case 202:
            
            
        {
            _userLabel.placeholder=@"请输入用户名";
            _userLabel.text=@"";
            _passWordLabel.text=@"";
            _userLabel.keyboardType=UIKeyboardTypeDefault;
            [_userLabel resignFirstResponder];
            [_userLabel becomeFirstResponder];
            _centerKuangImgV.image=[UIImage imageNamed:@"shurukuang_yonghumingi528_268.png"];
            _bloc(sender.tag);

 
        }
            break;
            
        default:
            break;
    }
    

    
    
}

#pragma mark-textfield代理

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [_userLabel resignFirstResponder];
    [_passWordLabel resignFirstResponder];
    [self setnormal];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self setnormal];
    
    
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self sethigh];
    
}

-(void)sethigh{
    [UIView animateWithDuration:0.4 animations:^{
//        //动画内容
//        if (iPhone5) {
//            
//            _imgLogo.frame=   CGRectMake(242/2,-40+175/2, 72, 65);
//            _centerKuangImgV.center=CGPointMake(160, -100+320);
//            _loginButton.frame=CGRectMake((320-528/2)/2-1, _centerKuangImgV.frame.origin.y+_centerKuangImgV.frame.size.height, 528/2, 44);
//            
//        }else{
//        
//            _imgLogo.frame=CGRectMake(140,30, 144/4, 130/4);
//            _centerKuangImgV.center=CGPointMake(160, -168+320);
//            _loginButton.frame=CGRectMake((320-528/2)/2-1, _centerKuangImgV.frame.origin.y+_centerKuangImgV.frame.size.height, 528/2, 44);
//            
//        }
        
    }completion:^(BOOL finished)
     
     {
         
     }];
    
}

-(void)setnormal{
    
    [UIView animateWithDuration:0.4 animations:^{
//        if (iPhone5) {
//            _imgLogo.frame=CGRectMake(242/2, 175/2, 72, 65);
//            _centerKuangImgV.frame=CGRectMake(28, 300, _centerKuangImgV.image.size.width, _centerKuangImgV.image.size.height);
//            _loginButton.frame=CGRectMake((320-528/2)/2-1, _centerKuangImgV.frame.origin.y+_centerKuangImgV.frame.size.height, 528/2, 44);
//
//            
//        }else{
//            _imgLogo.frame=CGRectMake(242/2, 40, 72, 65);
//            _centerKuangImgV.frame=CGRectMake(28, 242, _centerKuangImgV.image.size.width, _centerKuangImgV.image.size.height);
//            _loginButton.frame=CGRectMake((320-528/2)/2-1, _centerKuangImgV.frame.origin.y+_centerKuangImgV.frame.size.height, 528/2, 44);
//            
//        
//        }
        [_userLabel resignFirstResponder];
        [_passWordLabel resignFirstResponder];
        
        //动画内容
        
    }completion:^(BOOL finished)
     
     {
         
         
     }];
    
    
    
    
}

#pragma mark-转圈动画

-(void)startAnimation:(UIImageView *)theImageV{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    [theImageV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
