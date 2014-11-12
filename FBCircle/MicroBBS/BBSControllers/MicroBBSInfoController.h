//
//  MicroBBSInfoController.h
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyViewController.h"
/**
 *  微论坛信息页
 */
typedef void(^UpdateMemberNumberBlock)(int memberNum);

@interface MicroBBSInfoController : MyViewController
{
    UpdateMemberNumberBlock _memberBlock;
}

@property(nonatomic,retain)NSString *bbsId;

- (void)updateMemberNumberBlock:(UpdateMemberNumberBlock)block;

@end
