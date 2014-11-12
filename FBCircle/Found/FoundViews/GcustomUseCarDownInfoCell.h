//
//  GcustomUseCarDownInfoCell.h
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

//用车服务界面 下面弹出框内的tableview 自定义cell
#import <UIKit/UIKit.h>

@interface GcustomUseCarDownInfoCell : UITableViewCell



@property(nonatomic,strong)UIImageView *titielImav;//图标
@property(nonatomic,strong)UILabel *contentLabel;//内容label

//加载视图
-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;


//填充数据
-(CGFloat)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath;


@end
