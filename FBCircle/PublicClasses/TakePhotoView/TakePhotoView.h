//
//  TakePhotoView.h
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TakePhotoViewBlock)(int index);

@interface TakePhotoView : UIView
{
    TakePhotoViewBlock take_photo_block;
}


- (id)initWithFrame:(CGRect)frame WithBlock:(TakePhotoViewBlock)theBlock;


///顶部导航view
@property(nonatomic,strong)UIImageView * theNav_view;


///顶部关闭按钮
@property(nonatomic,strong)UIButton * close_button;

///底部导航view
@property(nonatomic,strong)UIView * bottom_view;

///拍照按钮

@property(nonatomic,strong)UIButton * shoot_button;

///取景框

@property(nonatomic,strong)UIImageView * view_finder_view;


@end
