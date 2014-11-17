//
//  MicroBBSViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MicroBBSViewController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "BBSListViewController.h"
#import "BBSTopicController.h"
#import "BBSSearchController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSTableCell.h"
#import "CreateNewBBSViewController.h"
#import "LBBSCellView.h"
#import "BBSInfoModel.h"
#import "TopicModel.h"

#import "JoinBBSCell.h"

#define CACHE_MY_BBS @"mybbs" //我的论坛
#define CACHE_HOT_TOPIC @"hotTopic" //热门推荐
#define CACHE_CONCERN_HOT @"concern_hot" //关注热门

#define TITLE_MY_CONCERN_HOT @"我的论坛热帖"
#define TITLE_MY_HOT_RECOMMEND @"热门推荐"
#define TITLE_MY_MY_BBS @"我的论坛"
#define TITLE_RECOMMEND_BBS @"推荐的微论坛"

@interface MicroBBSViewController ()<UISearchBarDelegate,RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *_myBBSArray;//我的论坛
    NSArray *_concern_hot_array;//关注热门
    NSArray *_hot_array;//热门
    NSArray *_recommend_bbs_array;//热门推荐论坛
    
    BOOL my_bbs_success;//我的论坛
    BOOL hot_recommend;//热门推荐
    
    UIView *headerView;
    UIView *_mybbsView;
    UIView *_recommendView;
    
    BOOL _needRefresh;
}

@end

@implementation MicroBBSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"auteykey %@",[SzkAPI getAuthkey]);
    
    if (_needRefresh) {
        
        
        [_table showRefreshNoOffset];
        
        
        _needRefresh = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.view.backgroundColor = [UIColor redColor];
    
    self.title = @"微论坛";
    self.titleLabel.text = @"微论坛";
    self.rightImageName = @"+";
    self.leftString = @"分类论坛";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    [self.left_button addTarget:self action:@selector(clickToClassifyBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0,0, 320, self.view.height - 44 - 49 - 20) showLoadMore:NO];
    _table.backgroundColor = self.view.backgroundColor;
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.hiddenLoadMore = YES;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorColor = COLOR_TABLE_LINE;
    _table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_table];
    
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    _table.tableFooterView = footer_view;
    
    
    //    //缓存数据
    //
    //    NSDictionary *dataInfo = [LTools cacheForKey:CACHE_MY_BBS];
    //
    //    if (dataInfo) {
    //
    //        _myBBSArray = [self parseForMyBBS:dataInfo];
    //        _table.tableHeaderView = [self createTableHeaderView];
    //
    //
    //        dataInfo = [LTools cacheForKey:CACHE_HOT_TOPIC];
    //
    //        if (dataInfo) {
    //            _hot_array = [self parseTopic:dataInfo dataStyle:0];
    //        }
    //
    ////        [self createSecond];
    //    }
    //
    //    dataInfo = [LTools cacheForKey:CACHE_CONCERN_HOT];
    //    if (dataInfo) {
    //        _concern_hot_array = [self parseTopic:dataInfo dataStyle:1];
    //        [_table reloadData];
    //    }
    
    [self loadNewData];
    
    
    
    //更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_TOPICLIST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:SUCCESSLOGIN object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

- (void)updateBBS:(NSNotification *)sender
{
    _needRefresh = YES;
}

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    [self PushToViewController:myBBS WithAnimation:YES];
}

- (void)clickToMore:(UIButton *)sender
{
    if (sender.tag == 999) {
        NSLog(@"进入论坛分类");
        
        [self clickToClassifyBBS];
        
    }else
    {
        HotTopicViewController *hotTopic = [[HotTopicViewController alloc]init];
        hotTopic.data_Style = sender.tag - 100;
        [self PushToViewController:hotTopic WithAnimation:YES];
    }
}
/**
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    [self PushToViewController:classify WithAnimation:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    CreateNewBBSViewController * sendPostVC = [[CreateNewBBSViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}
/**
 *  论坛帖子列表
 */
- (void)clickToBBSList:(UIButton *)sender
{
    BBSInfoModel *aModel = [_myBBSArray objectAtIndex:sender.tag - 100];
    BBSListViewController *list = [[BBSListViewController alloc]init];
    list.bbsId = aModel.fid;
    [self PushToViewController:list WithAnimation:YES];
}

/**
 *  帖子详情(从热门推荐进入)
 */
- (void)clickToTopicInfo:(LBBSCellView *)sender
{
    TopicModel *aModel = [_hot_array objectAtIndex:sender.tag - 1000];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    
    [self PushToViewController:topic WithAnimation:YES];
}

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
    BBSSearchController *search = [[BBSSearchController alloc]init];
    [self PushToViewController:search WithAnimation:YES];
}

#pragma mark - 数据解析

/**
 *  我的论坛
 */
- (NSArray *)parseForMyBBS:(NSDictionary *)dataInfo
{
    NSArray *create = [dataInfo objectForKey:@"create"];
    
    NSMutableArray *arr_mine = [NSMutableArray arrayWithCapacity:create.count];
    
    for (NSDictionary *aDic in create) {
        
        //status:论坛状态（0:正常   1:删除    2:审核中）
        
        int status = [[aDic objectForKey:@"forum_status"]integerValue];
        if (status == 0) {
            
            [arr_mine addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
        }
        
//        if (arr_mine.count == 3) {
//            return arr_mine;
//        }
    }
    
    NSArray *join = [dataInfo objectForKey:@"join"];
    for (NSDictionary *aDic in join) {
        
        int status = [[aDic objectForKey:@"forum_status"]integerValue];
        if (status == 0) {
            
            BBSInfoModel *info = [[BBSInfoModel alloc]initWithDictionary:aDic];
            
            if (info.name.length > 0) {
                [arr_mine addObject:info];
            }
            
        }
        
//        if (arr_mine.count == 3) {
//            return arr_mine;
//        }
    }
    
    return arr_mine;
}

/**
 *  推荐热门和关注热门
 *  @param dataStyle 区分
 */
- (NSArray *)parseTopic:(NSDictionary *)result dataStyle:(int)dataStyle
{
    NSArray *dataInfo;
    
    if (dataStyle == 0) {
        dataInfo = [result objectForKey:@"datainfo"];
    }else if (dataStyle == 1){
        dataInfo = [result objectForKey:@"data"];
    }
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
    for (NSDictionary *aDic in dataInfo) {
        
        if ([aDic isKindOfClass:[NSDictionary class]]) {
            int max = (dataStyle == 0) ? 2 : 15;
            
            if (arr.count < max) {
                TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
        }
        
    }
    return arr;
}

#pragma mark - 网络请求

/**
 *  推荐论坛
 */
- (void)getRecommenedBBS
{
    //先读取缓存数据
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_RECOMMENTED_BBS,[SzkAPI getUid]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *bbs_arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in dataInfo) {
                
                BBSInfoModel *aBBS = [[BBSInfoModel alloc]initWithDictionary:aDic];
                [bbs_arr addObject:aBBS];
            }
            
            _recommend_bbs_array = [NSArray arrayWithArray:bbs_arr];
            
            [weakTable reloadData];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
    }];
}



/**
 *  我创建和加入的论坛
 */
- (void)getMyBBS
{
    //先读取缓存数据
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MINE,[SzkAPI getAuthkey],1,100];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"CACHE_MY_BBS 有更新");
            
            [LTools cache:dataInfo ForKey:CACHE_MY_BBS];
            
            //一共需要三个,优先“创建的论坛”,不够再用“加入的论坛”
            
            //修改：有多少就多少，可滑动
            
            _myBBSArray = [weakSelf parseForMyBBS:dataInfo];
            
            weakTable.tableHeaderView = [weakSelf createTableHeaderView];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        _myBBSArray = nil;
        weakTable.tableHeaderView = [weakSelf createTableHeaderView];
    }];
}

/**
 *  获取热门推荐和 关注热门
 *
 *  @param dataStyle 0 热门推荐、1 关注热门
 */
- (void)getTopic:(int)dataStyle
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url;
    if (dataStyle == 0) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_HOT,1,2];//热门帖子(最多两个)
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_MYJOIN,[SzkAPI getAuthkey],1,5];//关注热门帖子(最多15个)
        
        NSLog(@"---->关注热门帖子 %@",url);
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if (dataStyle == 0) {
            //热门帖子
            
            NSLog(@"CACHE_HOT_TOPIC 有更新");
            
            [LTools cache:result ForKey:CACHE_HOT_TOPIC];
            
            _hot_array = [self parseTopic:result dataStyle:dataStyle];
            
            [weakTable reloadData];
            
            
        }else if (dataStyle == 1)
        {
            //关注帖子
            
            NSLog(@"CACHE_CONCERN_HOT 有更新");
            
            NSDictionary *datainfo = [result objectForKey:@"datainfo"];
            
            if ([datainfo isKindOfClass:[NSDictionary class]]) {
                
                NSArray *data = [datainfo objectForKey:@"data"];
                
                if (![data isKindOfClass:[NSArray class]]) {
                    
                    datainfo = nil;
                }
            }
            @try{
                
                [LTools cache:datainfo ForKey:CACHE_CONCERN_HOT];
                
                
                _concern_hot_array = [self parseTopic:datainfo dataStyle:dataStyle];
                
            }
            @catch(NSException *exception) {
                NSLog(@"异常错误是:%@", exception);
            }
            @finally {
                
            }
            
            [weakTable reloadData:nil total:0];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        
        if (dataStyle == 1)
        {
            //            [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
            int errcode = [[failDic objectForKey:@"errcode"]integerValue];
            if (errcode == 2) {
                
                [LTools cache:nil ForKey:CACHE_CONCERN_HOT];
                _concern_hot_array = nil;
                
            }
        }
        
        [weakTable loadFail];
        
        
    }];
}

///**
// *  加入论坛
// *
// *  @param bbsId 论坛id
// */
//- (void)JoinBBSId:(NSString *)bbsId cell:(JoinBBSCell *)sender
//{
//    __weak typeof(self)weakSelf = self;
//    //    __weak typeof(UIButton *)weakBtn = sender;
//    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],bbsId];
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
//    
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        NSLog(@"result %@",result);
//        
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            
//            int erroCode = [[result objectForKey:@"errcode"]integerValue];
//            if (erroCode == 0) {
//                //加入论坛通知
//                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil userInfo:nil];
//                //                weakBtn.selected = YES;
//                sender.joinButton.selected = YES;
//                sender.memeberLabel.text = [NSString stringWithFormat:@"%d",[sender.memeberLabel.text integerValue] + 1];
//            }
//        }
//        
//        
//    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        NSLog(@"result %@",failDic);
//        
//        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
//    }];
//    
//}


/**
 *  加入论坛
 *
 *  @param bbsId 论坛id
 */
- (void)JoinBBSId:(BBSInfoModel *)aModel cell:(JoinBBSCell *)sender
{
//    __weak typeof(self)weakSelf = self;
    //    __weak typeof(UIButton *)weakBtn = sender;
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],aModel.id];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]integerValue];
            if (erroCode == 0) {
                //加入论坛通知
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil userInfo:nil];
                //                weakBtn.selected = YES;
                sender.joinButton.selected = YES;
                sender.memeberLabel.text = [NSString stringWithFormat:@"%d",[sender.memeberLabel.text integerValue] + 1];
                aModel.inForum = 1;
                aModel.inforum = 1;
                aModel.member_num = sender.memeberLabel.text;
            }
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
    }];
    
}


#pragma mark - 视图创建

/**
 *  搜索view
 */
- (UIView *)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    //    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    
    //    search_bgview.backgroundColor = [UIColor redColor];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    bar.placeholder = @"搜索";
    bar.delegate = self;
    bar.layer.borderWidth = 2.f;
    bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    bar.barTintColor = COLOR_SEARCHBAR;
    [search_bgview addSubview:bar];
    return search_bgview;
}

/**
 *  计算我的论坛最佳宽度
 */
- (CGFloat)fitWidth:(NSArray *)arr
{
    if (arr.count <= 1) {
        return 300.f;
    }
    NSString *title1 = ((BBSInfoModel *)[arr objectAtIndex:0]).name;
    NSString *title2 = ((BBSInfoModel *)[arr objectAtIndex:1]).name;
    
    NSString *title3 = @"";
    if (arr.count == 3) {
        title3 = ((BBSInfoModel *)[arr objectAtIndex:2]).name;
    }
    
    if (title1.length <= 6 && title2.length <= 6 && title3.length <= 6) {
        return 100.f;
    }
    
    return 150.f;
}

- (UIView *)createTableHeaderView
{
    if (headerView) {
        [headerView removeFromSuperview];
        headerView = nil;
    }
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    //搜索view
    
    UIView *search = [self createSearchView];
    [headerView addSubview:search];
    
    //我的论坛
    
    _mybbsView = [[UIView alloc]initWithFrame:CGRectMake(8, 19 + 45, 304, 80)];
    _mybbsView.layer.cornerRadius = 3.f;
    _mybbsView.clipsToBounds = YES;
    [headerView addSubview:_mybbsView];
    
    LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:TITLE_MY_MY_BBS target:self action:@selector(clickToMyBBS:)];
    [_mybbsView addSubview:section];
    
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(section.left, section.bottom ,section.width, 40)];
    secondBgView.backgroundColor = [UIColor whiteColor];
    [_mybbsView addSubview:secondBgView];
    
    UIScrollView *second_scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, secondBgView.width, secondBgView.height)];
//    second_scroll.backgroundColor = [UIColor orangeColor];
    second_scroll.showsHorizontalScrollIndicator = NO;
    [secondBgView addSubview:second_scroll];
    
    
    CGFloat lastRight = 0.f; //上一个的右坐标
    for (int i = 0 ; i < _myBBSArray.count; i ++) {
        
        NSString *title = ((BBSInfoModel *)[_myBBSArray objectAtIndex:i]).name;
        
        CGFloat aWidth = [LTools widthForText:title font:FONT_SIZE_MID];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_MID]];
        btn.frame = CGRectMake(lastRight, 0, aWidth + 20, 40);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [second_scroll addSubview:btn];
        
        lastRight = btn.right;//记录上一个的 right
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickToBBSList:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i != _myBBSArray.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1, 20)];
            line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
            [second_scroll addSubview:line];
        }
        
        second_scroll.contentSize = CGSizeMake(btn.right, second_scroll.height);
    }

    
//    CGFloat aWidth = [self fitWidth:_myBBSArray];
//    
//    for (int i = 0 ; i < _myBBSArray.count; i ++) {
//        
//        if ((i + 1) * aWidth <= 300) {
//            NSString *title = ((BBSInfoModel *)[_myBBSArray objectAtIndex:i]).name;
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            [btn setTitle:title forState:UIControlStateNormal];
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_MID]];
//            btn.frame = CGRectMake(aWidth * i, 0, aWidth, 40);
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [secondBgView addSubview:btn];
//            btn.tag = 100 + i;
//            [btn addTarget:self action:@selector(clickToBBSList:) forControlEvents:UIControlEventTouchUpInside];
//            
//            if (i != 2 && i != (300 / aWidth - 1)) {
//                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1, 20)];
//                line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
//                [secondBgView addSubview:line];
//            }
//        }
//    }
    
    if (_myBBSArray.count == 0) {
        
        UIButton *btn = [LTools createButtonWithType:UIButtonTypeRoundedRect frame:CGRectMake(0, 0, secondBgView.width, secondBgView.height) normalTitle:@"您还未添加或创建论坛，点击创建一个" image:nil backgroudImage:nil superView:secondBgView target:self action:@selector(clickToAddBBS)];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
    }
    
    headerView.frame = CGRectMake(0, 0, 320, _mybbsView.bottom);
    
    return headerView;
}


/**
 *  创建热门推荐部分
 */
//- (UIView *)createRecommenView
//{
//    //热门推荐
//    
//    UIView * recommendView = [[UIView alloc]init];
//    recommendView.layer.cornerRadius = 3.f;
//    recommendView.clipsToBounds = YES;
//    //    [headerView addSubview:recommendView];
//    
//    LSecionView *section2 = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:TITLE_MY_HOT_RECOMMEND target:self action:@selector(clickToMore:)];
//    section2.rightBtn.tag = 100;
//    [recommendView addSubview:section2];
//    
//    
//    //推荐列表
//    for (int i = 0; i < _hot_array.count; i ++) {
//        
//        TopicModel *aModel = [_hot_array objectAtIndex:i];
//        
//        LBBSCellView *cell_view = [[LBBSCellView alloc]initWithFrame:CGRectMake(0, section2.bottom + 75 * i, 320, 75) target:self action:@selector(clickToTopicInfo:)];
//        cell_view.backgroundColor = [UIColor whiteColor];
//        [_recommendView addSubview:cell_view];
//        cell_view.tag = 1000 + i;
//        
//        [cell_view setCellWithModel:aModel];
//        
//        if (i < 1) {
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell_view.bottom - 1, 304, 0.5)];
//            line.backgroundColor = COLOR_TABLE_LINE;
//            [_recommendView addSubview:line];
//        }
//    }
//    
//    recommendView.frame = CGRectMake(8, 0, 304, section2.height + 75 * _hot_array.count);
//    
//    //    headerView.frame = CGRectMake(0, 0, 320, _recommendView.bottom + 15);
//    //
//    //    _table.tableHeaderView = headerView;
//    
//    return recommendView;
//}



#pragma mark - delegate

#pragma - mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clickToSearch:nil];
    return NO;
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    //我的论坛
    
    [self getMyBBS];
    
    [self getTopic:0];
    
    [self getRecommenedBBS];
    
    //我的关注热门
    
    [self getTopic:1];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        
        if (indexPath.row >= 1) {
            
            NSArray *arr = (indexPath.section == 0) ? _hot_array : _concern_hot_array;
            
            TopicModel *aModel = [arr objectAtIndex:indexPath.row - 1];
            BBSTopicController *topic = [[BBSTopicController alloc]init];
            
            topic.fid = aModel.fid;
            topic.tid = aModel.tid;
            
            [self PushToViewController:topic WithAnimation:YES];
        }
    }else
    {
        
        if (indexPath.row >= 1) {
            if (_recommend_bbs_array.count > 0 || indexPath.row <= _recommend_bbs_array.count) {
                BBSInfoModel *aModel = [_recommend_bbs_array objectAtIndex:indexPath.row - 1];
                BBSListViewController *list = [[BBSListViewController alloc]init];
                list.bbsId = aModel.id;
                [self PushToViewController:list WithAnimation:YES];
            }
        }
        
    }
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 1){ //推荐的论坛
        
        if (_recommend_bbs_array == 0) {
            return 0.f;
        }
        
        if (indexPath.row == 0) {
            return 40 + 15;
        }
        
        return 75.f;
        
    }
    
    if (indexPath.row == 0) { //论坛热帖
        
        return 40+ 15;//15的空格透明
    }
    return 75;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) { //推荐帖子
        
        if (_hot_array.count == 0) {
            
            return 0;
        }
        
        return _hot_array.count + 1;
        
    }else if (section == 1){ //推荐论坛
        
        if (_recommend_bbs_array.count == 0) {
            return 0.f;
        }
        
        return _recommend_bbs_array.count + 1;
    }
    
    if (_concern_hot_array.count > 0) { //论坛热帖
        
        return _concern_hot_array.count + 1;
    }
    return _concern_hot_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier1= @"hot_topic";
    
     static NSString * identifier3 = @"BBSTableCell";
    
    if (indexPath.section == 1){ //推荐论坛
        
        
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.separatorInset = UIEdgeInsetsZero;
            
            //透明空格
//            UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
//            clearView.backgroundColor = [UIColor clearColor];
//            [cell addSubview:clearView];
            
            LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(8, 15, 304, 40) title:TITLE_RECOMMEND_BBS target:self action:@selector(clickToMore:)];
//            section.rightBtn.hidden = YES;
            section.rightBtn.tag = 999;
            [cell addSubview:section];
            section.layer.cornerRadius = 3.f;
            
            return cell;
        }
        
        static NSString * identifier2 = @"JoinBBSCell";
        
        JoinBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinBBSCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
//        cell.separatorInset = UIEdgeInsetsZero;
        cell.bgView.width = 304;
        cell.bgView.left = 8.f;
        __weak typeof(self)weakSelf = self;
        __weak typeof(JoinBBSCell *)weakCell = cell;
        BBSInfoModel *aModel = [_recommend_bbs_array objectAtIndex:indexPath.row - 1];
        
        __weak typeof(BBSInfoModel *)weakModel = aModel;
        
        [cell setCellDataWithModel:aModel cellBlock:^(NSString *topicId) {
            NSLog(@"join topic id %@",topicId);
//            [weakSelf JoinBBSId:topicId cell:weakCell];
            [weakSelf JoinBBSId:weakModel cell:weakCell];
            
        }];
        
        if (indexPath.row == _recommend_bbs_array.count) {
            cell.bottomLine.hidden = YES;
            
            cell.bgView.layer.cornerRadius = 3.f;
        }else
        {
            cell.bottomLine.hidden = NO;
            cell.bgView.layer.cornerRadius = 0.f;
        }
        
        cell.bottomLine.backgroundColor = COLOR_TABLE_LINE;
        
        return cell;
    }
    
    //========== 我的论坛热帖 和 热门推荐
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

        cell.separatorInset = UIEdgeInsetsZero;
        //透明空格
        UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
        clearView.backgroundColor = [UIColor clearColor];
        [cell addSubview:clearView];
        
        NSString *title = (indexPath.section == 0) ? TITLE_MY_HOT_RECOMMEND : TITLE_MY_CONCERN_HOT;
        int tag = (indexPath.section == 0) ? 100 : 101;
        
        LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(8, clearView.bottom, 304, 40) title:title target:self action:@selector(clickToMore:)];
        section.rightBtn.tag = tag;
        [cell addSubview:section];
        
        section.layer.cornerRadius = 3.f;
        
        return cell;
    }
    
    BBSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSTableCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    NSArray *arr = (indexPath.section == 0) ? _hot_array : _concern_hot_array;
    
    if (indexPath.row == arr.count) {
        
        cell.bgView.layer.cornerRadius = 3.f;
    }else
    {
        cell.bgView.layer.cornerRadius = 0.f;
    }
    TopicModel *aModel = [arr objectAtIndex:indexPath.row - 1];
    [cell setCellWithModel:aModel];
    
    if (indexPath.row == arr.count) {
        cell.bottomLine.hidden = YES;
    }else
    {
        cell.bottomLine.hidden = NO;
    }
    cell.bottomLine.backgroundColor = COLOR_TABLE_LINE;
    
    return cell;
    
}


@end

