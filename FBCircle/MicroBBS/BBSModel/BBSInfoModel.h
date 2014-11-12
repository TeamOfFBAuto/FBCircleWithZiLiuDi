//
//  BBSInfoModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BaseModel.h"
/**
 *  论坛基本信息
 */
@interface BBSInfoModel : BaseModel

@property(nonatomic,retain)NSString *id;//论坛分类id
@property(nonatomic,retain)NSString *uid;//创建人
@property(nonatomic,retain)NSString *username;//创建人名
@property(nonatomic,retain)NSString *name;//论坛名字
@property(nonatomic,retain)NSString *headpic;//图标
@property(nonatomic,retain)NSString *intro;//简介
@property(nonatomic,retain)NSString *forumclass;//论坛分类id
@property(nonatomic,retain)NSString *newthread_num;//新帖子数
@property(nonatomic,retain)NSString *newthread_date;//新帖日期
@property(nonatomic,retain)NSString *thread_num;//论坛帖子数
@property(nonatomic,retain)NSString *member_num;//论坛成员数
@property(nonatomic,retain)NSString *status;//论坛状态（0:正常   1:删除    2:审核中）
@property(nonatomic,retain)NSString *uptime;//更新时间
@property(nonatomic,retain)NSString *dateline;//创建时间

@property(nonatomic,assign)int inForum;//是否在此论坛中 (决定用户权限) 0-不在，1-创建者，2-普通用户

@property(nonatomic,assign)int inforum;//是否在此论坛中(论坛信息页)

@property(nonatomic,retain)NSString *fid;


//"tid": "3",
//"fid": "1",
//"title": "ttttt",
//"content": "323232323233232",
//"imgid": "3,4",
//"uid": "967897",
//"username": "soulnear",
//"address": "ewewewewwe",
//"comment_num": "1",
//"zan_num": "0",
//"time": "1407926715",
//"ip": "101.226.89.119",
//"status": "0",
//"isdel": "0"

/*
 errcode:>0 时返回错误结果
 errinfo:errcode>0 时返回错误描述
 datainfo:
 total:总页数
 data:{id:论坛id    uid:创建者用户id    username:创建者用户名    name:论坛名称
 intro:论坛简介    headpic:论坛头像    forumclass:论坛分类id    newthread_num:今日新帖数量
 newthread_date:今日新帖时间标志    thread_num:论坛帖子数    member_num:论坛成员数
 status:论坛状态（0:正常   1:删除    2:审核中）
 uptime:更新时间    dateline:创建时间    inForm:是否在此论坛中
 }
 */

@end
