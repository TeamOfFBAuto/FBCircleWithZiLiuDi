//
//  GmyFootViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//



//我的足迹
#import <UIKit/UIKit.h>
#import "GavatarView.h"
#import "GmyFootCustomTableViewCell.h"
#import "FBCirclePersonalModel.h"
#import "FBCircleModel.h"
#import "GTimeSwitch.h"



#import "FBCircleDetailViewController.h"

#import "UIImageView+AFNetworking.h"

#import "ASIHTTPRequest.h"

#import "ASIFormDataRequest.h"

#import "WriteBlogViewController.h"//写文章

#import "EGORefreshTableHeaderView.h"

#import "MLImageCrop.h"

#import "GcustomActionSheet.h"


#import "AppDelegate.h"



@interface GmyFootViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,GcustomActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,QBImagePickerControllerDelegate,MLImageCropDelegate,WriteBlogViewControllerDelegate>

{
    UITableView *_tableView;//主tableview
    
    BOOL _isChooseTopView;//是否更改了最上面的topview
    
    GmyFootCustomTableViewCell *_tmpCell;//用户获取单元格高度的临时cell
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    
    int _currentPage;
    
    BOOL _wzRefresh;
    BOOL _perRefresh;
    
    
    //上提加载更多
    LoadingIndicatorView *_upMoreView;//上提加载更多
    BOOL _isUpMoreSuccess;//上提加载成功
    BOOL _isupMore;//是否为上提加载更多
    
    
    
    
    //足迹点加号点 从相册添加图片
    QBImagePickerController * imagePickerController;
    BOOL _isJiaHaoPick;//用于区分imagePickControllerDelegate
    
    
    
    //请求文章数据 count为0 _currentPage不加
    int _wenzhangArrayCount;
    
    
    //点击头像的pickview
    
    GcustomActionSheet *_acts;
    
    
    //加号的pickerview
    GcustomActionSheet *_actionSheet;
}

//上个页面传过来的参数
@property(nonatomic,strong)NSString *userId;//用户id

//view
@property(nonatomic,strong)GavatarView *topImageView;//最上方view

//model
@property(nonatomic,strong)FBCircleModel * wenzhangModel;//文章对象 用于请求网络数据
@property(nonatomic,strong)FBCirclePersonalModel *userModel;//用户对象

//array
@property(nonatomic,strong)NSMutableArray *wenzhangArray;//网络请求下来的文章数组
@property(nonatomic,strong)NSMutableArray *wenzhangTimeArray;//按时间排序的文章对象数组




@property(nonatomic,assign)BOOL isMineVCPush;//是否是从minevc跳转的页面


//上传
@property(nonatomic,strong)UIImage *userUpImage;//用户剪裁后需要上传的top图片
@property(nonatomic,strong)NSData *userUpImageData;//用户剪裁后需要上传的图片data格式



@end
