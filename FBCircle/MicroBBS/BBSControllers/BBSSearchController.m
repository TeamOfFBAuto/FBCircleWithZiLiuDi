//
//  BBSSearchController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSSearchController.h"
#import "BBSListViewController.h"
#import "BBSSearchNoResultController.h"
#import "BBSTopicController.h"
#import "BBSInfoModel.h"
#import "SearchBBSCell.h"
#import "TopicModel.h"

#define SEARCH_HISTORY @"search_history"//搜索历史词

@interface BBSSearchController ()<UITableViewDataSource,RefreshDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    RefreshTableView *_table;
    UITableView *_historyTable;//显示历史搜索词
    
    NSArray *_historyArray;
    UIView *navigationView;
    LSearchView *searchView;
    
    LMoveView *move;
    
    NSString *keyword;
    
    int search_tag;// 1 搜索论坛 2 搜索帖子
    BOOL push_tiezi;//是否帖子
    
    UITapGestureRecognizer *tap;
}

@end

@implementation BBSSearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [navigationView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:navigationView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightString = @"取消";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    [self.my_right_button addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    self.my_right_button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //搜索
    [self createSearchView];
    
    //切换
    
    [self createSwapView];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_table];
    
    //数据展示table
    _historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 20) style:UITableViewStylePlain];
    _historyTable.delegate = self;
    _historyTable.dataSource = self;
    _historyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _historyTable.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_historyTable];
    
    
    _historyArray = [self getHistory];
    
    //创建清空历史记录按钮
    
    [self createMoveView];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHidden)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _table.refreshDelegate = nil;
    _table.delegate = nil;
    _table.dataSource = nil;
    
    _historyTable.delegate = nil;
    _historyTable.dataSource = nil;
    _historyTable = nil;
    navigationView = nil;
    searchView = nil;
    move = nil;
}

#pragma mark - 事件处理

- (void)tapToHidden
{
    [searchView.searchField resignFirstResponder];
}

//搜索无结果
- (void)clickToSearchNoResult:(UIButton *)sender
{
    BBSSearchNoResultController *noResult = [[BBSSearchNoResultController alloc]init];
    [self PushToViewController:noResult WithAnimation:YES];
}

- (void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSwap:(LButtonView *)sender
{
    sender.selected = YES;
    if (sender.tag == 100) {
        NSLog(@"微论坛");
        LButtonView *btn = (LButtonView *)[self.view viewWithTag:101];
        btn.selected = NO;
        search_tag = 1;
        
    }else
    {
        NSLog(@"搜帖子");
        LButtonView *btn = (LButtonView *)[self.view viewWithTag:100];
        btn.selected = NO;
        search_tag = 2;
    }
    //只要切换 pageNum置为 1
    _table.pageNum = 1;
    
    [self searchKeyword:keyword isClear:YES];
}

- (void)clickToClearHistory:(UIButton *)sender
{
    NSLog(@"clear");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确定清空历史搜索词" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
}

#pragma mark - 网络请求

- (NSArray *)getHistory
{
    return  [[NSUserDefaults standardUserDefaults] arrayForKey:SEARCH_HISTORY];
}

- (void)recordHistoryKeyword:(NSString *)aKeyword
{
    if ([aKeyword isEqualToString:@""] || aKeyword == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults arrayForKey:SEARCH_HISTORY]];
    
    if ([arr containsObject:aKeyword]) {
        [arr removeObject:aKeyword];
    }
    [arr insertObject:aKeyword atIndex:0];
    
    [defaults setObject:arr forKey:SEARCH_HISTORY];
    [defaults synchronize];
}

- (void)clearHistory
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:SEARCH_HISTORY];
}


/**
 *  搜索
 *
 *  @param aKeyword 关键词
 *  @param isClear  是否清空dataArray 每次重新搜索的时、刷新时
 */
- (void)searchKeyword:(NSString *)aKeyword isClear:(BOOL)isClear
{
    
    
    NSLog(@"|%@|",[aKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    
    if (aKeyword == nil || [aKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        return;
    }
    
    keyword = aKeyword;
    
    [self recordHistoryKeyword:aKeyword];
    
    NSString *url;

    if (search_tag == 1) {
        NSLog(@"论坛");
        
        push_tiezi = NO;
        url = [NSString stringWithFormat:FBCIRCLE_SEARCH_BBS,keyword,_table.pageNum,L_PAGE_SIZE];
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_SEARCH_TOPIC,keyword,_table.pageNum,L_PAGE_SIZE];
        NSLog(@"帖子");
        
        push_tiezi = YES;
    }
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]integerValue];
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *aDic in data) {
            if (search_tag == 1) {
                [arr addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];

            }else
            {
                [arr addObject:[[TopicModel alloc]initWithDictionary:aDic]];
            }
        }
        
        if (isClear) {
            [_table.dataArray removeAllObjects];
        }
        
        [weakTable reloadData:arr total:total];
        
        [weakTable reloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [weakTable loadFail];
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        int erroCode = [[failDic objectForKey:@"errcode"]integerValue];
        if (erroCode == 2) {
            
            [_table.dataArray removeAllObjects];
            [weakTable reloadData:nil total:0];
            
            [weakSelf clickToSearchNoResult:nil];
        }
        
    }];
}

#pragma mark - 视图创建

- (void)createSearchView
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 - 50, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar addSubview:navigationView];
    
    __weak typeof(self)weakSelf = self;
    //搜索
    searchView = [[LSearchView alloc]initWithFrame:CGRectMake(10, (44 - 30)/2.0, 530/2.f, 30) placeholder:@"请输入关键词搜索微论坛" logoImage:[UIImage imageNamed:@"search"] maskViewShowInView:nil searchBlock:^(SearchStyle actionStyle, NSString *searchText) {
        if (actionStyle == Search_Search) {
            
            //清空按钮hidden
            
            [move removeFromSuperview];
            
            //历史搜索词table 消失
            
            [_historyTable removeFromSuperview];
            
            [weakSelf searchKeyword:searchText isClear:YES];
            
            tap.enabled = NO;
            
        }else if (actionStyle == Search_BeginEdit){
         
            tap.enabled = YES;
        }else if (actionStyle == Search_Cancel){
            
            tap.enabled = NO;
        }
        
    }];
    
    [navigationView addSubview:searchView];
}

- (void)createSwapView
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.image = [UIImage imageNamed:@"BBS-kuang"];
    [self.view addSubview:bgView];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, 160, 43) leftImage:nil rightImage:nil title:@"搜微论坛" target:self action:@selector(clickToSwap:) lineDirection:Line_No];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 0.f;
    btn.backgroundColor = [UIColor colorWithHexString:@"eff2f2"];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.selcted_TitleColor = [UIColor colorWithHexString:@"627bbd"];
    btn.selected = YES;
    
    search_tag = 1;//默认初始值
    
    
    btn.tag = 100;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.right, 0, 0.5, 43)];
    line.image = [UIImage imageNamed:@"line"];
    line.contentMode = UIViewContentModeCenter;
    [self.view addSubview:line];
    
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(line.right, 0, 160, 43) leftImage:nil rightImage:nil title:@"搜帖子" target:self action:@selector(clickToSwap:) lineDirection:Line_No];
    [self.view addSubview:btn2];
    btn2.layer.cornerRadius = 0.f;
    btn2.backgroundColor = [UIColor colorWithHexString:@"eff2f2"];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.tag = 101;
    btn2.selcted_TitleColor = [UIColor colorWithHexString:@"627bbd"];
}

- (void)createMoveView
{
    move = [[LMoveView alloc]initWithFrame:CGRectMake(0, self.view.height - 45 - 20 - 44, 320, 44)];
    [self.view addSubview:move];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.image = [UIImage imageNamed:@"BBS-kuang-up"];
    [move addSubview:bgView];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 1, move.width, move.height - 1) leftImage:Nil rightImage:Nil title:@"清空历史记录" target:self action:@selector(clickToClearHistory:) lineDirection:Line_Up];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor colorWithHexString:@"eff2f2"];
    
    [move addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn.titleLabel setTextColor:[UIColor colorWithHexString:@"b7b7b7"]];
    
    [searchView.searchField becomeFirstResponder];
    
}

#pragma mark - delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _historyTable) {
        
        [searchView.searchField resignFirstResponder];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self clearHistory];
        
        _historyArray = nil;
        [_historyTable reloadData];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:NSStringFromClass([LButtonView class])]) {
        return NO;
    }
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SearchBBSCellContentView"]) {
        return NO;
    }
    
    return  YES;
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self searchKeyword:keyword isClear:YES];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self searchKeyword:keyword isClear:NO];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (push_tiezi == NO) {
        BBSInfoModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
        BBSListViewController *list = [[BBSListViewController alloc]init];
        list.bbsId = aModel.id;
        [self PushToViewController:list WithAnimation:YES];
        
    }else
    {
        TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
        
        BBSTopicController *topic = [[BBSTopicController alloc]init];
        topic.tid = aModel.tid;
        topic.fid = aModel.fid;
        [self PushToViewController:topic WithAnimation:YES];
    }
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyword_ = [_historyArray objectAtIndex:indexPath.row];
    NSLog(@"搜搜 %@",keyword_);
    
    searchView.searchField.text = keyword_;
    [searchView.searchField resignFirstResponder];
    
    //清空按钮hidden
    
    [move removeFromSuperview];
    
    //历史搜索词table 消失
    
    [_historyTable removeFromSuperview];
    
    [self searchKeyword:keyword_ isClear:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    
//    return line;
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _historyTable) {
        return _historyArray.count;
    }
    return [_table.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTable) {
        static NSString *identifier = @"history";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height - 1, 320, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
            [cell.contentView addSubview:line];
        }
        
        cell.textLabel.text = [_historyArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    if (search_tag == 2) {
        
        static NSString *identifier = @"tiezi";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 74, 320, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
            line.tag = 100;
            
            [cell.contentView addSubview:line];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        
        TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = aModel.title;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 2;
        
        NSString *content = aModel.content;        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.attributedText = [LTools attributedString:content keyword:keyword color:[UIColor colorWithHexString:@"637cbc"]];
        
        return cell;
    }
    
    static NSString * identifier = @"SearchBBSCell";
    
    SearchBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchBBSCell" owner:self options:nil]objectAtIndex:0];
        
        NSLog(@"cell %@",cell);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height - 1, 320, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [cell.contentView addSubview:line];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.separatorInset = UIEdgeInsetsZero;
    BBSInfoModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aModel];
    
    return cell;
    
}


@end
