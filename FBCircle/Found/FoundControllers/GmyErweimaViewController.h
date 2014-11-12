//
//  GmyErweimaViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCirclePersonalModel.h"

@interface GmyErweimaViewController : MyViewController

@property(nonatomic,strong)UIImageView *erweimaImageV;//二维码

@property(nonatomic,strong)UIImageView *userFaceImv;//头像

@property(nonatomic,strong)UILabel *userNameLabel;//姓名

@property(nonatomic,strong)UILabel *userDiquLabel;//地区

@property(nonatomic,strong)FBCirclePersonalModel *personModel;//用户对象

@end
