//
//  ForwardingViewController.h
//  FbLife
//
//  Created by szk on 13-3-18.
//  Copyright (c) 2013年 szk. All rights reserved.
//
/*
 微博文章转发界面
 */

@protocol ForwardingViewControllerDelegate <NSObject>

-(void)ForwardingSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview WithComment:(BOOL)isComment;

@end


#import <UIKit/UIKit.h>
//#import "FaceView.h"张少南，这里需要把新版的表情加上
#import "FbFeed.h"
#import "FriendListViewController.h"张少南这里需要把朋友列表页数据改成web端的
//#import "ATMHud.h"张少南，这里需要把新版的提示框加上
#import "MyTextViewForForward.h"
#import "GrayPageControl.h"

@interface ForwardingViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,expressionDelegate,UIAlertViewDelegate,MyTextViewForForwardDelegate>
{
    UINavigationBar * nav;
    
    
    UIView * face_view;
    UIImageView * weibo_view;
    
    UIView * backView;
    
    UIButton * wordsNumber_button;
    
    BOOL isFace;
    
    int remainTextNum;
    
    BOOL isZhuanFa;
    
    UIImageView * mark;
    GrayPageControl * pageControl;
}


@property(nonatomic,strong)FbFeed * info;
@property(nonatomic,strong)MyTextViewForForward * myTextView;
@property(nonatomic,strong)NSString * tid;
@property(nonatomic,strong)NSString * rid;
@property(nonatomic,strong)NSString * username;
@property(nonatomic,strong)NSString * theTitle;
@property(nonatomic,strong)NSString * totid;
@property(nonatomic,strong)NSString * theText;

@property(nonatomic,strong)NSString * zhuanfa;

@property(nonatomic,assign)int theIndexPath;
@property(nonatomic,assign)int theSelectViewIndex;

@property(nonatomic,assign)id<ForwardingViewControllerDelegate>delegate;



@end
