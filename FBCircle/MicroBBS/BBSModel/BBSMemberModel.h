//
//  BBSMemberModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BaseModel.h"

@interface BBSMemberModel : BaseModel

@property(nonatomic,retain)NSString *id;//数据库记录序号
@property(nonatomic,retain)NSString *fid;//论坛版面id
@property(nonatomic,retain)NSString *uid;//成员uid
@property(nonatomic,retain)NSString *username;//用户名字
@property(nonatomic,retain)NSString *userface;//头像
@property(nonatomic,retain)NSString *status;//成员身份（1：创建者  2：普通成员）
@property(nonatomic,retain)NSString *isdel;//是否删除（0:有效   1:删除）
@property(nonatomic,retain)NSString *dateline;//创建时间

@end
