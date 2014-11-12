//
//  BBSTopicController.h
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyViewController.h"
/**
 *  主题帖 - 帖子详情
 */

typedef void(^UpdateBlock)(BOOL update,NSDictionary *userInfo);

@interface BBSTopicController : MyViewController
{
    UpdateBlock updateBlock;
}

@property(nonatomic,retain)NSString *tid;//主贴id
@property(nonatomic,retain)NSString *fid;//板块id

@property(nonatomic,assign)int modelIndex;//对应数组下标

- (void)updateBlock:(UpdateBlock)aBlock;

@end
