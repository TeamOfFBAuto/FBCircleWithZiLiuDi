//
//  FBCircleCustomCell.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCircleModel.h"
#import "RTLabel.h"
#import "FBCirclePicturesViews.h"
#import "FBCircleMenuView.h"
#import "FBCircleCommentView.h"
#import "ShowImagesViewController.h"
#import "FBCircleDetailPraiseView.h"
#import "FBCircleDetailCommentsView.h"
#import "FBCircleDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FBCircleWebViewController.h"



@class FBCircleCustomCell;
@protocol FBCircleCustomCellDelegate <NSObject>

-(void)clickMenuTapWith:(FBCircleCustomCell *)cell;//弹出赞 评论 转发菜单

-(void)selectedButtonWithType:(FBCircleMenuType)theType With:(FBCircleModel *)model WithCell:(FBCircleCustomCell *)cell;


-(void)deleteTheBlogWithCell:(FBCircleCustomCell *)cell;

-(void)pushToDetailBlogWith:(FBCircleModel *)model;

@end



@interface FBCircleCustomCell : UITableViewCell<FBCircleMenuViewDelegate,FBCircleCommentViewDelegate,RTLabelDelegate,OHAttributedLabelDelegate>
{
    
}

@property(nonatomic,strong)FBCircleModel * myModel;

@property(nonatomic,assign)id<FBCircleCustomCellDelegate>delegate;

@property(nonatomic,strong)AsyncImageView * headerImageView;

@property(nonatomic,strong)UILabel * userName_label;

@property(nonatomic,strong)OHAttributedLabel * content_label;
///时间
@property(nonatomic,strong)UILabel * date_label;

@property(nonatomic,strong)UIButton * menu_button;

@property(nonatomic,strong)FBCirclePicturesViews * PictureViews;

@property(nonatomic,strong)UIImageView * forwardBackGroundImageView;

@property(nonatomic,strong)UILabel * rUserName_label;

@property(nonatomic,strong)OHAttributedLabel * rContent_label;

@property(nonatomic,strong)FBCirclePicturesViews * rPictuteViews;


@property(nonatomic,strong)UIImageView * menu_background_view;

@property(nonatomic,strong)FBCircleMenuView * menu_view;

@property(nonatomic,strong)FBCircleCommentView * commentView;

@property(nonatomic,strong)RTLabel * zan_label;

@property(nonatomic,strong)FBCircleDetailPraiseView * PraiseView;

@property(nonatomic,strong)FBCircleDetailCommentsView * FBCircleDetailCommentView;

@property(nonatomic,strong)UILabel * deleteButton;


//线

@property(nonatomic,strong)UIImageView * jiantou_imageView;

@property(nonatomic,strong)UIView * Menu_Line_view;

@property(nonatomic,strong)UIView * comment_line_view;

@property(nonatomic,strong)UIView * down_line_view;

//新版转发

@property(nonatomic,strong)AsyncImageView * rContentImageView;

///如果内容过长，显示部分并提示显示全文
@property(nonatomic,strong)UIButton * show_detail_content_button;


-(void)setAllViews;


-(float)setInfomationWith:(FBCircleModel *)theInfo;

-(float)returnCellHeightWith:(FBCircleModel *)info;


@end














