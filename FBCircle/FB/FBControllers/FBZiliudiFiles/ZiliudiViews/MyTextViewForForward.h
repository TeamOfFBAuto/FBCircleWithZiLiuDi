//
//  MyTextViewForForward.h
//  越野e族
//
//  Created by soulnear on 14-2-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//
/*
 转发、评论界面输入框
 */
@protocol MyTextViewForForwardDelegate <NSObject>

-(void)clickMyTextView;

@end

#import <UIKit/UIKit.h>

@interface MyTextViewForForward : UITextView
{
    
}


@property(nonatomic,assign)id<MyTextViewForForwardDelegate>delegate1;

@end
