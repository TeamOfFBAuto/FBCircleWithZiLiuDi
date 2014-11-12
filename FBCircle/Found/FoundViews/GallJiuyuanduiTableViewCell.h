//
//  GallJiuyuanduiTableViewCell.h
//  FBCircle
//
//  Created by gaomeng on 14-8-27.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GallJiuyuanduiTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *faceImv;//图标
@property(nonatomic,strong)UILabel *nameLabel;//内容labal
@property(nonatomic,strong)UILabel *distanceLabel;//距离



//加载控件
-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;

//填充数据
-(void)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath;

@end
