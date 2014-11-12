//
//  MineViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


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

#import <UIKit/UIKit.h>

@interface MineViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>{


    UITableView *mainTab;

}

@property(nonatomic,strong)NSArray *titleArr;

@property(nonatomic,strong)NSArray *iconArr;


@property(nonatomic,strong)FBCirclePersonalModel *personModel;//数据源

@property(nonatomic,strong)GavatarView *userFaceImageView;//头像图

@property(nonatomic,strong)UILabel *userNameLabel;//用户名

@property(nonatomic,strong)UILabel *userWordsLabel;//用户个性签名

@property(nonatomic,strong)UIButton *backClickedBtn;//顶部可点击btn

@property(nonatomic,strong)NSString *string_name;//用户名

@property(nonatomic,strong)NSString *string_photo;//touxiang

@property(nonatomic,strong)NSString *string_qianming;//touxiang






@end
