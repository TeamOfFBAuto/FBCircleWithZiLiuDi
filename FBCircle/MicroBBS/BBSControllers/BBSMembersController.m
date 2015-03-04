//
//  BBSMembersController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSMembersController.h"
#import "PraiseMemberCell.h"
#import "BBSMemberModel.h"
#import "BBSAddMemberViewController.h"
#import "GRXX4ViewController.h"

@interface BBSMembersController ()<RefreshDelegate,UITableViewDelegate>
{
    RefreshTableView *_table;
    LButtonView *btn2;
    BOOL _needRefresh;
}

@end

@implementation BBSMembersController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //更新成员个数
    if (_needRefresh) {
        
        [_table showRefreshNoOffset];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"论坛成员";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = (id)self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self createTableHeaderView];
    
    
    
    
    [self getBBSMembersForBBSId:self.bbs_id];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_BBS_MEMBER object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    self.bbs_id = nil;
    _table.refreshDelegate = nil;
    _table.dataSource = nil;
    _table = nil;
    btn2 = nil;
}

- (void)updateBBS:(NSNotification *)sender
{
    _needRefresh = YES;
}

#pragma mark - 事件处理

//添加成员
- (void)clickToAddMember:(LButtonView *)sender
{
    BBSAddMemberViewController * addMember = [[BBSAddMemberViewController alloc] init];
    addMember.fid = self.bbs_id;
    [self PushToViewController:addMember WithAnimation:YES];
}

#pragma mark - 网络请求

- (void)getBBSMembersForBBSId:(NSString *)bbsId
{
    __weak typeof(LButtonView *)weakBtn = btn2;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_NUMBER,bbsId,_table.pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            
//            int allNum = [[dataInfo objectForKey:@"allnum"]integerValue];
            NSArray *data = [dataInfo objectForKey:@"data"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *aDic in data) {
                BBSMemberModel *aMember = [[BBSMemberModel alloc]initWithDictionary:aDic];
                [arr addObject:aMember];
            }
            
            [weakTable reloadData:arr total:total];
            
            weakBtn.titleLabel.text = [NSString stringWithFormat:@"成员(%d)",_table.dataArray.count];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
    }];
}

#pragma mark - 视图创建

- (UIView *)createTableHeaderView
{
    UIView *header = [[UIView alloc]init];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(12, 15, DEVICE_WIDTH - 24, 43) leftImage:Nil rightImage:[UIImage imageNamed:@"jiantou"] title:@"添加成员" target:self action:@selector(clickToAddMember:) lineDirection:Line_No];
    btn.layer.cornerRadius = 3.f;
    [header addSubview:btn];
    
    NSString *title = [NSString stringWithFormat:@"成员 (%d)",0];
    btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(12, btn.bottom + 15, DEVICE_WIDTH - 24, 43) leftImage:Nil rightImage:Nil title:title target:Nil action:Nil lineDirection:Line_No];
    [header addSubview:btn2];
    btn2.backgroundColor = [UIColor colorWithHexString:@"f5f8f8"];
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(12, btn2.bottom - 2, DEVICE_WIDTH - 24, 2)];
    bottom.backgroundColor = [UIColor colorWithHexString:@"f5f8f8"];
    [header addSubview:bottom];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, btn2.bottom - 1, DEVICE_WIDTH - 24, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [header addSubview:line];
    
    header.frame = CGRectMake(0, 0, DEVICE_WIDTH, btn2.bottom);
    
    return header;
}

#pragma mark - delegate

#pragma mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    [self getBBSMembersForBBSId:self.bbs_id];
}
- (void)loadMoreData
{
    [self getBBSMembersForBBSId:self.bbs_id];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSMemberModel *aMember = [_table.dataArray objectAtIndex:indexPath.row];
    GRXX4ViewController *_grc=[[GRXX4ViewController alloc]init];
    _grc.passUserid=aMember.uid;
    [self PushToViewController:_grc WithAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
//- (UIView *)viewForHeaderInSection:(NSInteger)section
//{
//    
//}
//- (CGFloat)heightForHeaderInSection:(NSInteger)section
//{
//    
//}


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
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == _table.dataArray.count - 1) {
        cell.bgView.layer.cornerRadius = 3.f;
    }else
    {
        cell.bgView.layer.cornerRadius = 0.0;
    }
    
    CGRect imageFrame = cell.aImageView.frame;
    imageFrame.origin.x = 10 + 10;
    cell.aImageView.frame = imageFrame;
    
    CGRect lFrame = cell.aTitleLabel.frame;
    lFrame.origin.x = cell.aImageView.right + 5;
    cell.aTitleLabel.frame = lFrame;
    
    BBSMemberModel *aMember = [_table.dataArray objectAtIndex:indexPath.row];
    
    cell.aTitleLabel.text = aMember.username;
    
    [cell.aImageView sd_setImageWithURL:[NSURL URLWithString:aMember.userface] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    
    
    return cell;
    
}


@end
