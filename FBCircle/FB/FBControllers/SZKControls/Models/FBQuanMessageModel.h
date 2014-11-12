//
//  MessageModel.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCircleModel.h"

@interface FBQuanMessageModel : NSObject

/**
 *  id: "4",
 fromuid: "362516",
 fromuname: "myown",
 fromtid: "12",
 touid: "355696",
 totid: "1",
 optype: "1",
 status: "0",
 dateline: "1400818386",
 fromuface: "http://bbs.fblife.com/ucenter/avatar.php?uid=362516&type=virtual&size=small",
 recontent: "sdfsfsfsfsfss",
 maincontent: "sdfsfsfdfs"
 },
 datainfo ：id:消息id   fromuid:评论人的id     fromuname:评论人的用户名    fromtid:被评价或者转发的文章id
 touid:被评论人的uid    totid:被评论的文章id    optype:(1评论2转发)     status:(0正常1删除)
 dateline:时间       fromuface:评论人的头像     recontent:评论内容      maincontent:被评论主帖内容

 */

@property(nonatomic,strong)NSString *detailid;

@property(nonatomic,strong)NSString *fromuid;

@property(nonatomic,strong)NSString *fromuname;

@property(nonatomic,strong)NSString *fromtid;


@property(nonatomic,strong)NSString *touid;

@property(nonatomic,strong)NSString *totid;


@property(nonatomic,strong)NSString *optype;

@property(nonatomic,strong)NSString *status;

@property(nonatomic,strong)NSString *fromuface;


@property(nonatomic,strong)NSString *recontent;

@property(nonatomic,strong)NSString *maincontent;

@property(nonatomic,strong)NSString *dateline;


@property(nonatomic,strong)NSString *frontimg;//原文图片



-(void)setDic:(NSDictionary *)dicinfo;


@end
