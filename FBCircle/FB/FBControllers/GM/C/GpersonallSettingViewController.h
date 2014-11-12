//
//  GpersonallSettingViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//个人设置界面
#import <UIKit/UIKit.h>
#import "FBCirclePersonalModel.h"
#import "FriendListViewController.h"
#import "UMFeedbackViewController.h"
#import "SMSInvitationViewController.h"
#import "AboutFBQuanViewController.h"
#import "SzkAPI.h"
#import "GmyFootViewController.h"

#import <UIImageView+AFNetworking.h>

#import "GmyMessageViewController.h"
#import "MessageViewController.h"//我的消息

@class GpersonallSettingViewController;



@interface GpersonallSettingViewController : MyViewController

{
    UIImageView *readLineView;
    BOOL is_have;
    BOOL is_Anmotion;
}



@property(nonatomic,strong)FBCirclePersonalModel *personModel;//数据源

@property(nonatomic,strong)GavatarView *userFaceImageView;//头像图

@property(nonatomic,strong)UILabel *userNameLabel;//用户名

@property(nonatomic,strong)UILabel *userWordsLabel;//用户个性签名

@property(nonatomic,strong)UIButton *backClickedBtn;//顶部可点击btn





//我的好友 我的消息 小红点
@property(nonatomic,strong)NSDictionary *dic;//上个页面传过来的参数 用于判断是否有小红点

@property(nonatomic,strong)UIView *red1;//我的好友小红点
@property(nonatomic,strong)UIView *red2;//我的消息小红点


//扫完的回调
-(void)pushWebViewWithStr:(NSString *)stringValue;




@end
