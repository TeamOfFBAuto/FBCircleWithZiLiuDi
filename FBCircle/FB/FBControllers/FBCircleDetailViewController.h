//
//  FBCircleDetailViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//文章详细页

#import "MyViewController.h"
#import "FBCircleModel.h"
#import "FBCircleCommentModel.h"
#import "FBCircleDetailCommentsView.h"
#import "FBCirlcleContentView.h"
#import "ChatInputView.h"
#import "FBCircleDetailPraiseView.h"
#import "WeiBoFaceScrollView.h"
#import "NewFaceView.h"
#import "ZSNAlertView.h"
#import "GHaoYouFootViewController.h"
#import "FBQuanAlertView.h"
#import "LoadingIndicatorView.h"
#import "GRXX4ViewController.h"
#import "FBCircleWebViewController.h"


typedef void(^FBCircleDetailViewControllerBlock)(void);

//从我的消息界面传过来的文章model 请求网络数据block

typedef void(^GmyMessagePassBlock)();



@interface FBCircleDetailViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,FBCirlcleContentViewDelegate,UITextViewDelegate,ChatInputViewDelegate,expressionDelegate,FBCircleDetailCommentsViewDelegate,FBCircleDetailPraiseViewDelegate,UIAlertViewDelegate>
{
    FBCircleDetailCommentsView * fbCircleDetailCommentsView;
    
    FBCirlcleContentView * contentView;
    
    FBCircleDetailPraiseView * praiseView;
    
    FBCircleDetailViewControllerBlock fbcircledetailviewblock;
    
    int temp_count;
    
    UITextView * temp_textView;
    
    BOOL isFace;
    
    WeiBoFaceScrollView * faceScrollView;
    
    BOOL isMyTextView;
    
    FBQuanAlertView * myAlertView;
    
    LoadingIndicatorView * loadview;
    
}

@property(nonatomic,strong)GmyMessagePassBlock gmyMessagePassBlock;//在我的消息界面设置

@property(nonatomic,strong)FBCircleModel * theModel;

@property(nonatomic,assign)BOOL isForward;



@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)FBCircleCommentModel * commentModel;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,assign)int currentPage;


@property(nonatomic,strong)ChatInputView * inputToolBarView;

@property(nonatomic,strong)UIView * theTouchView;

//在我的消息界面设置的block
-(void)setGmyMessagePassBlock:(GmyMessagePassBlock)gmyMessagePassBlock;

-(void)reloadDataWhenBackWith:(FBCircleDetailViewControllerBlock)theBlock;


/**
 *  test
 */

@property(nonatomic,strong)NSString * wenzhangid;
@property(nonatomic,strong)NSString * xiaoxiid;
@property(nonatomic,strong)NSString * flag;



/**
 *  testend
 */


@end
