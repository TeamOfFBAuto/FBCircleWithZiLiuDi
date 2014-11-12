//
//  MyBBSViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyBBSViewController.h"
#import "SendPostsViewController.h"
#import "BBSListViewController.h"
#import "CreateNewBBSViewController.h"
#import "MyBBSCell.h"
#import "LTools.h"
#import "BBSInfoModel.h"
#import "ClassifyBBSController.h"

@interface MyBBSViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *joinArray;//加入的论坛
    NSArray *createArray;//创建的论坛
    int createNum;
    int joinNum;
    BOOL _needRefresh;
    
    LTools *tool_tmp;
    
    UIButton *btn_create;//创建论坛
    UIButton *btn_join;//加入论坛
}

@end

@implementation MyBBSViewController

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
    
    if (_needRefresh) {
        
        [_table showRefreshNoOffset];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"我的论坛";
    
    self.view.backgroundColor = RGBCOLOR(244, 245, 248);
    
    self.rightImageName = @"+";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _table.refreshDelegate = nil;
    _table.dataSource = nil;
    _table = nil;
}

#pragma mark - 事件处理

- (void)updateBBS:(NSNotification *)sender
{
    _needRefresh = YES;
}

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    
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
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    [self PushToViewController:classify WithAnimation:YES];
}

#pragma mark - 网络请求

- (void)getDataWithClass
{
    __weak typeof(_table)weakTable = _table;
    __weak typeof(self)weakSelf = self;

    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MINE,[SzkAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    tool_tmp = tool;
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
//            createNum = [[dataInfo objectForKey:@"createnum" ]integerValue];
//            joinNum = [[dataInfo objectForKey:@"joinnum" ]integerValue];
            
            NSArray *join = [dataInfo objectForKey:@"join"];
            NSArray *create = [dataInfo objectForKey:@"create"];
            
            NSMutableArray *arr_join = [NSMutableArray arrayWithCapacity:join.count];
            NSMutableArray *arr_create = [NSMutableArray arrayWithCapacity:create.count];
            
            //status:论坛状态（0:正常   1:删除    2:审核中）
            for (NSDictionary *aDic in join) {
                
                int status = [[aDic objectForKey:@"forum_status"]integerValue];
                if (status == 0) {
                    
                    BBSInfoModel *info = [[BBSInfoModel alloc]initWithDictionary:aDic];
                    
                    if (info.name.length > 0) {
                        [arr_join addObject:info];
                    }
                }
            }
            
            for (NSDictionary *aDic in create) {
                
                int status = [[aDic objectForKey:@"forum_status"]integerValue];
                if (status == 0) {
                    [arr_create addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
                }
            }
            
            [weakSelf reloadDataWithCreateArr:arr_create joinArr:arr_join total:total];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
        [weakTable loadFail];
        
        int errcode = [[failDic objectForKey:@"errcode"]integerValue];
        
        if (errcode) {
            
            [weakSelf reloadDataWithCreateArr:nil joinArr:nil total:0];
        }
    }];
}

//成功加载
- (void)reloadDataWithCreateArr:(NSArray *)arr_create joinArr:(NSArray *)arr_join total:(int)totalPage
{
    
    if (_table.pageNum < totalPage) {
        
        _table.isHaveMoreData = YES;
    }else
    {
        _table.isHaveMoreData = NO;
    }
    
    if (_table.isReloadData) {
        
        createArray = arr_create;
        joinArray = arr_join;
        
    }else
    {
        NSMutableArray *newArr_create = [NSMutableArray arrayWithArray:createArray];
        [newArr_create addObjectsFromArray:arr_create];
        createArray = newArr_create;
        
        NSMutableArray *newArr_join = [NSMutableArray arrayWithArray:joinArray];
        [newArr_join addObjectsFromArray:arr_join];
        joinArray = newArr_join;
    }
    
    createNum = createArray.count;
    joinNum = joinArray.count;
    
    [_table performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}

#pragma mark - 视图创建

- (UIButton *)createNewButtonWithTitle:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [LTools createButtonWithType:UIButtonTypeRoundedRect frame:CGRectMake(0, 0, self.view.width, 40) normalTitle:title image:nil backgroudImage:nil superView:nil target:self action:selector];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    return btn;
}

#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getDataWithClass];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getDataWithClass];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSInfoModel *aModel;
    if (indexPath.section == 0) {
        
        if (indexPath.row > createArray.count - 1) {
            return;
        }
        aModel = [createArray objectAtIndex:indexPath.row];
        
    }else
    {
        if (indexPath.row > joinArray.count - 1) {
            return;
        }
        aModel = [joinArray objectAtIndex:indexPath.row];
    }
    
    BBSListViewController *list = [[BBSListViewController alloc]init];
    list.bbsId = aModel.fid;
    [self PushToViewController:list WithAnimation:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
    header.backgroundColor = [UIColor colorWithHexString:@"f6f7f9"];
    
    NSString *title1 = [NSString stringWithFormat:@"%@ (%d)",@"我创建的论坛",createNum];
    NSString *title2 = [NSString stringWithFormat:@"%@ (%d)",@"我加入的论坛",joinNum];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, header.height)];
    titleLabel.text = (section == 0) ? title1 : title2;
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.tag = 100 + section;
    [header addSubview:titleLabel];
    
    return header;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (!_table.isReloadData &&createArray.count == 0) {
            return 1;
        }
        
        return createArray.count;
    }
    
    if (!_table.isReloadData && joinArray.count == 0) {
        return 1;
    }
    return joinArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (!_table.isReloadData && createArray.count == 0) {
            
            
            static NSString *btn_create_identify = @"create";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btn_create_identify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btn_create_identify];
               btn_create = [self createNewButtonWithTitle:@"还未创建论坛,我来创建一个" action:@selector(clickToAddBBS)];
                [cell addSubview:btn_create];
            }
            
            return cell;
        }
    }else
    {
        if (!_table.isReloadData && joinArray.count == 0) {
            
            
            static NSString *btn_join_identify = @"join";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btn_join_identify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btn_join_identify];
                btn_join = [self createNewButtonWithTitle:@"您还未加入论坛,点击加入一个" action:@selector(clickToClassifyBBS)];
                [cell addSubview:btn_join];
            }
            
            return cell;
        }
    }
    
    
    static NSString * identifier = @"MyBBSCell";
    
    MyBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BBSInfoModel *aModel;
    if (indexPath.section == 0) {
        
        if (!_table.isReloadData && createArray.count == 0) {
//            btn_create = [self createNewButtonWithTitle:@"您还未创建论坛,点击创建一个" action:@selector(clickToAddBBS)];
//            [cell addSubview:btn_create];
//            cell.arrowImage.hidden = YES;
        }else
        {
            aModel = [createArray objectAtIndex:indexPath.row];
            cell.arrowImage.hidden = NO;
            
//            if (btn_create) {
//                [btn_create removeFromSuperview];
//                btn_create = nil;
//            }
        }
        
    }else
    {
        
        if (!_table.isReloadData && joinArray.count == 0) {
//            btn_join = [self createNewButtonWithTitle:@"您还未加入论坛,点击加入一个" action:@selector(clickToClassifyBBS)];
//            [cell addSubview:btn_join];
//            cell.arrowImage.hidden = YES;
        }else
        {
            aModel = [joinArray objectAtIndex:indexPath.row];
            
//            cell.arrowImage.hidden = NO;
//            if (btn_join) {
//                [btn_join removeFromSuperview];
//                btn_join = nil;
//            }
        }
    }
    
    if (aModel) {
        [cell setCellWithModel:aModel];
    }
    
    return cell;
    
}


@end
