//
//  SendPostsImageScrollView.h
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>


///previewPage 为0时是删除图片  为1时是跳到图片详情页
typedef void(^SendPostsImageScrollViewBlock)(int index,int preViewPage);

@interface SendPostsImageScrollView : UIScrollView
{
    SendPostsImageScrollViewBlock sendImage_block;
}

@property(nonatomic,weak)NSMutableArray * data_array;

@property(nonatomic,strong)NSMutableArray * imageView_array;

///图片类，显示选择的图片
-(void)loadAllViewsWith:(NSMutableArray *)array WithBlock:(SendPostsImageScrollViewBlock)theBlock;




@end
