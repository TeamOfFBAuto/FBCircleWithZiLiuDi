//
//  TopicCommentModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCommentModel : BaseModel
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *tid;//帖子id
@property(nonatomic,retain)NSString *uid;//成员uid
@property(nonatomic,retain)NSString *username;//论坛名字
@property(nonatomic,retain)NSString *content;//评论内容
@property(nonatomic,retain)NSString *time;//评论时间线
@property(nonatomic,retain)NSString *ip;//ip地址
@property(nonatomic,retain)NSString *userface;//头像

@end
