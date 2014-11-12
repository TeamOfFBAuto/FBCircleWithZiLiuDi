//
//  CommentViewController.h
//  FbLife
//
//  Created by szk on 13-3-18.
//  Copyright (c) 2013年 szk. All rights reserved.
//
/*
 自留地文章评论界面
 */

@protocol NewWeiBoCommentViewControllerDelegate <NSObject>

-(void)commentSuccessWihtTid:(NSString *)theTid IndexPath:(int)theIndexpath SelectView:(int)theselectview withForward:(BOOL)isForward;

@end

#import <UIKit/UIKit.h>
#import "FriendListViewController.h"
//#import "FaceView.h"张少南，这里需要把新版的表情加上
#import "FbFeed.h"
//#import "ATMHud.h"张少南把新版提示加上
#import "MyTextViewForForward.h"



@interface NewWeiBoCommentViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,expressionDelegate,UIAlertViewDelegate,MyTextViewForForwardDelegate>
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
}


@property(nonatomic,strong)FbFeed * info;
@property(nonatomic,strong)MyTextViewForForward * myTextView;
@property(nonatomic,strong)NSString * tid;
@property(nonatomic,strong)NSString * rid;
@property(nonatomic,strong)NSString * username;
@property(nonatomic,strong)NSString * theTitle;
@property(nonatomic,strong)NSString * theText;
@property(nonatomic,strong)NSString * zhuanfa;

@property(nonatomic,assign)int theIndexPath;
@property(nonatomic,assign)int theSelectViewIndex;


@property(nonatomic,assign)id<NewWeiBoCommentViewControllerDelegate>delegate;

@end




