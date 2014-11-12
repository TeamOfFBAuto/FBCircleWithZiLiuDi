//
//  GmyMessageTableViewCell.h
//  FBCircle
//
//  Created by gaomeng on 14-5-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBQuanMessageModel.h"
#import "GTimeSwitch.h"
#import "UILabel+GautoMatchedText.h"
#import "RTLabel.h"

@interface GmyMessageTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *faceImageView;//头像

@property(nonatomic,strong)UILabel *nameLabel;//用户名

@property(nonatomic,strong)RTLabel *contentLabel;//内容

@property(nonatomic,strong)UILabel *timeLabel;//时间

@property(nonatomic,strong)UIView *yuanwenContentView;//原文内容


@property(nonatomic,strong)UIImageView *zhanView;//赞



//填充数据
-(CGFloat)dataForCellWithModel:(FBQuanMessageModel *)messageModel;

//清除数据
-(void)clearDataOfCell;


//加载控件
-(void)loadView;

@end
