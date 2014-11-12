//
//  ClassifyBBSController_Sub.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ClassifyBBSController_Sub.h"
#import "MicroBBSInfoController.h"
#import "BBSSearchController.h"
#import "JoinBBSCell.h"
#import "BBSInfoModel.h"
#import "BBSListViewController.h"

@interface ClassifyBBSController_Sub ()<UISearchBarDelegate,RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    BOOL _needRefresh;//是否需要更新
}

@end

@implementation ClassifyBBSController_Sub

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
    if (_needRefresh) {
    
        [_table showRefreshNoOffset];
        
        _needRefresh = NO;
    }
  
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.navigationTitle;
    
    self.view.backgroundColor = RGBCOLOR(236, 237, 240);
    
    //搜索
    [self createSearchView];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 45 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateJoinState:) name:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _table.refreshDelegate = nil;
    _table.dataSource = nil;
    _table = nil;
}

#pragma mark - 事件处理

- (void)updateJoinState:(NSNotification *)sender
{
    _needRefresh = YES;
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

#pragma mark - 网络请求

- (void)getDataWithClassId:(NSString *)classId
{
    __weak typeof(_table)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_CLSSIFYBBS_SUB,[SzkAPI getAuthkey],_table.pageNum,L_PAGE_SIZE,classId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            NSArray *data = [dataInfo objectForKey:@"data"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in data) {
                
                [arr addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
            }
            
            [weakTable reloadData:arr total:total];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
    }];
}

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
- (void)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    bar.placeholder = @"搜索";
    bar.layer.borderWidth = 2.f;
    bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    bar.barTintColor = COLOR_SEARCHBAR;
    bar.delegate = self;
    [search_bgview addSubview:bar];
}

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
    
    //请求单个分类下所有论坛
    [self getDataWithClassId:self.class_id];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getDataWithClassId:self.class_id];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSInfoModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    BBSListViewController *list = [[BBSListViewController alloc]init];
    list.bbsId = aModel.id;
    [self PushToViewController:list WithAnimation:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_table.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"JoinBBSCell";
    
    JoinBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(JoinBBSCell *)weakCell = cell;
    
    BBSInfoModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    __weak typeof(BBSInfoModel *)weakModel = aModel;
    [cell setCellDataWithModel:aModel cellBlock:^(NSString *topicId) {
        NSLog(@"join topic id %@",topicId);
        [weakSelf JoinBBSId:weakModel cell:weakCell];
        
//        weakCell.joinButton.selected = YES;
    }];
    
    cell.backgroundColor = RGBCOLOR(236, 237, 240);
    cell.bgView.backgroundColor = RGBCOLOR(236, 237, 240);
    
    cell.bottomLine.backgroundColor = [UIColor colorWithHexString:@"bbbec3"];
    cell.bottomLine.left = 0.f;
    cell.bottomLine.width = self.view.width;
    cell.bottomLine.height = 0.5f;
    
    return cell;
    
}



@end
