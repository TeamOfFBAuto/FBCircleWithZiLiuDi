//
//  GpersonInfoViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

//附近的人个人信息
//用户详细资料
#import <UIKit/UIKit.h>
#import "FBCirclePersonalModel.h"

#import "FBCircleModel.h"


@interface GpersonInfoViewController : MyViewController<MBProgressHUDDelegate>

@property(nonatomic,strong)NSString *passUserid;//上个界面传过来的userid 用于判断是否为好友
@property(nonatomic,strong)NSString *userName;//用户名 用于添加好友
@property(nonatomic,assign)BOOL isFriend;//是否为好友


@property(nonatomic,strong)UIImageView *userFaceImv;//用户头像
@property(nonatomic,strong)UILabel *userAreaLabel;//地区
@property(nonatomic,strong)UILabel *gexingqianmingLabel;//个性签名
@property(nonatomic,strong)NSArray *xiangceImageArray;//展示相册图片数组



@property(nonatomic,strong)FBCirclePersonalModel *personModel;//展示信息数据源


@property(nonatomic,strong)NSMutableArray *wenzhangArray;//用于展示足迹的三张图片数组

@property(nonatomic,assign)int imaCount;//展示图片数量


@property(nonatomic,assign)int cellType;//自己 别人 好友


@end
