//
//  SendPostsBottomView.h
//  FBCircle
//
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendPostsBottomViewBlock)(int index);



@interface SendPostsBottomView : UIView
{
    SendPostsBottomViewBlock sendPosts_block;
}


-(SendPostsBottomView *)initWithFrame:(CGRect)frame WithBlock:(SendPostsBottomViewBlock)theBlock;


@end
