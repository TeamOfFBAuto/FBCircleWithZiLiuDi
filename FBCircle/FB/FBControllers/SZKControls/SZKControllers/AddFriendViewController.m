//
//  AddFriendViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//添加好友界面

#import "AddFriendViewController.h"
#import "AddFriendCustomCell.h"
#import "ZkingSearchView.h"
#import "SMSInvitationViewController.h"//短信邀请


#import "GRXX4ViewController.h"//各种情况 好友 非好友 自己 正在验证中的好友

#import "MatchingAddressBookViewController.h"

#import "GmFoundScanViewController.h"

#import "GmyErweimaViewController.h"

#import "GpersonInfoViewController.h"
#import "GRXX4ViewController.h"

@interface AddFriendViewController (){
 NSMutableArray *array_title;
    NSMutableArray *array_logoimg;
}

@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _scene = WXSceneSession;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    
    [super viewWillAppear:YES];

    self.navigationController.navigationBarHidden=!_searchTabV.hidden;
    
    if (_searchTabV.hidden) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    }

    
    [_mainTabV reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isnavgationBarhiden=YES;
    
    array_logoimg=[NSMutableArray array];
    
    array_title=[NSMutableArray array];
    
    NSArray *arr1=[NSArray arrayWithObject:@"添加手机联系人"];
    NSArray *arr2=[NSArray arrayWithObject:@"扫一扫添加好友"];
    NSArray *arr3=[NSArray arrayWithObjects:@"通过微信",@"通过短信", nil];
    
    [array_title addObject:arr1];
    
    [array_title addObject:arr2];
    
    [array_title addObject:arr3];

    
    

    
    
    NSArray *arr10=[NSArray arrayWithObject:@"tongxunlu-icon-94_94.png"];
    NSArray *arr20=[NSArray arrayWithObject:@"qsaoyisao@2x.png"];
    NSArray *arr30=[NSArray arrayWithObjects:@"weixin-icon-94_94.png",@"duanxin-icon-94_94.png", nil];
    
    
    [array_logoimg addObject:arr10];
    
    [array_logoimg addObject:arr20];
    
    [array_logoimg addObject:arr30];
    
    

    _array_searchResault=[NSArray array];
      self.titleLabel.text=@"添加好友";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
	// Do any additional setup after loading the view.
}
-(void)loadView{
    [super loadView];

    //1
    _mainTabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:_mainTabV];
    _mainTabV.delegate=self;
    _mainTabV.separatorColor=[UIColor clearColor];
    _mainTabV.dataSource=self;
    _mainTabV.backgroundColor=RGBCOLOR(236, 237, 240);
    //2
    _searchTabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, DEVICE_WIDTH, DEVICE_HEIGHT-75)];
    [self.view addSubview:_searchTabV];
    _searchTabV.delegate=self;
    _searchTabV.separatorColor=RGBCOLOR(225, 225, 225);
    _searchTabV.dataSource=self;
    _searchTabV.hidden=YES;
    //3
    _halfBlackV=[[UIView alloc]initWithFrame:CGRectMake(0, 75, DEVICE_WIDTH, DEVICE_HEIGHT - 75)];
    _halfBlackV.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    _halfBlackV.hidden=YES;
    [self.view addSubview:_halfBlackV];
    [self ReceiveMytabHeaderV];//加上tab的headerv
    
    
 

}


#pragma mark-把搜索和进入推荐列表的放到一起作为tabV的headerView
-(void)ReceiveMytabHeaderV{
    
    UIView *aviews=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,54)];
    aviews.backgroundColor=  RGBCOLOR(245  , 245, 248);

        
        __weak typeof(self) __weakself=self;
        
        //开始搜索
        
    ZkingSearchView * _zkingSearchV=[[ZkingSearchView alloc]initWithFrame:CGRectMake(0, 12, DEVICE_WIDTH, 30) imgBG:[UIImage imageNamed:@"longSearch592_60.png"] shortimgbg:[UIImage imageNamed:@"shortSearch486_60.png"]  imgLogo:[UIImage imageNamed:@""] placeholder:@"请输入用户名/手机号码搜索朋友" ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
            
            [__weakself searchFriendWithname:strSearchText thetag:tag];
            
        }];
    [aviews addSubview:_zkingSearchV];
        
     _mainTabV.tableHeaderView= aviews;
    
    
}
-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            NSLog(@"取消");
            self.navigationController.navigationBarHidden=NO;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

            _mainTabV.frame=CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            _searchTabV.hidden=YES;
//            [arrayOfSearchResault removeAllObjects];
            [_searchTabV reloadData];
            _halfBlackV.hidden=YES;
            
        }
            break;
        case 2:
        {
            self.navigationController.navigationBarHidden=YES;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

            _mainTabV.frame=CGRectMake(0, 30-7, DEVICE_WIDTH, DEVICE_HEIGHT-30+7);
            _halfBlackV.hidden=NO;
            NSLog(@"开始编辑");
            
        }
            break;
            
        case 3:
        {
            
            _searchTabV.hidden=NO;
            _halfBlackV.hidden=YES;
            NSLog(@"点击搜索按钮进行搜索方法");
            _array_searchResault =[NSArray array];
            [_searchTabV reloadData];
            __weak typeof(_searchTabV) weaksearchtab=_searchTabV;
            SzkLoadData *loaddata=[[SzkLoadData alloc]init];
            
            NSString *str_search=[NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=searchuser&keyword=%@",[strname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"搜索的接口是这个。。=%@",str_search);
            
            
            [loaddata SeturlStr:[NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=searchuser&keyword=%@&authkey=%@",[strname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[SzkAPI getAuthkey]] block:^(NSArray *arrayinfo, NSString *errorindo, int errcode)
             {
                if(errcode==0)
                {
                    _array_searchResault=arrayinfo;
                    
                    [weaksearchtab reloadData];

                }else{
                
                
                    UIAlertView *_alertV=[[UIAlertView alloc] initWithTitle:@"提示" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [_alertV show];
                
                
                }
                           NSLog(@"errcode==%d===%@",errcode,arrayinfo);
                NSLog(@"errcode==%d===%@",errcode,_array_searchResault);

            }];
            
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark-tableview的代理


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_mainTabV) {
        if (_mainTabV.frame.origin.y!=0) {
            
            _mainTabV.contentOffset=CGPointMake(0, 0);
            
        }else{
            
        }
        
        
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView==_mainTabV) {
        return 3;
        
    }else{
        return 1;

    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number=0;
    if (tableView==_mainTabV) {
        number=[[array_logoimg objectAtIndex:section] count];
    }else{
        number=_array_searchResault.count;
    }
    return number;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_mainTabV) {
        
        static NSString *stridentifier=@"identifier";
        
        AddFriendCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:stridentifier];
        
        if (!cell) {
            cell=[[AddFriendCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stridentifier];
            
        }
        
        if (indexPath.row==0) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle=UITableViewCellSelectionStyleGray;

        }
        
        if (indexPath.section==2&&indexPath.row==0) {
            [cell AddFriendCustomCellSetimg:[[array_logoimg objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title:[[array_title objectAtIndex:indexPath.section  ] objectAtIndex:indexPath.row] theAddFriendCustomCellType:AddFriendCustomCellTypeone];

        }else{
            [cell AddFriendCustomCellSetimg:[[array_logoimg objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title:[[array_title objectAtIndex:indexPath.section  ] objectAtIndex:indexPath.row] theAddFriendCustomCellType:FBQuanAlertViewTypeother];

        
        }
       
        
        
        
//
        return cell;

        
    }else{
        static NSString *stridentifier=@"identifiers";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:stridentifier];
        
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stridentifier];
            
        }
        
        @try {
            
            NSDictionary *dic__=[_array_searchResault objectAtIndex:indexPath.row];
            
            cell.textLabel.text=[dic__ objectForKey:@"username"];

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

        //[cell setFriendAttribute:[[FriendAttribute alloc] init]];
        return cell;

    
    
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 46;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (tableView==_mainTabV) {
        if (section==0) {
            return nil;
        }else{
            
            
            
//            UIView *aview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            UILabel *label_aha=[[UILabel alloc]initWithFrame:CGRectMake(0 ,0, DEVICE_WIDTH-24, 30)];
//            [aview addSubview:label_aha];
            
            if (section==1) {

            }else{
            
                label_aha.text=@"   邀请好友";

            }
            
            
            label_aha.textAlignment=NSTextAlignmentLeft;
            label_aha.font=[UIFont systemFontOfSize:13];
            label_aha.backgroundColor=RGBCOLOR(236, 237, 240);
            label_aha.textColor=RGBCOLOR(156, 156, 161);
            
            return label_aha;
            
        }
    }else{
    
        return nil;
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView==_mainTabV) {
        return section==0?0:30;

    }else{
        return 0;
    
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    
    
    if (tableView==_mainTabV) {
        if (indexPath.section==0) {
            NSLog(@"跳转到通讯录匹配");
            MatchingAddressBookViewController *suggestVC=[[MatchingAddressBookViewController alloc]init];
            suggestVC.str_title=@"从手机通讯录添加";
            [self.navigationController pushViewController:suggestVC animated:YES];
            
        }else if(indexPath.section==1){
        
            NSLog(@"xxx跳转到你猜");
            
            GmFoundScanViewController *gmscanVC=[[GmFoundScanViewController alloc]init];
            gmscanVC.delegate2 = self;
            [self presentViewController:gmscanVC animated:YES completion:^{
                
            }];
        }
        
        
        else{
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"跳转到微信");
                    
                    [self sendLinkContent];
                }
                    break;
                case 1:
                {
                    NSLog(@"跳转到短信");
                    
                    SMSInvitationViewController *_smsVC=[[SMSInvitationViewController alloc]init];
                    [self.navigationController pushViewController:_smsVC animated:YES];

                }
                    break;
     
                default:
                    break;
            }
        
        
        }
    }
    else{
    
        @try {
            
            
            /**
             *  1好友 2添加中 3接到邀请 4本人  5 没关系

             */
         
//            int thetype=[[[_array_searchResault objectAtIndex:indexPath.row] objectForKey:@"friendtype"] integerValue];
//            if (thetype==1) {
//                GRXX2ViewController *_grc=[[GRXX2ViewController alloc]init];
//                _grc.userid=[[_array_searchResault objectAtIndex:indexPath.row] objectForKey:@"uid"];
//                [self.navigationController pushViewController:_grc animated:YES];
//
//            }else if (thetype==2||thetype==3||thetype==5){
//                GRXX3ViewController *_grc=[[GRXX3ViewController alloc]init];
//                _grc.userid=[[_array_searchResault objectAtIndex:indexPath.row] objectForKey:@"uid"];
//                [self.navigationController pushViewController:_grc animated:YES];
//                
//            }
//            
//            else{
                GRXX4ViewController *_grc=[[GRXX4ViewController alloc]init];
              _grc.passUserid=[[_array_searchResault objectAtIndex:indexPath.row] objectForKey:@"uid"];
                [self.navigationController pushViewController:_grc animated:YES];
                
//            }
            
        }
        @catch (NSException *exception) {
        
        }
        @finally {
            
        }
        
  
    }

}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
//}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
   // message.title = @"ss";
    message.description =[NSString stringWithFormat:@"你越野e族的朋友%@邀请你加入FB圈,https://quan.fb.cn/download",[SzkAPI getUsername]];
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"https://quan.fb.cn/download";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



//扫一扫代理方法
//代理方法
-(void)pushWebViewWithStr:(NSString *)stringValue{
    NSLog(@"%s",__FUNCTION__);
    
    FBCircleWebViewController *fbwebvc = [[FBCircleWebViewController alloc]init];
    fbwebvc.web_url = stringValue;
    [self PushToViewController:fbwebvc WithAnimation:YES];
    
}

-(void)pushMyerweimaVc{
    
    
    GmyErweimaViewController *erweima = [[GmyErweimaViewController alloc]init];
    erweima.tabBarController.hidesBottomBarWhenPushed = YES;
    [self PushToViewController:erweima WithAnimation:YES];
}

-(void)pushToPersonInfoVcWithStr:(NSString *)stringValue{
    
    GpersonInfoViewController *ginfovc = [[GpersonInfoViewController alloc]init];
    ginfovc.passUserid = stringValue;
    
    NSLog(@"----%@",ginfovc.passUserid);
    [self PushToViewController:ginfovc WithAnimation:YES];
}

-(void)pushToGrxx4{
    GRXX4ViewController *grxx = [[GRXX4ViewController alloc]init];
    grxx.passUserid = [SzkAPI getUid];
    grxx.isMinVc = YES;
    [self PushToViewController:grxx WithAnimation:YES];
}



@end
