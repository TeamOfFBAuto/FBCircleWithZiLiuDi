//
//  GHaoYouFootViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-5-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GHaoYouFootViewController.h"
#import "GRXX4ViewController.h"

@interface GHaoYouFootViewController ()

@end

@implementation GHaoYouFootViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //适配ios7navigationBar坐标
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    
    
    //设置navigation左右按钮格式类型
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeDelete];
    
    
    //设置navigation的titile
    self.navigationItem.title = @"好友足迹";
    
    
    //分配内存
    _wenzhangArray = [NSMutableArray arrayWithCapacity:1];
    
    
    
    
    
    //主tableveiw
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, iPhone5?DEVICE_HEIGHT-64:DEVICE_HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.sectionFooterHeight = 0.0f;//设置Grouped类型的tableview的不同section之间的距离
//    _tableView.sectionHeaderHeight = 0.0f;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//设置分割线风格
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
//    UIView *v1 = [[UIView alloc]initWithFrame:CGRectZero];
//    v1.frame = CGRectMake(0, 0, 320, 6);
//    v1.backgroundColor = RGBCOLOR(229, 229, 229);
//    [self.view addSubview:v1];
    
    //顶部黑条
 
    
    
    
    
    //下拉刷新
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_tableView.bounds.size.height, DEVICE_WIDTH, _tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    _currentPage = 1;
    _isupMore = NO;//是否为上提加载
    _isUpMoreSuccess = NO;//上提加载是否成功
    
    
    
    //上提加载更多
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    _upMoreView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    _upMoreView.type = 1;
    _upMoreView.hidden = YES;
    [view addSubview:_upMoreView];
    
    _tableView.tableFooterView = view;
    
    
    //请求网络数据 文章数据 和 用户信息
    [self prepareNetDataWithPage:1];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 设置头像点击block
-(void)faceViewClickdBlock{
    
    GRXX4ViewController *Grxx3Vc = [[GRXX4ViewController alloc]init];
    Grxx3Vc.passUserid = self.userId;
    Grxx3Vc.personModel = self.userModel;
    Grxx3Vc.wenzhangArray = self.wenzhangArray;//用于显示个人足迹的图片
    [self.navigationController pushViewController:Grxx3Vc animated:YES];
    
}




#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }else{
        NSArray *arr = self.wenzhangTimeArray[section -1];
        
        num = arr.count;
        
        NSLog(@"%d",num);
        NSLog(@"%d",self.wenzhangArray.count);
        
    }
    
    return num;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GmyFootCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GmyFootCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isHaoyou = YES;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        //加载个人信息顶部view
        [cell loadRow0CutomViewWithModel:self.userModel];
        
    }else{
        //加载文章视图 并 填充数据
        cell.isHaoyou = YES;
        [cell loadCutomViewWithNetData:self.wenzhangTimeArray[indexPath.section-1] indexPath:indexPath];
        
        
    }
    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_tmpCell) {
        _tmpCell = [[GmyFootCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tmp"];
    }
    
    CGFloat height = 0.0f;
    if (indexPath.row == 0 && indexPath.section == 0) {//个人topview 头像 个性签名
        height = [_tmpCell loadRow0CutomViewWithModel:self.userModel];;
    }else{
        height = [_tmpCell loadCutomViewWithNetData:self.wenzhangTimeArray[indexPath.section - 1] indexPath:indexPath];
    }
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSLog(@"%d",self.wenzhangTimeArray.count);
    
    return self.wenzhangTimeArray.count +1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat num = 0.0f;
    if (section == 0) {
        num = 0.1;
    }else{
        num = 24;
    }
    return num;
}



//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //设置不同时间文章之间的距离
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 24)];
//    view.backgroundColor = [UIColor redColor];
//    
//    
//    return view;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 24)];
    view.backgroundColor = [UIColor whiteColor];


    return view;


}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        FBCircleModel *wenzhang = self.wenzhangTimeArray[indexPath.section-1][indexPath.row];
        NSLog(@"文章id:%@",wenzhang.fb_tid);
        FBCircleDetailViewController *fbdvc = [[FBCircleDetailViewController alloc]init];
        fbdvc.theModel = wenzhang;
        [self.navigationController pushViewController:fbdvc animated:YES];
    }
    
    
}



#pragma mark - 请求网络数据
-(void)prepareNetDataWithPage:(int)thePage{
    
    
    
    @try {
        _wzRefresh = NO;
        _perRefresh = NO;
        
        NSLog(@"============================%d  %d",_currentPage,thePage);
        
        __weak typeof (self)bself = self;
        
        //请求文章信息=======================================================
//        self.wenzhangModel = [[FBCircleModel alloc]init];
//        [self.wenzhangModel initHttpRequestWithUid:self.userId Page:thePage WithType:2 WithCompletionBlock:^(NSMutableArray *array) {
//            
//            [bself loadWenZhangBlockWithArray:array];
//            
//        } WithFailedBlock:^(NSString *operation) {
//            
//        }];
        //请求文章信息=======================================================
        NSString *zujiStr = @"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=mylist&fromtype=b5eeec0b&authkey=%@&page=%d&fbtype=json&uid=%@";
        NSString* fullURL = [NSString stringWithFormat:zujiStr,[SzkAPI getAuthkeyGBK],_currentPage,self.userId];
        NSLog(@"请求好友足迹接口 : %@",fullURL);
        ASIHTTPRequest * weiBo_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullURL]];
        [weiBo_request setPersistentConnectionTimeoutSeconds:60];
        [weiBo_request startAsynchronous];
        __weak typeof(weiBo_request)wRequest = weiBo_request;
        [wRequest setCompletionBlock:^{
            [self doneLoadingTableViewData];
            NSDictionary * rootObject = [[NSDictionary alloc] initWithDictionary:[weiBo_request.responseData objectFromJSONData]];
            NSString *errcode =[NSString stringWithFormat:@"%@",[rootObject objectForKey:ERRCODE]];
            
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary* userinfo = [rootObject objectForKey:@"weiboinfo"];
                
                NSLog(@"-----%@",userinfo);
                
                NSArray * arr = [ZSNApi sortArrayWith:[userinfo allKeys]];
                NSMutableArray * temp = [NSMutableArray array];
                for (int i = 0;i < arr.count;i++) {
                    NSString * key = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                    FBCircleModel * model = [[FBCircleModel alloc] initWithDictionary:[userinfo objectForKey:key]];
                    [temp addObject:model];
                }
                
                [_wenzhangArray addObjectsFromArray:temp];
                
                [bself loadWenZhangBlockWithArray:_wenzhangArray];
                
            }
            
            
            
        }];
        
        [wRequest setFailedBlock:^{
            [ZSNApi showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
            [self doneLoadingTableViewData];
            [_tableView reloadData];
        }];
        
        
        
        //请求用户信息=======================================================
        
        self.userModel = [[FBCirclePersonalModel alloc]init];
        [self.userModel loadPersonWithUid:self.userId WithBlock:^(FBCirclePersonalModel *model) {
            [bself loadUserDataWithModel:model];
            
        } WithFailedBlcok:^(NSString *string) {
            
        }];
    }
    @catch (NSException *exception) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    @finally {
        
    }
    
    
}



#pragma 请求文章数据block
-(void)loadWenZhangBlockWithArray:(NSMutableArray*)array{
    _wenzhangArrayCount = array.count;//用于判断上提加载更多count是否加加
    
    self.wenzhangTimeArray = [NSMutableArray arrayWithCapacity:1];//分配内存
    
    //判断有没有更多
    if (array.count <20) {
        [_upMoreView stopLoading:3];
    }else{
        [_upMoreView stopLoading:1];
    }
    
    //判断是否为上提加载更多
    if (_isupMore) {//是加载更多的话把请求到的文章加到原来的数组中
        [self.wenzhangArray addObjectsFromArray:(NSArray *)array];
        //判断有没有更多
        if (array.count <20) {
            [_upMoreView stopLoading:3];
        }else{
            [_upMoreView stopLoading:1];
        }
        
    }else{//不是上提加载更多
        self.wenzhangArray = array;
    }
    
    //按文章时间分类的二维数组 self.wenzhangTimeArray
    int count = self.wenzhangArray.count;
    for (FBCircleModel *timeWZ in self.wenzhangArray) {
        timeWZ.time = NO;
        timeWZ.timeStr = [GTimeSwitch testtime:timeWZ.fb_deteline];
    }
    
    
    //找出同一天的文章 放到一个数组里
    for (int i = 0; i<count; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (int j = i+1; j<count; j++) {
            FBCircleModel *wz1 = self.wenzhangArray[i];
            FBCircleModel *wz2 = self.wenzhangArray[j];
            //判断时间
            if ([wz1.timeStr isEqualToString:wz2.timeStr]) {
                //如果相同并且time = NO 就加入数组里
                if (!wz1.time) {
                    [arr addObject:wz1];
                    wz1.time = YES;
                }
                if (!wz2.time) {
                    [arr addObject:wz2];
                    wz2.time = YES;
                }
            }
        }
        
        FBCircleModel *wz1 = self.wenzhangArray[i];
        if (arr.count == 0 && !wz1.time) {//判断一天只有一个文章的情况
            [arr addObject:wz1];
        }
        
        if (arr.count > 0) {
            [self.wenzhangTimeArray addObject:arr];
        }
    }
    
    _isUpMoreSuccess = YES;//上体加载更多的标志位
    
    
    
    //有文章再显示上提加载更多
    if (self.wenzhangArray.count>0) {
        _upMoreView.hidden = NO;
    }else{
        _upMoreView.hidden = YES;
    }
    
    [_tableView reloadData];
    
    
    //数据请求完成之后改变refresh状态
    _wzRefresh = YES;
    if (_wzRefresh && _perRefresh) {
        
        [self doneLoadingTableViewData];
    }
    
   
    NSLog(@"%d",self.wenzhangTimeArray.count);
    
}


#pragma mark - 请求用户信息block
-(void)loadUserDataWithModel:(FBCirclePersonalModel*)model{
    //给属性数据源赋值
    self.userModel = model;
    NSLog(@"%@",self.userModel.person_frontpic);
    
    
    if (self.userModel.person_province == nil) {
        
    }
    [_tableView reloadData];
    
    //数据请求完成之后改变refresh状态
    _perRefresh = YES;
    if (_wzRefresh && _perRefresh) {
        
        
        [self doneLoadingTableViewData];
    }
}





#pragma mark -  下拉刷新代理
-(void)reloadTableViewDataSource{
    _reloading = YES;
}

-(void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
}


#pragma mark - EGORefreshTableHeaderDelegate

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _currentPage = 1;
    _isupMore = NO;
    [self reloadTableViewDataSource];
    [self prepareNetDataWithPage:_currentPage];
    
    
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
    if(_tableView.contentOffset.y > (_tableView.contentSize.height - _tableView.frame.size.height+40)&&_isUpMoreSuccess==YES&&[self.wenzhangTimeArray count]>0)
    {
        [_upMoreView startLoading];
        _isupMore = YES;
        if (_wenzhangArrayCount) {
            _currentPage++;
        }
        _isUpMoreSuccess = NO;
        [self prepareNetDataWithPage:_currentPage];
    }
}







@end
