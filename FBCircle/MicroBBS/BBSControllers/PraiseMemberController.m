//
//  PraiseMemberController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "PraiseMemberController.h"
#import "PraiseMemberCell.h"
#import "GRXX4ViewController.h"

@interface PraiseMemberController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
}


@end

@implementation PraiseMemberController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    self.titleLabel.text = @"称赞者";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:_table];
    
    
    //获取称赞者
    
    [_table showRefreshHeader:YES];
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

#pragma mark - 网络请求

/**
 *  评论列表
 */
- (void)getZanList
{
    __weak typeof(RefreshTableView *)weakTable = _table;
    NSString *url = [NSString stringWithFormat:FBCIRCLE_TOPIC_ZAN_LIST,self.tid,_table.pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            NSArray *data = [dataInfo objectForKey:@"data"];
//            int total = [[dataInfo objectForKey:@"total"]integerValue];
            
            int total;
            if (data.count < L_PAGE_SIZE) {
                total = 0;
            }else
            {
                total = _table.pageNum;
            }
            
            [weakTable reloadData:data total:total];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
        
        int erroCode = [[failDic objectForKey:@"errcode"]integerValue];
        if (erroCode == 2) {
            
        }
    }];
}


#pragma mark - 视图创建

#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getZanList];
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getZanList];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aZan = [_table.dataArray objectAtIndex:indexPath.row];
    GRXX4ViewController *_grc=[[GRXX4ViewController alloc]init];
    _grc.passUserid=[aZan objectForKey:@"uid"];
    [self PushToViewController:_grc WithAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    static NSString * identifier= @"cell1";
    
    PraiseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[PraiseMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *aZan = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell.aImageView sd_setImageWithURL:[NSURL URLWithString:[aZan objectForKey:@"head"]] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    
    cell.aTitleLabel.text = [aZan objectForKey:@"username"];
    cell.bottomLine.left = cell.aImageView.left;
    cell.bottomLine.width = DEVICE_WIDTH;
    
    return cell;
    
}


@end
