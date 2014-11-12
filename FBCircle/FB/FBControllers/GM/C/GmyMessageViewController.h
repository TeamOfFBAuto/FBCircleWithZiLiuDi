//
//  GmyMessageViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//系统通知
#import <UIKit/UIKit.h>
#import "FBQuanMessageModel.h"
#import "GmyMessageTableViewCell.h"


#import "EGORefreshTableHeaderView.h"

#import "FBCircleDetailViewController.h"


#import "GloadingView.h"


#import "MBProgressHUD.h"

@interface GmyMessageViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>

{
    UITableView *_tableView;//主tableview
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    
    int _currentPage;
    
    BOOL _wzRefresh;
    BOOL _perRefresh;
    
    
    //上提加载更多
    GloadingView *_upMoreView;//上提加载更多
    BOOL _isUpMoreSuccess;//上提加载成功
    BOOL _isupMore;//是否为上提加载更多
    
    
    //请求消息数据 count为0 _currentPage不加
    int _messageArrayCount;
    
    //tmpcell
    GmyMessageTableViewCell *_tmpCell;
    
    
    //文章model
    FBCircleModel *_wenzhangModel;
    
    
    //清空消息alert
    UIAlertView *_alertView;
    
    
    MBProgressHUD *_hud;
    
    
    //没有数据时候的文字提示
    UILabel *_noDataTishiLabel;
}


//数据源：
@property(nonatomic,strong)NSMutableArray *MessageArray;//消息数组
@property(nonatomic,strong)FBQuanMessageModel *messageModel;//消息model

//跳转到文章详情页面需要的两个参数
@property(nonatomic,strong)NSString *messageId;//消息id
@property(nonatomic,strong)NSString *wenzhangId;//文章id 来自哪个文章




@end
