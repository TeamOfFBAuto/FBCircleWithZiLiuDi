//
//  GmyMessageViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmyMessageViewController.h"


@interface GmyMessageViewController ()

@end

@implementation GmyMessageViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"systemMessageRemind"];
    
    
    
    //分配内存
    self.MessageArray = [NSMutableArray arrayWithCapacity:1];
    
    //适配ios7navigationBar坐标
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    //设置navigation左右按钮格式类型
    
    //设置navigation的titile
    self.titleLabel.text = @"系统通知";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    

    
    
    //主tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, 320, iPhone5?568-64:480-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    
    
    [self.view addSubview:_tableView];
    
    
    
    //下拉刷新

    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_tableView.bounds.size.height, 320, _tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_tableView addSubview:_refreshHeaderView];
    
    
    
    
    
    //上提加载更多
    
    _upMoreView = [[GloadingView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _upMoreView.type = 1;
    _upMoreView.isMessage = YES;
    _upMoreView.backgroundColor = RGBCOLOR(236, 236, 236);
    _tableView.tableFooterView = _upMoreView;

    
    _currentPage = 1;
    _isupMore = NO;//是否为上提加载
    _isUpMoreSuccess = NO;//上提加载是否成功
    _upMoreView.hidden = YES;
    
    
    _hud = [ZSNApi showMBProgressWithText:@"正在加载" addToView:self.view];
    _hud.delegate = self;
    
//    //常用的设置
//    //小矩形的背景色
//    _hud.color = [UIColor clearColor];//这儿表示无背景
//    //显示的文字
//    _hud.labelText = @"Test";
//    //细节文字
//    _hud.detailsLabelText = @"Test detail";
//    //是否有庶罩
//    _hud.dimBackground = YES;
    
    
    
    
    //请求网络数据
    [self prepareNetDataWithPage:1];
    
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 清空按钮
-(void)otherRightTypeButton:(UIButton *)sender
{
    NSLog(@"%s",__FUNCTION__);
    
    if (self.MessageArray.count>0) {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [al show];
    }
    
    
    
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    
    NSLog(@"%d",self.MessageArray.count);
    
    num = self.MessageArray.count;
    return num;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    GmyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[GmyMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    //清除数据
    //[cell clearDataOfCell];
    
    [cell loadView];
    
    //填充数据
    
    NSLog(@"%@",self.MessageArray[indexPath.row]);
    
    [cell dataForCellWithModel:self.MessageArray[indexPath.row]];
    
    
    return cell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    
    NSLog(@"消息数组个数 ：%d",self.MessageArray.count);
    
    
    
    
    FBQuanMessageModel *model = self.MessageArray[indexPath.row];
    
    
    self.wenzhangId = model.totid;//来自文章id
    
    self.messageId = model.detailid;//消息id
    
    NSLog(@"文章id----%@     消息id-----%@",self.wenzhangId,self.messageId);
    
    
    FBCircleDetailViewController *fbdvc = [[FBCircleDetailViewController alloc]init];
    fbdvc.wenzhangid=[NSString stringWithFormat:@"%@",self.wenzhangId];
    fbdvc.xiaoxiid=[NSString stringWithFormat:@"%@",self.messageId];
    fbdvc.flag=[NSString stringWithFormat:@"test"];
    
    [self.navigationController pushViewController:fbdvc animated:YES];
    
    
}






-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 0;
    if (!_tmpCell) {
        _tmpCell = [[GmyMessageTableViewCell alloc]init];
        [_tmpCell loadView];
    }
    height = [_tmpCell dataForCellWithModel:self.MessageArray[indexPath.row]];
    
    return height;
}



#pragma mark -请求网络数据 消息列表
-(void)prepareNetDataWithPage:(int)currentPage{
    
    @try {
        NSString *str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=getalert&authkey=%@&page=%d&ps=10&type=json",[SzkAPI getAuthkey],currentPage];
        
        NSLog(@"请求消息接口：%@",str);
        
        __weak typeof (self)bself = self;
        __weak typeof (_hud)bhud = _hud;
        
        NSURL *url = [NSURL URLWithString:str];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            
            if (data == nil) {
                return ;
            }
            //json字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //消息数组
            NSArray *array  = [dic objectForKey:@"datainfo"];
            
            //判断有没有更多
            if (array.count <10) {
                [_upMoreView stopLoading:3];
            }else{
                [_upMoreView stopLoading:1];
            }
            
            
            
            //装着model的数组
            
            NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:1];
            
            //给消息model属性赋值 然后装到model数组中
            for (NSDictionary *dic in array) {
                
                NSLog(@"%@",dic);
                
                FBQuanMessageModel *model = [[FBQuanMessageModel alloc]init];
                [model setDic:dic];
                
                NSLog(@"%@",model);
                
                NSLog(@"消息id:%@",model.detailid);
                
                NSLog(@"文章id%@",model.totid);
                
                [modelArray addObject:model];
            }
            
            ////用于判断上提加载更多count是否加加
            _messageArrayCount = array.count;
            
            //判断是否为上提加载更多
            if (_isupMore) {//是上提加载更多的话
                if (currentPage==1) {//如果page=1
                    [self.MessageArray removeAllObjects];
                    [_tableView reloadData];
                }
                [self.MessageArray addObjectsFromArray:(NSArray *)modelArray];
                //判断还有没有更多
                if (array.count>0) {
                    [_upMoreView stopLoading:1];
                }else{
                    if (_currentPage ==1) {
                        [_upMoreView stopLoading:1];
                    }else{
                        [_upMoreView stopLoading:3];
                    }
                    
                }
            }else{
                [self.MessageArray removeAllObjects];
                self.MessageArray = modelArray;
                
                NSLog(@"%d",self.MessageArray.count);
                if (self.MessageArray.count>0) {
                    self.rightImageName = @"qingkong_40_40.png";
                    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
                }
                
                
                
            }
            
            
            
            
            _isUpMoreSuccess = YES;
            [self doneLoadingTableViewData];
            
            
            
            
            //设置上提加载更多view是否隐藏
            if (self.MessageArray.count > 0) {
                _upMoreView.hidden = NO;
            }else{
                _upMoreView.hidden = YES;
                
            }
            
            
            
            if (self.MessageArray.count>0) {
                if (_noDataTishiLabel) {
                    [_noDataTishiLabel removeFromSuperview];
                    _noDataTishiLabel = nil;
                }
            }else{
                if (!_noDataTishiLabel) {
                    _noDataTishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 200, 60, 15)];
                    _noDataTishiLabel.font = [UIFont systemFontOfSize:14];
                    _noDataTishiLabel.textColor = [UIColor grayColor];
                    _noDataTishiLabel.text = @"暂无消息";
                    [self.view addSubview:_noDataTishiLabel];
                }
            }
            
            
            
            
            
            [_tableView reloadData];
            
            [bself hudWasHidden:bhud];
            
//            //请求文章原文数据
//            [self prepareContentWenzhangArrayWithArray:self.MessageArray];
            
        }];
        
        
        
       
    }
    @catch (NSException *exception) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    @finally {
        
    }
    
    
    
}




#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //清空消息列表
    //http://quan.fblife.com/index.php?c=interface&a=delalert&authkey=VWFbPFY1B2MAPwZqAnkBbwFzVitfYVJuVDZUdl1sAm1WOQ
    
    
    if (self.MessageArray.count>0) {//有消息的话 可以清空
        
        
        switch (buttonIndex) {
            case 0://取消
                NSLog(@"0");
                break;
            case 1://确认
                NSLog(@"1");
                
                [self.MessageArray removeAllObjects];
                _upMoreView.hidden = YES;
                [_tableView reloadData];
                
                if (!_noDataTishiLabel) {
                    _noDataTishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 200, 60, 15)];
                    _noDataTishiLabel.font = [UIFont systemFontOfSize:14];
                    _noDataTishiLabel.textColor = [UIColor grayColor];
                    _noDataTishiLabel.text = @"暂无消息";
                    [self.view addSubview:_noDataTishiLabel];
                }else{
                    [_noDataTishiLabel removeFromSuperview];
                    _noDataTishiLabel = nil;
                    _noDataTishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 200, 60, 15)];
                    _noDataTishiLabel.font = [UIFont systemFontOfSize:14];
                    _noDataTishiLabel.textColor = [UIColor grayColor];
                    _noDataTishiLabel.text = @"暂无消息";
                    [self.view addSubview:_noDataTishiLabel];
                }
                
                @try {
                    NSString *str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=delalert&authkey=%@",[SzkAPI getAuthkey]];
                    
                    NSLog(@"%@",str);
                    
                    NSURL *url = [NSURL URLWithString:str];
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSString *str = [dic objectForKey:@"errinfo"];
                        
                        
                        [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
                        
                        
                        
                        [self presentAlertWithStr:str];
                    }];
                    
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
                
            default:
                break;
        }
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
    
    
    if(_tableView.contentOffset.y > (_tableView.contentSize.height - _tableView.frame.size.height+40)&&_isUpMoreSuccess==YES&&[self.MessageArray count]>0)
    {
        [_upMoreView startLoading];
        _isupMore = YES;
        if (_messageArrayCount) {
            _currentPage++;
        }
        
        _isUpMoreSuccess = NO;
        [self prepareNetDataWithPage:_currentPage];
    }
}




//alert自动消失
-(void)presentAlertWithStr:(NSString *)str
{
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_alertView show];
}

-(void) performDismiss:(NSTimer *)timer
{
    [_alertView dismissWithClickedButtonIndex:0 animated:NO];
}




@end
