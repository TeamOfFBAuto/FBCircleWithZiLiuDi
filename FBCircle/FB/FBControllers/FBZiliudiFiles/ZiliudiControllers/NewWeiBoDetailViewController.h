//
//  NewWeiBoDetailViewController.h
//  FbLife
//
//  Created by soulnear on 13-12-12.
//  Copyright (c) 2013年 szk. All rights reserved.
//
/**
 微博详情界面
 **/

#import <UIKit/UIKit.h>
#import "FbFeed.h"
#import "NewWeiBoCustomCell.h"
#import "ReplysFeed.h"
#import "RTLabel.h"
#import "WeiBoSpecialView.h"
#import "DetailBottomView.h"
#import "ForwardingViewController.h"
#import "NewWeiBoCommentViewController.h"
#import "LoadingIndicatorView.h"


@interface NewWeiBoDetailViewController : MyViewController<UITableViewDelegate,UITableViewDataSource,NewWeiBoCustomCellDelegate,WeiBoSpecialViewDelegate,DetailBottomViewDelegate,ForwardingViewControllerDelegate,NewWeiBoCommentViewControllerDelegate,RTLabelDelegate>
{
    ASIHTTPRequest * detail_request;
    
    int pageCount;
    
    FbFeed * _feed;
    
    UIView * weibo_content_view;
    
    AsyncImageView * _Head_ImageView;
    
    UILabel *  _UserName_Label;
    
    UILabel * _DateLine_Label;
    
    RTLabel * content_label;
    
    RTLabel * test_label;
    
    LoadingIndicatorView * tabelFootView;
    
    UIView * tishi_view;
    
}
///如果有微博内容，赋给info，这种情况下不需要请求微博数据
@property(nonatomic,strong)FbFeed * info;
///如果没有微博数据(info没有值)，那么需要给tid赋值以请求微博数据
@property(nonatomic,strong)NSString * tid;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * photos;

@property(nonatomic,strong)UITableView * myTableView;



@end
