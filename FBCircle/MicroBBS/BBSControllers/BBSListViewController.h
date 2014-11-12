//
//  BBSListViewController.h
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyViewController.h"
@class BBSInfoModel;
/**
 *  论坛帖子列表
 */
@interface BBSListViewController : MyViewController

@property(nonatomic,retain)NSString *navigationTitle;
@property(nonatomic,retain)NSString *bbsId;


@end
