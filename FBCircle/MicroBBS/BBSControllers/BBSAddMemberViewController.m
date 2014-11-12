//
//  BBSAddMemberViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSAddMemberViewController.h"
#import "BBSAddMemberCell.h"
#import "FriendAttribute.h"//cell的model
#import "ZSNApi.h"
#import "AddFriendViewController.h"
#import "SuggestFriendViewController.h"
#import "GRXX4ViewController.h"



@interface BBSAddMemberViewController ()
{
    UISearchBar * mySearchBar;
    
    
    UIScrollView * myScrollView;
    
    ///显示选中的名字
    UILabel * name_content_label;
    
    ///选中的用户名
    
    NSString * name_string;
    
    NSMutableArray * name_array;
    ///添加成员请求
    AFHTTPRequestOperation * operation_request;
    
    ///弹出框
    FBQuanAlertView * myAlertView;
}

@end

@implementation BBSAddMemberViewController
@synthesize fid = _fid;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

///添加成员
-(void)submitData:(UIButton *)sender
{
    
    [self showAlertWihtTitle:@"正在添加" WithType:FBQuanAlertViewTypeHaveJuhua isHidden:NO];
    
    NSMutableArray * uids = [NSMutableArray array];
    
    for (FriendAttribute * model in name_array)
    {
        [uids addObject:model.uid];
    }
    
    NSString * uids_string = [uids componentsJoinedByString:@","];
    
    NSLog(@"uids ----  %@",uids_string);
    
    NSString * fullUrl = [NSString stringWithFormat:ADD_MEMBER_URL,[SzkAPI getAuthkey],self.fid,uids_string];
    NSLog(@"添加成员接口 ---  %@",fullUrl);
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    operation_request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __weak typeof(self) bself = self;
    [operation_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSLog(@"allDic ----  %@",allDic);
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            [bself hiddenAlert];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_BBS_MEMBER object:nil userInfo:nil];
            
            [bself.navigationController popViewControllerAnimated:YES];
        }else
        {
            [bself showAlertWihtTitle:[allDic objectForKey:@"errinfo"] WithType:FBQuanAlertViewTypeNoJuhua isHidden:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bself showAlertWihtTitle:@"添加失败，请重试" WithType:FBQuanAlertViewTypeNoJuhua isHidden:YES];
    }];
    
    [operation_request start];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // [self getmyFriendList];
    self.navigationController.navigationBarHidden=NO;
    
//    _mainTabV.frame=CGRectMake(0,44, 320,(iPhone5?568:480)-64);
    _searchTabV.hidden=YES;
    [arrayOfSearchResault removeAllObjects];
    [_searchTabV reloadData];
    _halfBlackV.hidden=YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightImageName=@"tianjiahaoyou-36_36.png";
    self.titleLabel.text=@"添加成员";
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    [self.my_right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.my_right_button.userInteractionEnabled = NO;
    
    myfirendListArr=[NSMutableArray array];
    name_array = [NSMutableArray array];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myScrollView];
    
    name_content_label = [[UILabel alloc] initWithFrame:CGRectMake(15,0,300,44)];
    name_content_label.textAlignment = NSTextAlignmentLeft;
    name_content_label.font = [UIFont systemFontOfSize:14];
    name_content_label.textColor = RGBCOLOR(31,31,31);
    name_content_label.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview:name_content_label];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    mySearchBar.placeholder = @"搜索";
    mySearchBar.delegate = self;
    mySearchBar.layer.borderWidth = 2.f;
    mySearchBar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    mySearchBar.barTintColor = COLOR_SEARCHBAR;
    [self.view addSubview:mySearchBar];
    
    
    //1
    _mainTabV=[[UITableView alloc]initWithFrame:CGRectMake(0,44,320,(iPhone5?568:480)-64-44) style:UITableViewStylePlain];
    [self.view addSubview:_mainTabV];
    [_mainTabV registerClass:[BBSAddMemberCell class] forCellReuseIdentifier:@"identifier"];
    _mainTabV.delegate=self;
    _mainTabV.sectionIndexColor = RGBCOLOR(105,111,131);
    _mainTabV.sectionIndexTrackingBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    _mainTabV.separatorColor=RGBCOLOR(200,198,204);
    _mainTabV.rowHeight = 55;
    _mainTabV.separatorInset = UIEdgeInsetsZero;
    _mainTabV.dataSource=self;
    
    //2
    _searchTabV=[[UITableView alloc]initWithFrame:_mainTabV.frame style:UITableViewStylePlain];
    [self.view addSubview:_searchTabV];
    _searchTabV.delegate=self;
    _searchTabV.separatorColor=RGBCOLOR(200,198,204);
    _searchTabV.dataSource=self;
    
    _searchTabV.hidden=YES;
    _searchTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //3
    _halfBlackV=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, iPhone5?568-75:480-75)];
    _halfBlackV.backgroundColor=RGBCOLOR(246,247,249);
    _halfBlackV.hidden=YES;
    [self.view addSubview:_halfBlackV];
    
    __weak typeof(self) _weakself=self;
    __weak typeof(_mainTabV) _weakmaintabv=_mainTabV;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_weakself getFriendlistFromDocument];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_weakmaintabv reloadData];
            [_weakself getmyFriendList];
        });
    });
    //
    
    ///弹出框
    
    myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,100)];
    myAlertView.center = CGPointMake(160,(iPhone5?568:480)/2-70);
    myAlertView.hidden = YES;
    [self.view addSubview:myAlertView];
    
    
    
    /**
     收到注册信息之后，刷新列表
     */
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getmyFriendList) name:GETFRIENDLIST object:nil];
}

#pragma mark-搜索好友

-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            NSLog(@"取消");
            //            _mainTabV.scrollEnabled=YES;
//            self.navigationController.navigationBarHidden=NO;
//            _mainTabV.frame=CGRectMake(0,44, 320, iPhone5?568-64:480-64);
            _searchTabV.hidden=YES;
            [arrayOfSearchResault removeAllObjects];
            [_searchTabV reloadData];
            _halfBlackV.hidden=YES;
            mySearchBar.text = @"";
            mySearchBar.showsCancelButton = NO;
            [mySearchBar resignFirstResponder];
            
        }
            break;
        case 2:
        {
//            self.navigationController.navigationBarHidden=YES;
//            _mainTabV.frame=CGRectMake(0, 30-7, 320, iPhone5?568-30-64+7:480-30-64+7);
            _halfBlackV.hidden=NO;
            //            _mainTabV.contentOffset=CGPointMake(0, 0);
            //            _mainTabV.scrollEnabled=NO;
            
            NSLog(@"开始编辑");
            
        }
            break;
            
        case 3:
        {
            _searchTabV.hidden=NO;
            _halfBlackV.hidden=YES;
            [mySearchBar resignFirstResponder];
            
            if (arrayOfSearchResault) {
                [arrayOfSearchResault removeAllObjects];
            }else
            {
                arrayOfSearchResault=[NSMutableArray array];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (FriendAttribute *_attribute in myfirendListArr)
                {
                    NSLog(@"点击搜索按钮进行搜索方法 --- %@ ---  %@",_attribute.uname,strname);
                    if ([_attribute.uname rangeOfString:strname].length) {
                        
                        [arrayOfSearchResault addObject:_attribute];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (arrayOfSearchResault.count==0) {
                        
                        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有搜索到相关好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        
                        [alertV show];
                        
                    }else{
                        
                        [_searchTabV reloadData];
                        
                    }
                });
                
            });
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}
#pragma mark--进入推荐好友的界面

-(void)turnToSuggestFriendVC{
    
    SuggestFriendViewController *_matchingVC=[[SuggestFriendViewController alloc]init];
    _matchingVC.str_title=@"推荐好友";
    [self.navigationController pushViewController:_matchingVC animated:YES];
    
}
#pragma mark--tableviewdelegateAndDatesource


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_mainTabV) {
        if (_mainTabV.frame.origin.y!=0) {
            
           // _mainTabV.contentOffset=CGPointMake(0, 0);
            
        }else
        {
            
        }
    }else
    {
        [mySearchBar resignFirstResponder];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView==_mainTabV) {
        
        return 27;
        
    }else{
        
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_mainTabV) {
        NSInteger count=[[arrayinfoaddress objectAtIndex:section] count];
        return count;
    }else
        
    {
        NSInteger count=[arrayOfSearchResault count];
        return count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *stridentifier=@"identifier";
    
    BBSAddMemberCell *cell=[tableView dequeueReusableCellWithIdentifier:stridentifier];
    
    if (!cell) {
        
        cell=[[BBSAddMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stridentifier];
        cell.line_view.hidden = YES;
    }
    cell.delegate = self;
    if (tableView==_mainTabV) {
        
        FriendAttribute *_model=[[arrayinfoaddress objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [cell setFriendAttribute:_model WithType:0];
    
        if ([name_array containsObject:_model])
        {
            cell.selected_button.selected = YES;
        }
    }else{
        
        FriendAttribute *_model=[arrayOfSearchResault objectAtIndex:indexPath.row];
        
        if ([name_array containsObject:_model])
        {
            cell.selected_button.selected = YES;
        }
        
        [cell setFriendAttribute:_model WithType:1];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==_mainTabV)
    {
        /*
        NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
        for(char c = 'A';c<='Z';c++)
            [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
        return toBeReturned;
        */
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            return nil;
        } else
        {
            return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                    [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
        }
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_mainTabV) {
        if ([[arrayinfoaddress objectAtIndex:section] count]==0) {
            return 0;
        }else{
            return 22;
        }
        
    }else{
        
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *aview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    
    if (tableView==_mainTabV)
    {
        
        if ([[arrayinfoaddress objectAtIndex:section] count]==0) {
            return nil;
        }
        
        aview.backgroundColor=[UIColor whiteColor];
        
        aview.image = [UIImage imageNamed:@"bbs_add_member_tiao"];
        
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0.5, 320-24, 24)];
        
        _label.text=[NSString stringWithFormat:@"%c",'A'+section];
        _label.textColor = RGBCOLOR(171,179,188);
        _label.backgroundColor=[UIColor clearColor];
        
//        _label.backgroundColor=RGBCOLOR(250, 250, 250);
        
        [aview addSubview:_label];
    }else{
        aview=nil;
    }
    
    
    return aview;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView==_mainTabV) {
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            return 0;
        }else
        {
            if (title == UITableViewIndexSearch)
            {
                [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
                return -1;
            }else
            {
                NSInteger count = 0;
                for(NSString *character in arrayOfCharacters)
                {
                    if([character isEqualToString:title])
                    {
                        return count;
                    }
                    count ++;
                }
                
                return count;
            }
        }
    }else{
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    
    if (tableView==_mainTabV) {
        
//        FriendAttribute *_model=[[arrayinfoaddress objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        GRXX4ViewController *_grc=[[GRXX4ViewController alloc]init];
//        _grc.passUserid=_model.uid;
//        [self.navigationController pushViewController:_grc animated:YES];
    
        
    }else{
        
        
//        FriendAttribute *_model=[arrayOfSearchResault  objectAtIndex:indexPath.row];
//        GRXX4ViewController *_grc=[[GRXX4ViewController alloc]init];
//        _grc.passUserid=_model.uid;
//        [self.navigationController pushViewController:_grc animated:YES];
        
        FriendAttribute *_model=[arrayOfSearchResault objectAtIndex:indexPath.row];
        
        if ([name_array containsObject:_model])
        {
            [self setSelectedWith:_model isSelected:NO];
        }else
        {
            [self setSelectedWith:_model isSelected:YES];
        }
        
        [self searchFriendWithname:mySearchBar.text thetag:1];
    }
}

#pragma mark--将通讯录保存一下

-(void)getFriendlistFromDocument
{
    NSUserDefaults *standUser=[NSUserDefaults standardUserDefaults];
    NSArray *theArrInfo=[NSArray array];
    [myfirendListArr removeAllObjects];
    theArrInfo=[standUser objectForKey:GETFRIENDLIST];
    
    if (theArrInfo.count==0) {
        
        NSLog(@"没有数据，走网络");
        // [self getmyFriendList];
    }else{
        
        NSLog(@"有数据，走缓存");
        
        for (int i=0; i<theArrInfo.count; i++) {
            NSDictionary *dic=[theArrInfo objectAtIndex:i];
            FriendAttribute *model=[[FriendAttribute alloc] init];
            
            [model setFriendAttributeDic:dic];
            [myfirendListArr addObject:model];
            
        }
        [self documentTestwhat];
        
        
    }
}

#pragma mark---得到网络数据后在这里处理成有二维数组


-(void)testwhat{
    
    
    
    arrayOfCharacters=[NSMutableArray array];
    
    for (char c='A'; c<'Z'; c++) {
        [arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
    }
    [arrayOfCharacters addObject:[NSString stringWithFormat:@"%@",@"#"]];
    
    arrayname=[NSMutableArray array];
    
    
    arrayinfoaddress=[ZSNApi exChangeFriendListByOrder:myfirendListArr];
    
    
    [_mainTabV reloadData];
    NSLog(@"arrayinfo===%@",arrayinfoaddress);
    
}

-(void)documentTestwhat{
    
    
    arrayOfCharacters=[NSMutableArray array];
    
    for (char c='A'; c<'Z'; c++) {
        [arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
    }
    [arrayOfCharacters addObject:[NSString stringWithFormat:@"%@",@"#"]];
    
    arrayname=[NSMutableArray array];
    
    
    arrayinfoaddress=[ZSNApi exChangeFriendListByOrder:myfirendListArr];
    
    
}

#pragma mark--获取好友列表

-(void)getmyFriendList{
    
    
    
    __weak typeof(self) weakself=self;
    
    SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
    NSString *str_url=[NSString stringWithFormat:GETFRIENDLIST,[SzkAPI getAuthkey]];
    
    [_loadRegist SeturlStr:str_url block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
        
        [weakself successLoaddataWithArr:arrayinfo errcode:errcode errorinfo:errorindo];
        
        
        
        
    }];
    
    
    NSLog(@"获取好友列表的接口%@",str_url);
    
}
#pragma mark-获取到好友列表之后，刷新tableview

-(void)successLoaddataWithArr:(NSArray *)theArrInfo errcode:(int)theerrcode errorinfo:(NSString *)theerrinfo{
    
    
    
    if (theerrcode==0) {
        
        [myfirendListArr removeAllObjects];
        [_mainTabV reloadData];
        /**
         *  将请求的网络数组保存到本地
         */
        NSUserDefaults *standdardUser=[NSUserDefaults standardUserDefaults];
        [standdardUser setObject:theArrInfo forKey:GETFRIENDLIST];
        [standdardUser synchronize];
        
        for (int i=0; i<theArrInfo.count; i++) {
            NSDictionary *dic=[theArrInfo objectAtIndex:i];
            FriendAttribute *model=[[FriendAttribute alloc] init];
            
            [model setFriendAttributeDic:dic];
            [myfirendListArr addObject:model];
            
        }
        [self testwhat];
        
    }else{
        
        if (theerrcode==1) {
            //
            //                UIAlertView *alertV=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"现在没有好友哦，赶紧点击右上角添加吧！"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //                [alertV show];
            return ;
            
        }
        
        
        UIAlertView *alertV=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"获取好友列表失败，原因：%@",theerrinfo] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    
}

#pragma mark - BBSADDMemberCellDelegate 选中取消选中

-(void)selectedButtonTap:(BBSAddMemberCell *)cell isSelected:(BOOL)isSelected WithType:(int)aType
{
    
    FriendAttribute * amodel;
    if (aType == 0)///联系人数据
    {
        NSIndexPath * indexPath = [_mainTabV indexPathForCell:cell];
        amodel=[[arrayinfoaddress objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else///搜索到的数据
    {
        NSIndexPath * indexPath = [_searchTabV indexPathForCell:cell];
        amodel = [arrayOfSearchResault objectAtIndex:indexPath.row];
        [self searchBarCancelButtonClicked:mySearchBar];
    }
    [self setSelectedWith:amodel isSelected:isSelected];
    amodel = nil;
}


#pragma mark - 选中取消选中

-(void)setSelectedWith:(FriendAttribute *)_model isSelected:(BOOL)isSelected
{
    if ([name_array containsObject:_model])
    {
        [name_array removeObject:_model];
    }else
    {
        [name_array addObject:_model];
    }
    
    
    for (int i = 0;i < name_array.count;i++) {
        
        FriendAttribute * info = [name_array objectAtIndex:i];
        
        if (i == 0) {
            name_string = [NSString stringWithFormat:@"%@",info.uname];
        }else
        {
            name_string = [NSString stringWithFormat:@"%@、%@",name_string,info.uname];
        }
    }
    
    if (name_array.count == 0)
    {
        name_string = @"";
        
        [self isShow:NO];
    }else
    {
        [self isShow:YES];
    }
    
    name_content_label.text = name_string;
    
    [name_content_label sizeToFit];
    
    name_content_label.center = CGPointMake(name_content_label.center.x,22);
    
    myScrollView.contentSize = CGSizeMake(name_content_label.frame.size.width+50,0);
}


#pragma mark - 显示隐藏选中名字


-(void)isShow:(BOOL)isShow
{
    self.my_right_button.userInteractionEnabled = isShow;
    
    [self.my_right_button setTitleColor:isShow?[UIColor whiteColor]:[UIColor grayColor] forState:UIControlStateNormal];
    
    __weak typeof(_mainTabV) tab_ = _mainTabV;
    
    CGRect tab_frame = _mainTabV.frame;
    
    CGRect scrollView_frame = myScrollView.frame;
    
    float total_height = (iPhone5?568:480)-64;
    
    scrollView_frame.origin.y = isShow?44:0;
    
    tab_frame.origin.y = isShow?88:44;
    
    tab_frame.size.height = isShow?(total_height-88):(total_height-44);
    
    [UIView animateWithDuration:0.4 animations:^{
        tab_.frame = tab_frame;
        
        myScrollView.frame = scrollView_frame;
    } completion:^(BOOL finished) {
        
    }];
    
}



#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    [self searchFriendWithname:searchBar.text thetag:2];
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    searchBar.showsCancelButton = NO;
    
    [self searchFriendWithname:searchBar.text thetag:1];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchFriendWithname:searchBar.text thetag:3];
}



#pragma mark - Show AlertView

-(void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
    
    [alertView show];
}

#pragma mark - Show hidden FBQuanAlert

-(void)showAlertWihtTitle:(NSString *)title WithType:(FBQuanAlertViewType)theType isHidden:(BOOL)hidden
{
    [myAlertView setType:theType thetext:title];
    
    myAlertView.hidden = NO;
    
    if (hidden)
    {
        [self performSelector:@selector(hiddenAlert) withObject:nil afterDelay:1.0];
    }
}

-(void)hiddenAlert
{
    myAlertView.hidden = YES;
}


#pragma mark - dealloc

-(void)dealloc
{
    name_array = nil;
    
    name_content_label = nil;
    
    myAlertView = nil;
    
    _mainTabV = nil;
    
    _searchTabV = nil;
    
    _zkingSearchV = nil;
    
    arrayinfoaddress = nil;
    
    arrayname = nil;
    
    arrayOfCharacters = nil;
    
    arrayOfSearchResault = nil;    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
