//
//  HotTopicViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "HotTopicViewController.h"
#import "BBSTopicController.h"
#import "LTools.h"
#import "HotTopicCell.h"
#import "TopicModel.h"

@interface HotTopicViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
    
    BOOL _needUpdate;//需要更新
}

@end

@implementation HotTopicViewController

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
    if (_needUpdate) {
        [_table showRefreshNoOffset];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title;
    if (self.data_Style == 0) {
        
        title = @"热门推荐";
    }else
    {
        title = @"热门帖子";
    }
    
    self.titleLabel.text = title;
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
    
    _table.backgroundColor = self.view.backgroundColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _table.refreshDelegate = nil;
    _table.dataSource = nil;
    _table = nil;
}

#pragma mark - 事件处理

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    
}


#pragma mark - 网络请求

- (void)getTopic
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;

    NSString *url;
    if (self.data_Style == 0) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_HOT,_table.pageNum,L_PAGE_SIZE];//热门帖子
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_MYJOIN,[SzkAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];//关注热门帖子
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];

    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        NSArray *dataInfo;
        int total = 0;
        
        if (self.data_Style == 0) {
           
            dataInfo = [result objectForKey:@"datainfo"];
            
            if (dataInfo.count < L_PAGE_SIZE) {
                total = 0;
            }else
            {
                total = _table.pageNum + 1;
            }
            
        }else if (self.data_Style == 1){
            
            NSDictionary *dataDic = [result objectForKey:@"datainfo"];
            dataInfo = [dataDic objectForKey:@"data"];
            total = [[dataDic objectForKey:@"total"]integerValue];
            
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
        for (NSDictionary *aDic in dataInfo) {
            
            if ([aDic isKindOfClass:[NSDictionary class]]) {
                TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
        }
        [weakTable reloadData:arr total:total];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:weakSelf.view];
        
        [weakTable loadFail];
    }];
}


#pragma mark - 视图创建


#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getTopic];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getTopic];

}
/**
 *  帖子详情(从热门推荐进入)
 */

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    
    [topic updateBlock:^(BOOL update, NSDictionary *userInfo) {
        
        _needUpdate = update;
    }];
    
    [self PushToViewController:topic WithAnimation:YES];

}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75 + 2;
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
    static NSString * identifier = @"HotTopicCell";
    
    HotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HotTopicCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell setCellWithModel:aModel];
    
    cell.bottomLine.backgroundColor = COLOR_TABLE_LINE;
    
    return cell;
    
}
@end
