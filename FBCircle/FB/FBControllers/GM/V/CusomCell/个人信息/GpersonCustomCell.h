//
//  GpersonCustomCell.h
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//



//个人信息界面自定义cell

#import <UIKit/UIKit.h>
#import "FBCirclePersonalModel.h"
#import "GavatarView.h"
#import "FBCircleModel.h"


typedef enum{
    GRXX1 = 0,//自己
    GRXX2 ,//好友 接口返回0
    GRXX3 ,//非好友 接口返回3
    GRXX4 ,//非好友 正在添加中 接口返回1
    GRXX5 ,//接到邀请  接口返回2
}GRXX;


typedef void (^JiahaoyouClickedBlock)();//加好友block
typedef void (^faxiaoxiClickedBlock)();//发消息block
typedef void (^tuichudengluClickedBlock)();//退出登录
typedef void (^yaoqingClickedBlock)();//收到好友请求

@interface GpersonCustomCell : UITableViewCell



@property(nonatomic,strong)GavatarView *touxiangImaView;//头像
@property(nonatomic,assign)BOOL ischooseArea;//是否更换地区
@property(nonatomic,assign)BOOL ischooseTouxiang;//是否更换了头像
@property(nonatomic,strong)NSString *diqu;
@property(nonatomic,strong)UIImage *userUpImege;//用户上传的头像

@property(nonatomic,strong)UIButton *jiahaoyouBtn;//加好友btn
@property(nonatomic,strong)UIButton *faxiaoxiBtn;//发消息btn
@property(nonatomic,strong)UIButton *tuichudengluBtn;//退出登录btn
@property(nonatomic,strong)UIButton *yaoqingBtn;//收到邀请btn

@property(nonatomic,assign)BOOL ischangeUserQm;//是否更改了签名
@property(nonatomic,strong)NSString *changeQM;//修改后的签名

@property(nonatomic,assign)int imaCount;//足迹图片数量




//加好友btn block
@property(nonatomic,copy)JiahaoyouClickedBlock JiahaoyouClickedBlock;
-(void)setJiahaoyouClickedBlock:(JiahaoyouClickedBlock)JiahaoyouClickedBlock;

//发消息btn block
@property(nonatomic,copy)faxiaoxiClickedBlock faxiaoxiClickedBlock;
-(void)setfaxiaoxiClickedBlock:(faxiaoxiClickedBlock)faxiaoxiClickedBlock;


//退出登录btn block
@property(nonatomic,copy)tuichudengluClickedBlock tuichudengluClickedBlock;
-(void)setTuichudengluClickedBlock:(tuichudengluClickedBlock)tuichudengluClickedBlock;

//收到好友请求
@property(nonatomic,copy)yaoqingClickedBlock yaoqingClickedBlock;
-(void)setYaoqingClickedBlock:(yaoqingClickedBlock)yaoqingClickedBlock;



//根据GRXX类型 indexPath
-(void)loadCustomViewWithIndexPath:(NSIndexPath *)theIndexPath model:(FBCirclePersonalModel*)theModel GRXX:(GRXX)theGRXXtype wenzhangArray:(NSMutableArray*)wenzhangArray;

@end
