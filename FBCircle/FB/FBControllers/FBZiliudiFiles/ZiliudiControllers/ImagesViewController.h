//
//  ImagesViewController.h
//  FbLife
//
//  Created by soulnear on 13-3-25.
//  Copyright (c) 2013年 szk. All rights reserved.
//
/*
 查看图集详情
 */

#import <UIKit/UIKit.h>
#import "ImagesCell.h"

@interface ImagesViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,ImageCellDelegate>
{
    UILabel * title_label;
}


@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * photos;
@property(nonatomic,strong)NSString * tid;


@end
