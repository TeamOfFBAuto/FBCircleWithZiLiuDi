//
//  GRXX4ViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-6-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//首页点击头像 跳转的个人信息界面
#import "MyViewController.h"
#import "GpersonCustomCell.h"
#import "FBCirclePersonalModel.h"
#import "ASIFormDataRequest.h"

//发消息
//#import "ChatViewController.h"//张少南 这里消息暂时不添加
//#import "MessageModel.h"


//足迹
#import "GHaoYouFootViewController.h"
#import "GfeiHaoyouFootViewController.h"
#import "GmyFootViewController.h"


//签名
#import "GQianmingViewController.h"


#import "MLImageCrop.h"

#import "GcustomActionSheet.h"

@class MainViewController;

@interface GRXX4ViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,MLImageCropDelegate,GcustomActionSheetDelegate,MBProgressHUDDelegate>

{
    UITableView *_tableView;//主tableView
    
    BOOL _isChooseTouxiang;//是否修改了头像
    BOOL _isChooseArea;//是否修改了地区
    
    GavatarView *imageView;
    
    
    //地区选择
    UIPickerView *_pickeView;
    NSArray *_data;//地区数据
    NSInteger _flagRow;//pickerView地区标志位
    //地区数据字符串拼接
    NSString *_str3;
    NSString *_str1;
    NSString *_str2;
    
    UIView *_backPickView;
    
    
    NSIndexPath *_areaIndexPath;//row1 section1
    
    BOOL _row4section1BtnClicked;//最下方按钮只能点击一次
    
    
    BOOL isUpDiqu;//是否上传地区
    
    
    ASIFormDataRequest *request__;//tap==123 上传头像
    
    
    
    
}

@property(nonatomic,strong)NSString *passUserid;//上个界面传过来的userid 用于判断是否为好友
@property(nonatomic,strong)NSString *userName;//用户名 用于添加好友


@property(nonatomic,strong)FBCirclePersonalModel *personModel;//展示信息数据源
@property(nonatomic,strong)FBCircleModel *fbModel;//文章请求


@property(nonatomic,strong)NSMutableArray *wenzhangArray;//用于展示足迹的三张图片数组


@property(nonatomic,assign)int cellType;



@property(nonatomic,strong)UIImage *userUpFaceImage;//用户需要上传的头像image



@property(nonatomic,strong)NSString *province;//省
@property(nonatomic,strong)NSString *city;//市区县


@property(nonatomic,strong)NSString *gender;//0可以修改 1男 2女


@property(nonatomic,strong)NSString *yuanlaiQianming;//以前的签名


@property(nonatomic,strong)NSString *diqu;//用户修改的地区

@property(nonatomic,strong)NSData *userUpFaceImagedata;//用户上传头像data



@property(nonatomic,assign)BOOL isGmyFootPass;//是否是我的足迹界面跳转过来的


@property(nonatomic,assign)BOOL isMinVc;//是否从tabbar最后的我里跳转过来的

@property(nonatomic,assign)BOOL isTuichuDenglu;//是否点击的是退出登录



@end
