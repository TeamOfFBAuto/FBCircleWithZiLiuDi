//
//  GnearbyPersonCell.h
//  FBCircle
//
//  Created by gaomeng on 14-8-18.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//附近的人自定义cell
#import <UIKit/UIKit.h>

typedef void (^sendMessageBlock)();


@interface GnearbyPersonCell : UITableViewCell

@property(nonatomic,strong)UIImageView *userFaceImv;//用户头像
@property(nonatomic,strong)UILabel *userNameLabel;//用户姓名
@property(nonatomic,strong)NSString *userId;//用户id
@property(nonatomic,strong)UILabel *userDistanceAndTimeLabel;//距离和时间Label
@property(nonatomic,strong)UIButton *btn;//按钮
@property(nonatomic,copy)sendMessageBlock sendMessageBlock;//代码块block



//加载自定义cell
-(void)loadCustomViewWithIndexPath:(NSIndexPath*)theIndexPath;

//填充数据
-(void)configNetDataWithIndexPath:(NSIndexPath*)theIndexPath dataArray:(NSArray*)array distanceDic:(NSDictionary *)distanceDic;


//block set方法
-(void)setSendMessageBlock:(sendMessageBlock)sendMessageBlock;



@end
