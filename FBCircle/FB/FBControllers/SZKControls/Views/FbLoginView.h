//
//  LoginView.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//


typedef void(^LoginViewBloc)(long flag);//传方法的，如果是101，就是登录按钮；如果是102,找回密码；103，新用户注册

#import <UIKit/UIKit.h>


@interface FbLoginView : UIView<UITextFieldDelegate>

@property(strong,nonatomic)UIImageView *imgLogo;//中间的大logo

@property(strong,nonatomic)UIImageView *leftimg;//中间的大logo
@property(strong,nonatomic)UIImageView *rightimg;//中间的大logo


@property(strong,nonatomic)UIImageView *centerKuangImgV;//中间的大logo

@property(strong,nonatomic)UIButton *phoneNumberButton;//切换到手机登录

@property(strong,nonatomic)UIButton *fblifeIDButton;//切换到e族ID登录


@property(strong,nonatomic)UITextField *userLabel;//用户名

@property(strong,nonatomic)UITextField  *passWordLabel;//密码

@property(strong,nonatomic)UIButton *loginButton;//中间的大logo

@property(strong,nonatomic)UIButton * forgetPassWordButton;//忘记密码的按钮,一期先不做

@property(strong,nonatomic)UIButton * regeistbutton;//新用户注册的按钮

@property(nonatomic,strong)UIView *zhuanquanview;//转圈的菊花加在这个上面

@property(nonatomic,strong)FBQuanAlertView *theFbquanalertV;//黑色背景的提醒




@property(copy,nonatomic)LoginViewBloc  bloc;

-(void)setBloc:(LoginViewBloc)chuanrubloc;



@end
