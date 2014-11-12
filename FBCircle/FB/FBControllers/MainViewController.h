//
//  MainViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "WriteBlogViewController.h"
#import "FBCircleModel.h"
#import "FBCircleCustomCell.h"
#import "MessageViewController.h"
#import "FBCircleMenuView.h"
#import "ChatInputView.h"
#import "FBCircleDetailViewController.h"
#import "WeiBoFaceScrollView.h"
#import "NewFaceView.h"
#import "ZSNAlertView.h"
#import "FBCirclePersonalModel.h"
#import "LoadingIndicatorView.h"
#import "FBCircleCommentModel.h"
#import "FBCirclePraiseModel.h"
#import "ConnectofMineView.h"
#import "GmyMessageViewController.h"
#import "ShowImagesViewController.h"
#import "MatchingAddressBookViewController.h"
#import "MessageViewController.h"
#import "FBQuanAlertView.h"
#import "FBCirclePromptView.h"
#import "MLImageCrop.h"


@interface MainViewController : MyViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,FBCircleCustomCellDelegate,ChatInputViewDelegate,UITextViewDelegate,EGORefreshTableHeaderDelegate,expressionDelegate,UIAlertViewDelegate,WriteBlogViewControllerDelegate,MLImageCropDelegate,ZActionSheetDelegate,GcustomActionSheetDelegate>
{
    EGORefreshTableHeaderView * _refreshHeaderView;
    
    BOOL _reloading;
    
    BOOL isFace;
    
    UIImageView * tixing_imageView;
    
    WeiBoFaceScrollView * faceScrollView;
    
    QBImagePickerController * imagePickerController;
    
    int currentPage;
    
    FBCircleCustomCell * test_cell;
    
    int history_selected_menu_page;
    
    UITextView * temp_textView;
    
    int temp_count;
    
    BOOL isMyTextView;
    
    
    AsyncImageView * bannerView;
    
    AsyncImageView * user_header_imageView;
    
    UILabel * userName_label;
    
    
    
    UIView * headerView;
    
    BOOL loadsucess;//判断是否刷新成功
    
    LoadingIndicatorView * loadview;
    
    NSIndexPath * deleteIndexPath;
    
    UIAlertView * loading_alertView;
    
    BOOL isHaveNewMessage;
    
    NSDictionary * notificationDic;
    
    int notificationNum;
    
    UIView * bottom_line_view;
    
    FBQuanAlertView * myAlertView;
    
    FBCirclePromptView * tixing_view;
    
    NSMutableDictionary * notification_dictionary;
    
    BOOL isUpdataBanner;
    
    ConnectofMineView * connectV;
    
    UIButton *right_button;
    
}

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;
///存放每个cell的高度
@property(nonatomic,strong)NSMutableArray * cell_height_array;

@property(nonatomic,strong)FBCircleModel * theModel;

@property(nonatomic,strong)ChatInputView * inputToolBarView;

@property(nonatomic,strong)UIView * theTouchView;

@property(nonatomic,strong)FBCirclePersonalModel * personModel;


@end
