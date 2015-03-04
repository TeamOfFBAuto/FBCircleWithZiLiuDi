//
//  BBSListViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSListViewController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "MicroBBSInfoController.h"
#import "SendPostsViewController.h"
#import "BBSTopicController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSListCell.h"

#import "BBSListCellSingle.h"

#import "SendPostsViewController.h"

#import "BBSInfoModel.h"
#import "TopicModel.h"

@interface BBSListViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    RefreshTableView *_table;
    BBSInfoModel *_aBBSModel;
    NSArray *top_array;//置顶帖子
    
    int _inforum;//是否在论坛中
    
    MBProgressHUD *_loading;
}

@end

@implementation BBSListViewController

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
//    if (_aBBSModel) {
//        
////        [_table showRefreshNoOffset];
//        
//        [self loadNewData];
//        
//    }else
//    {
//        [_table showRefreshHeader:YES];
//    }
    
    [_table showRefreshNoOffset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.navigationTitle;
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _loading = [LTools MBProgressWithText:@"加载中..." addToView:self.view];
    
    //更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTopic:) name:NOTIFICATION_UPDATE_TOPICLIST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateJoinState:) name:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _table.dataSource = nil;
    _table.refreshDelegate = nil;
    _table = nil;
    _aBBSModel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 事件处理

/**
 *  通知更新数据
 *
 */
-(void)updateTopic:(NSNotification *)sender
{
    NSLog(@"创建新帖子成功");
}
/**
 *  通知更新加入论坛状态
 */
- (void)updateJoinState:(NSNotification *)sender
{
    BOOL leave = [[sender.userInfo objectForKey:@"joinState"]boolValue];
    if (leave) {
        
        _inforum = 0;
        
    }else{
        _inforum = 1;
    }
    
    [_table.tableHeaderView removeFromSuperview];
    _table.tableHeaderView = nil;
    _table.tableHeaderView = [self createTableHeaderView];
}

//论坛信息页
- (void)clickToBBSInfo:(UIGestureRecognizer *)tap
{
    MicroBBSInfoController *bbsInfo = [[MicroBBSInfoController alloc]init];
    bbsInfo.bbsId = self.bbsId;
    [self PushToViewController:bbsInfo WithAnimation:YES];
}

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    myBBS.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myBBS animated:YES];
}

- (void)clickToMore:(UIButton *)sender
{   
    HotTopicViewController *hotTopic = [[HotTopicViewController alloc]init];
    hotTopic.data_Style = sender.tag - 100;
    hotTopic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotTopic animated:YES];
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
 *  添加帖子
 */
- (void)clickToAddBBS
{//张少南 这里需要论坛id
    SendPostsViewController * sendPostVC = [[SendPostsViewController alloc] init];
    sendPostVC.fid = self.bbsId;
    [self PushToViewController:sendPostVC WithAnimation:YES];
}

/**
 *  进入置顶帖子
 */
- (void)clickToRecommend:(LButtonView *)btn
{
    TopicModel *aModel = [top_array objectAtIndex:btn.tag - 10];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    [self PushToViewController:topic WithAnimation:YES];
}

- (void)clickJoinBBS:(UIButton *)sender
{
    [self JoinBBSId:self.bbsId];
}


#pragma mark - 网络请求

- (void)getBBSInfoId:(NSString *)bbsId
{
    
    [_loading show:YES];
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(UITableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_INFO,bbsId,[SzkAPI getUid]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];

    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            _aBBSModel = [[BBSInfoModel alloc]initWithDictionary:dataInfo];
            
            if (weakTable.tableHeaderView) {
                [weakTable.tableHeaderView removeFromSuperview];
                weakTable.tableHeaderView = nil;
            }
            
            _inforum = _aBBSModel.inforum;
            
            weakTable.tableHeaderView = [weakSelf createTableHeaderView];
            
            weakSelf.titleLabel.text = _aBBSModel.name;
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [_loading hide:YES];
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
    }];
}

/**
 *  获取帖子列表
 *
 *  @param bbsId 论坛id
 */
- (void)getBBSTopicList:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST,bbsId,[SzkAPI getUid],_table.pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        [_loading hide:YES];
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            
            NSDictionary *data = [dataInfo objectForKey:@"data"];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
               
                NSMutableArray *arr = [NSMutableArray array];
                
                if (weakTable.isLoadMoreData == NO) {
                    
                    NSArray *top = [data objectForKey:@"top"];
                    
                    for (NSDictionary *aDic in top) {
                        TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                        [arr addObject:aModel];
                    }
                    
                    //置顶帖子
                    
                    top_array = [NSArray arrayWithArray:arr];
                }
                
                //正常帖子
                
                NSArray *nomal = [data objectForKey:@"nomal"];
                
                [arr removeAllObjects];
                
                for (NSDictionary *aDic in nomal) {
                    TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                    [arr addObject:aModel];
                }
                
                 [weakTable reloadData:arr total:total];
            }
            
            int inforum = [[dataInfo objectForKey:@"inforum"]intValue];
            
            _inforum = inforum;
            
            NSDictionary *foruminfo = [dataInfo objectForKey:@"foruminfo"];
            
            if ([foruminfo isKindOfClass:[NSDictionary class]]) {
                
//                _aBBSModel = [[BBSInfoModel alloc]initWithDictionary:foruminfo];
//                
//                if (weakTable.tableHeaderView) {
//                    [weakTable.tableHeaderView removeFromSuperview];
//                    weakTable.tableHeaderView = nil;
//                }
//                
//                weakTable.tableHeaderView = [weakSelf createTableHeaderView];
//                weakSelf.titleLabel.text = _aBBSModel.name;
                
            }
           
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [_loading hide:YES];
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:weakSelf.view];
//        [weakTable loadFail];
        
        int errcode = [[failDic objectForKey:@"errcode"]integerValue];
        
        if (errcode == 1) {
            [weakTable reloadData:nil total:0];
        }
        
    }];
}

/**
 *  加入论坛
 *
 *  @param bbsId 论坛id
 */
- (void)JoinBBSId:(NSString *)bbsId
{
//    __weak typeof(self)weakSelf = self;
    
//    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        [LTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
        int errcode = [[result objectForKey:@"errcode"]integerValue];
        if (errcode == 0) {
            
            //加入论坛状态通知
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil userInfo:@{@"joinState":[NSNumber numberWithBool:NO],@"bbsId":self.bbsId}];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
    
}

//- (NSAttributedString *)attributedString:(NSMutableAttributedString *)attibutedString originalString:(NSString *)string AddKeyword:(NSString *)keyword color:(UIColor *)color
//{
//    if (attibutedString == nil) {
//        attibutedString = [[NSMutableAttributedString alloc]initWithString:string];
//    }
//    NSRange range = [string rangeOfString:keyword options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
//    
//    [attibutedString addAttribute:NSForegroundColorAttributeName value:color range:range];
//    
//    return attibutedString;
//}


#pragma mark - 视图创建

/**
 *  论坛基本信息部分
 */

- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
{
    //论坛
    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
    basic_view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 53, 53)];
    imageView.image = [LTools imageForBBSId:_aBBSModel.headpic];
    [basic_view addSubview:imageView];
    
    UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(imageView.right + 10, imageView.top,150, 25) title:_aBBSModel.name font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [basic_view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *memberLabel = [LTools createLabelFrame:CGRectMake(titleLabel.left, titleLabel.bottom,220, 25) title:@"成员" font:12 align:NSTextAlignmentLeft textColor:[UIColor lightGrayColor]];
    [basic_view addSubview:memberLabel];
    memberLabel.textColor = [UIColor colorWithHexString:@"6b7180"];
    
    NSString *str__ = [NSString stringWithFormat:@"版主 %@ | 成员 %@ | 帖子 %@",_aBBSModel.username,_aBBSModel.member_num,_aBBSModel.thread_num];
    
    UIColor *textColor = [UIColor colorWithHexString:@"627bb9"];
    NSAttributedString *contentText;
    if ([_aBBSModel.member_num isEqualToString:_aBBSModel.thread_num]) {
        
        contentText = [LTools attributedString:str__ keyword:_aBBSModel.member_num color:textColor];
    }else
    {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString:[LTools attributedString:nil originalString:str__ AddKeyword:_aBBSModel.member_num color:textColor]];
        
        contentText = [LTools attributedString:attr originalString:str__ AddKeyword:_aBBSModel.thread_num color:textColor];
        
        contentText = [LTools attributedString:attr originalString:str__ AddKeyword:_aBBSModel.username color:textColor];
    }
    
    memberLabel.attributedText = contentText;
    
    
    UIImageView *arrow_image = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - 12 - 8, basic_view.height/2.f - 13/2.f, 8, 13)];
    arrow_image.image = [UIImage imageNamed:@"jiantou"];
    [basic_view addSubview:arrow_image];
    
    return basic_view;
}

//- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
//{
//    //论坛
//    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
//    basic_view.backgroundColor = [UIColor whiteColor];
//    
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 53, 53)];
//    imageView.image = [LTools imageForBBSId:_aBBSModel.headpic];
//    [basic_view addSubview:imageView];
//    
//    UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(imageView.right + 10, imageView.top,150, 25) title:_aBBSModel.name font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
//    [basic_view addSubview:titleLabel];
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    
//    UILabel *memberLabel = [LTools createLabelFrame:CGRectMake(titleLabel.left, titleLabel.bottom,125, 25) title:@"成员" font:12 align:NSTextAlignmentLeft textColor:[UIColor lightGrayColor]];
//    [basic_view addSubview:memberLabel];
//    memberLabel.textColor = [UIColor colorWithHexString:@"6b7180"];
//    
//    NSString *str__ = [NSString stringWithFormat:@"成员 %@ | 帖子 %@",_aBBSModel.member_num,_aBBSModel.thread_num];
//    
//    UIColor *textColor = [UIColor colorWithHexString:@"627bb9"];
//    NSAttributedString *contentText;
//    if ([_aBBSModel.member_num isEqualToString:_aBBSModel.thread_num]) {
//        
//        contentText = [LTools attributedString:str__ keyword:_aBBSModel.member_num color:textColor];
//    }else
//    {
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString:[LTools attributedString:nil originalString:str__ AddKeyword:_aBBSModel.member_num color:textColor]];
//        
//        contentText = [LTools attributedString:attr originalString:str__ AddKeyword:_aBBSModel.thread_num color:textColor];
//    }
//    
//    memberLabel.attributedText = contentText;
//
//    
//    UIImageView *arrow_image = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 12 - 8, basic_view.height/2.f - 13/2.f, 8, 13)];
//    arrow_image.image = [UIImage imageNamed:@"jiantou"];
//    [basic_view addSubview:arrow_image];
//    
//    return basic_view;
//}

/**
 *  置顶帖子部分
 */
- (UIView *)createRecommendViewFrame:(CGRect)aFrame
{
    UIView *recommed_view = [[UIView alloc]init];
    recommed_view.backgroundColor = [UIColor whiteColor];
    recommed_view.layer.cornerRadius = 3.f;
    
    for (int i = 0; i < top_array.count; i ++) {
       
        TopicModel *aModel = [top_array objectAtIndex:i];
        
        LButtonView *btnV = [[LButtonView alloc]initWithFrame:CGRectMake(0, 40 * i, DEVICE_WIDTH - 16, 40) leftImage:[UIImage imageNamed:@"qi"] title:aModel.title target:self action:@selector(clickToRecommend:)];
        [recommed_view addSubview:btnV];
        btnV.tag = 10 + i;
        btnV.titleLabel.font = [UIFont systemFontOfSize:14];
        btnV.line_horizon.backgroundColor = COLOR_TABLE_LINE;
        btnV.line_horizon.height = 1.f;
        
        if (i == top_array.count - 1) {
            btnV.line_horizon.hidden = YES;
        }
    }
    
    aFrame.size.height = 40 * top_array.count;
    recommed_view.frame = aFrame;
    
    return recommed_view;
}
/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    //基本信息部分
    
    UIView *basic_view = [self createBBSInfoViewFrame:CGRectMake(0, 0, DEVICE_WIDTH, 75)];
    [headerView addSubview:basic_view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBBSInfo:)];
    [basic_view addGestureRecognizer:tap];
    
    
    UIView *recommed_view = [self createRecommendViewFrame:CGRectMake(8, basic_view.bottom + 15, DEVICE_WIDTH - 16, 80)];
    [headerView addSubview:recommed_view];
    
    
    UIButton *btn;
    
    if (_inforum == 0) {
        btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(8, recommed_view.bottom + 15, DEVICE_WIDTH - 16, 93 / 2.f) normalTitle:nil image:nil backgroudImage:[UIImage imageNamed:@"jiaruluntan"] superView:headerView target:self action:@selector(clickJoinBBS:)];
        
        self.navigationItem.rightBarButtonItems= nil;
    }else
    {
        self.rightImageName = @"pen";
        
        [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
        
        [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGFloat aheight = 15 + 15;
    if (btn == nil) {
        aheight -= 15;
    }
    
    if (top_array.count == 0) {
        aheight -= 15;
        
        btn.top -= 15;
    }
    
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, basic_view.height + recommed_view.height + btn.height + 15 + aheight);
    
    return headerView;
}

/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableFooterView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}


#pragma mark - delegate


#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    _table.pageNum = 1;
    _table.isReloadData = YES;
    
    [self getBBSInfoId:self.bbsId];
    
    //帖子列表
    
    [self getBBSTopicList:self.bbsId];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    [self getBBSTopicList:self.bbsId];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    topic.modelIndex = indexPath.row;
    [self PushToViewController:topic WithAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
//    if (indexPath.row % 2 == 0) {
//        aModel.title = @"刷卡即可就分开进阿飞说看见阿拉克水煎服科技开发健康多了几分基督教福克斯的积分卡京东方金士顿";
//    }else
//    {
//        aModel.title = @"耍酷卡接口是基督";
//    }
    
    CGFloat aHeight = [LTools heightForText:aModel.title width:280 font:14.f];
    
    aHeight = aHeight > 20.f ? 75.f : 56.f;
    
    
    return aHeight;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier3 = @"BBSListCell";
    
    static NSString * identifierSingle = @"BBSListCellSingle";
    
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    
//    if (indexPath.row % 2 == 0) {
//        aModel.title = @"刷卡即可就分开进阿飞说看见阿拉克水煎服科技开发健康多了几分基督教福克斯的积分卡京东方金士顿";
//    }else
//    {
//        aModel.title = @"耍酷卡接口是基督";
//    }
    
    CGFloat aHeight = [LTools heightForText:aModel.title width:280 font:14.f];
    
    if (aHeight < 20.f) {
        
        
        BBSListCellSingle *cell = [tableView dequeueReusableCellWithIdentifier:identifierSingle];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSListCellSingle" owner:self options:nil]objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0 || indexPath.row == _table.dataArray.count - 1) {
            
            cell.bgView.layer.cornerRadius = 3.f;
            
            if (indexPath.row == 0) {
                cell.upMask.hidden = YES;
                cell.downMask.hidden = NO;
                
                cell.bottomLine.hidden = NO;
                
            }else
            {
                cell.downMask.hidden = YES;
                cell.upMask.hidden = NO;
                cell.bottomLine.hidden = YES;
            }
            
        }else
        {
            cell.bgView.layer.cornerRadius = 0.f;
            cell.bottomLine.hidden = NO;
            
        }
        
        if (_table.dataArray.count == 1) {
            
            cell.bottomLine.hidden = YES;
            cell.downMask.hidden = YES;
        }
        
        
//        cell.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
        [cell setCellDataWithModel:aModel];
        
        cell.bottomLine.backgroundColor = COLOR_TABLE_LINE;
        cell.bottomLine.width = self.view.width - 16;
        
        return cell;
    }
    
    
    BBSListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSListCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0 || indexPath.row == _table.dataArray.count - 1) {
        
        cell.bgView.layer.cornerRadius = 3.f;
        
        if (indexPath.row == 0) {
            cell.upMask.hidden = YES;
            cell.downMask.hidden = NO;
            cell.bottomLine.hidden = NO;
        }else
        {
            cell.downMask.hidden = YES;
            cell.upMask.hidden = NO;
            cell.bottomLine.hidden = YES;
        }
        
    }else
    {
        cell.bgView.layer.cornerRadius = 0.f;
        cell.bottomLine.hidden = NO;
    }
    
//    cell.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
//    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aModel];
    
    cell.bottomLine.backgroundColor = COLOR_TABLE_LINE;
    
    return cell;
    
}

@end
