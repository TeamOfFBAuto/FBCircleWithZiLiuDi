//
//  TopicModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BaseModel.h"

/**
 *  帖子
 */
@interface TopicModel : BaseModel

@property(nonatomic,retain)NSString *id;//
@property(nonatomic,retain)NSString *tid;//帖子id
@property(nonatomic,retain)NSString *fid;//版面id
@property(nonatomic,retain)NSString *title;//帖子标题
@property(nonatomic,retain)NSString *sub_content;//主帖内容概述
@property(nonatomic,retain)NSString *uid;//作者id
@property(nonatomic,retain)NSString *username;//作者用户名
@property(nonatomic,retain)NSString *address;//发帖时地址
@property(nonatomic,retain)NSString *comment_num;//
@property(nonatomic,retain)NSString *time;//
@property(nonatomic,retain)NSString *ip;//
@property(nonatomic,retain)NSString *status;//论坛状态（0:正常   1:删除    2:审核中）或者 0：正常；1：精华；9：置顶；
@property(nonatomic,retain)NSString *isdel;//
@property(nonatomic,retain)NSString *imgid;//图片id

@property(nonatomic,retain)NSString *authorhead;//用户头像

@property(nonatomic,retain)NSString *zan_num;//赞个数

//热门推荐
@property(nonatomic,retain)NSString *content;//内容
@property(nonatomic,retain)NSArray *img;//图片数组
//我加入回帖最多
@property(nonatomic,retain)NSString *forumpic;//主帖图片


@end
