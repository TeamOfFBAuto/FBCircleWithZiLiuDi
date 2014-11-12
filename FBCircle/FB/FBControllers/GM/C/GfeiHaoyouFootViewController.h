//
//  GfeiHaoyouFootViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-6-5.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//从搜索好友界面 点击非好友足迹   从首页评论人的头像
#import "MyViewController.h"

#import "FBCircleModel.h"

#import "LoadingIndicatorView.h"

#import "GmyFootCustomTableViewCell.h"

#import "GTimeSwitch.h"

#import "FBCircleDetailViewController.h"

@interface GfeiHaoyouFootViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;//主tableview
    
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
    
    //请求文章数据 count为0 _currentPage不加
    int _wenzhangArrayCount;
    
    
    
}




//view
@property(nonatomic,strong)GavatarView *topImageView;//最上方view

//model
@property(nonatomic,strong)FBCircleModel * wenzhangModel;//文章对象 用于请求网络数据
@property(nonatomic,strong)FBCirclePersonalModel *userModel;//用户对象

//array
@property(nonatomic,strong)NSMutableArray *wenzhangArray;//网络请求下来的文章数组
@property(nonatomic,strong)NSMutableArray *wenzhangTimeArray;//按时间排序的文章对象数组


//参数
@property(nonatomic,strong)NSString *userId;//上个界面过来的userid


@property(nonatomic,assign)BOOL isFromPinglun;//是否为评论界面过来的


@end
