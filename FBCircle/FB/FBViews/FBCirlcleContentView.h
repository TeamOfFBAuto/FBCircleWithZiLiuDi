//
//  FBCirlcleContentView.h
//  FBCircle
//
//  Created by soulnear on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "FBCirclePicturesViews.h"
#import "FBCircleMenuView.h"
#import "FBCircleModel.h"
#import "ShowImagesViewController.h"
#import "FBCircleWebViewController.h"


@protocol FBCirlcleContentViewDelegate <NSObject>

-(void)clickToShowMenu;//弹出赞 评论 转发菜单

-(void)selectedButtonWithType:(FBCircleMenuType)theType;

-(void)clickToShowOriginalBlogWith:(FBCircleModel *)model;


@end



@interface FBCirlcleContentView : UIView<FBCircleMenuViewDelegate,OHAttributedLabelDelegate>
{
    
}


@property(nonatomic,assign)id<FBCirlcleContentViewDelegate>delegate;

@property(nonatomic,strong)FBCircleModel * theFBModel;

@property(nonatomic,strong)AsyncImageView * headerImageView;

@property(nonatomic,strong)UILabel * userName_label;

@property(nonatomic,strong)OHAttributedLabel * content_label;

@property(nonatomic,strong)UILabel * date_label;

@property(nonatomic,strong)UIButton * menu_button;


@property(nonatomic,strong)FBCirclePicturesViews * PictureViews;

@property(nonatomic,strong)UIImageView * forwardBackGroundImageView;

@property(nonatomic,strong)UILabel * rUserName_label;

@property(nonatomic,strong)OHAttributedLabel * rContent_label;

@property(nonatomic,strong)FBCirclePicturesViews * rPictuteViews;

@property(nonatomic,strong)AsyncImageView * rContentImageView;

@property(nonatomic,strong)UIImageView * menu_background_view;

@property(nonatomic,strong)FBCircleMenuView * menu_view;

@property(nonatomic,strong)UIImageView * jiantou_imageView;

@property(nonatomic,strong)UIImageView * sep_line_view;


-(float)setInfoWith:(FBCircleModel *)theInfo;



@end













