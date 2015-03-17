//
//  MainViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//


#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GpersonallSettingViewController.h"

#import "MainViewController.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "MatchingAddressBookViewController.h"
#import "GmyFootViewController.h"
#import "ZSNApi.h"
#import "GlocalUserImage.h"
#import "GupData.h"
#import "NSString+Emoji.h"
#import "ZActionSheet.h"
#import "SuggestFriendViewController.h"


#define INPUT_HEIGHT 44.0f
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#define BANNAR_HEIGHT 510*DEVICE_HEIGHT/1334

@interface MainViewController (){
    
    
    UIBarButtonItem * spaceButton;
//    ///存放所有内容label
//    NSMutableArray * contentLabelArr;
//    ///存放所有回复内容label
//    NSMutableArray * rcontentLabelArr;
//    ///存放所有评论数据views
//    NSMutableArray * commentsViewArr;
}

@end

@implementation MainViewController
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;
@synthesize theModel = _theModel;
@synthesize inputToolBarView = _inputToolBarView;
@synthesize theTouchView = _theTouchView;
@synthesize personModel = _personModel;
@synthesize cell_height_array = _cell_height_array;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (MY_MACRO_NAME) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    [self.inputToolBarView.myTextView resignFirstResponder];
    NSString *string_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:AUTHERKEY]];
    //判断登录条件
    if (string_authkey.length==0||[string_authkey isEqualToString:@"(null)"]) {
        LoginViewController *loginV=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginV];
        [self presentViewController:nav animated:NO completion:NULL];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView.myTextView resignFirstResponder];
}


-(void)loadInfomationWithPage
{
    __weak typeof(self) bself = self;

    /*
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:USERID]integerValue ]==0) {
        
        return;
    }
    
    [_theModel initHttpRequestWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:USERID] Page:currentPage WithType:1 WithCompletionBlock:^(NSMutableArray *array) {
        loadsucess=YES;
        [bself dotheSuccessloadDtat:array];
        [loadview stopLoading:1];
        [bself doneLoadingTableViewData];
    } WithFailedBlock:^(NSString *operation) {
        [bself doneLoadingTableViewData];
        [loadview stopLoading:1];
        loadsucess=YES;
    }];
    */
    
    ///张少南 这里需要换成正式数据
//    NSString* fullURL = [NSString stringWithFormat:FB_WEIBOMYSELF_URL,[SzkAPI getAuthkey],currentPage];
    NSString * fullURL = @"http://t.fblife.com/openapi/index.php?mod=getweibo&code=getuserweibo&authkey=X2tbP1czVTEAMVAzDHcCb1orUiZbbQI+CGk=&page=1&fbtype=json";//[NSString stringWithFormat:@"http://t.fblife.com/openapi/index.php?mod=getweibo_quan&code=myfeed&fromtype=b5eeec0b&authkey=%@&page=%d&fbtype=json",@"X2tbP1czVTEAMVAzDHcCb1orUiZbbQI+CGk=",currentPage];

    NSLog(@"请求微博url---%@",fullURL);
    
    ASIHTTPRequest * weiBo_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullURL]];
    [weiBo_request setPersistentConnectionTimeoutSeconds:60];
    [weiBo_request startAsynchronous];
    
    __weak typeof(weiBo_request)wRequest = weiBo_request;
    [wRequest setCompletionBlock:^{
        @try
        {
            loadsucess = YES;
            [loadview stopLoading:1];
            [self doneLoadingTableViewData];
            NSDictionary * rootObject = [[NSDictionary alloc] initWithDictionary:[weiBo_request.responseData objectFromJSONData]];
            NSString *errcode =[NSString stringWithFormat:@"%@",[rootObject objectForKey:ERRCODE]];
            
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary* userinfo = [rootObject objectForKey:@"weiboinfo"];
                [self dotheSuccessloadDtat:userinfo];
            }
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }
    }];
    
    [wRequest setFailedBlock:^{
        loadsucess = YES;
        [ZSNApi showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
        [self doneLoadingTableViewData];
        [loadview stopLoading:1];
        [bself.myTableView reloadData];
    }];
}

#pragma mark--发表成功后刷新数据
-(void)refreshBecauserUpdatasuccess:(NSNotification *)notification
{
    __weak typeof(self) bself = self;
        
    loadview.normalLabel.text = @"上拉加载更多";
    
//    [_theModel initHttpRequestWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:USERID] Page:1 WithType:1 WithCompletionBlock:^(NSMutableArray *array) {
//        [bself dotheSuccessloadDtat:array];
//        
//    } WithFailedBlock:^(NSString *operation) {
//        
//        
//    }];
    
    [self loadInfomationWithPage];
    
}

-(void)dotheSuccessloadDtat:(NSDictionary *)userinfo{
    
    if (currentPage != 1)
    {
        if ([userinfo isEqual:[NSNull null]])
        {
            [_myTableView reloadData];
            return;
        }
    }else
    {
        [_data_array removeAllObjects];
    }
    
    if ([userinfo isEqual:[NSNull null]])
    {
        //如果没有微博的话
        [_myTableView reloadData];
        return;
    }else
    {
                
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            NSArray * arr = [ZSNApi sortArrayWith:[userinfo allKeys]];
            NSMutableArray * temp = [NSMutableArray array];
            for (int i = 0;i < arr.count;i++) {
                NSString * key = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                FBCircleModel * model = [[FBCircleModel alloc] initWithDictionary:[userinfo objectForKey:key]];
                [temp addObject:model];
            }
            
            
            [_data_array addObjectsFromArray:temp];
            [self returnCellHeightWith:temp WithNew:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        });
        
        
        
    }
    
    
}

-(void)loadPersonalData
{
    __weak typeof(self) bself = self;
    
    NSString *str_url=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]];
    if ([str_url integerValue]==0) {
        return;
    }
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    [_personModel loadPersonWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] WithBlock:^(FBCirclePersonalModel *model) {
        
        bself.personModel = model;
        
        [user setObject:model.person_face forKey:USERFACE];
        
        [user synchronize];
        
        [bself loadTableHeaderView];
        
        if (bself.cell_height_array.count > 0) {
            [bself.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        //        [bself.myTableView reloadData];
        
    } WithFailedBlcok:^(NSString *string) {
        
        bself.personModel.person_username = [SzkAPI getUsername];
        bself.personModel.person_uid = [SzkAPI getUid];
        bself.personModel.person_face = [SzkAPI getUserFace];
        [bself loadTableHeaderView];
        [bself.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}



-(void)loadCacheData
{
    if (self.data_array.count == 0)
    {
        __weak typeof(self)bself = self;
        
            NSMutableArray * delete_array = [FBCircleModel findAllWaitingUploadDelete];

            self.data_array = [FBCircleModel findAll];
            
            if (delete_array.count != 0)
            {
                [self.data_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    //找到没删除成功的微博，然后不显示
                    for (FBCirclePraiseModel * praise_model in delete_array)
                    {
                        if ([((FBCircleModel*)obj).fb_tid isEqualToString:praise_model.praise_tid])
                        {
                            *stop = YES;
                            if (*stop == YES)
                            {
                                [bself.data_array removeObjectAtIndex:idx];
                            }
                        }
                    }
                    if (*stop) {
                        NSLog(@"array is %@",bself.data_array);
                    }
                }];
            }
            
            [self returnCellHeightWith:bself.data_array WithNew:YES];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    loadsucess=YES;

    self.titleLabel.text = @"fb圈";
    self.title = @"fb圈";
    
    [self.navigationController.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
    
    
    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-15:5;;
    
    //  [self.navigationController pushViewController:[[MatchingAddressBookViewController alloc]init] animated:YES];
    //注册成功或者用户第一次登录，会匹配通讯录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(matchingAddressBook) name:@"successRegist" object:nil];
    //发表成功，会刷新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBecauserUpdatasuccess:) name:SUCCESSUPDATA object:nil];
    
    
    self.view.backgroundColor=RGBCOLOR(214,214,214);
    
//    [self setupLeftMenuButton];
    [self setupRightMenuButton];    
    
    _data_array = [NSMutableArray array];
    _cell_height_array = [NSMutableArray array];
    notification_dictionary  = [NSMutableDictionary dictionary];
    _theModel = [[FBCircleModel alloc] init];
    _personModel = [[FBCirclePersonalModel alloc] init];
    currentPage = 1;
    temp_count = 1;
    isFace = NO;
    
    [self loadInfomationWithPage];
    
    [self loadPersonalData];
    
    [self loadTableHeaderView];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64-49) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(204,204,204);
    _myTableView.separatorInset = UIEdgeInsetsZero;
    _myTableView.sectionHeaderHeight = 320;
    _myTableView.scrollsToTop = YES;
    _myTableView.tableHeaderView = headerView;
    [self.view addSubview:_myTableView];
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, DEVICE_WIDTH, 40)];
    _myTableView.tableFooterView = loadview;
    [loadview startLoading];
    
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0-_myTableView.bounds.size.height, self.view.frame.size.width, _myTableView.bounds.size.height)];
		view.delegate = self;
		//[tab_pinglunliebiao addSubview:view];
		_refreshHeaderView = view;
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    [_myTableView addSubview:_refreshHeaderView];
    
    
    
    faceScrollView = [[WeiBoFaceScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,215) target:self];
    faceScrollView.delegate = self;
    faceScrollView.bounces = NO;
    faceScrollView.contentSize = CGSizeMake(DEVICE_WIDTH*3,0);
    
    
    _inputToolBarView = [[ChatInputView alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT-20-44,DEVICE_WIDTH,44)];
    _inputToolBarView.myTextView.delegate = self;
    _inputToolBarView.myTextView.returnKeyType = UIReturnKeySend;
    _inputToolBarView.myTextView.textColor = RGBCOLOR(153,153,153);
    _inputToolBarView.myTextView.scrollsToTop = NO;
    _inputToolBarView.delegate = self;
    [_inputToolBarView.sendButton setTitle:nil forState:UIControlStateNormal];
    
    [_inputToolBarView.sendButton setImage:[UIImage imageNamed:!isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:_inputToolBarView];
    
    
  //  [self loadCacheData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(FBCirclehandleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(FBCirclehandleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(FBCircleUserInfomationChanged:)
												 name:UPDATAPERSONALINFORMATION
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HaveNewMessage:) name:COMEMESSAGES object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:SUCCESSLOGOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:SUCCESSLOGIN object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToThreeVC:) name:YINGYONGWAINOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveReadMessage:) name:@"readMessageNotification" object:nil];
    
    NSDictionary * yingyongwaiDic = [[NSUserDefaults standardUserDefaults] objectForKey:YINGYONGWAINOTIFICATION];
    if (yingyongwaiDic)
    {
        [self turnToThreeVC:yingyongwaiDic];
    }
}


-(void)turnToThreeVC:(NSDictionary *)notification
{
    NSString * MessageType = [[notification objectForKey:@"aps"] objectForKey:@"type"];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:YINGYONGWAINOTIFICATION];
    if ([MessageType intValue] == 3 || [MessageType intValue] == 4 || [MessageType intValue] == 5)
    {
        GmyMessageViewController * gMessage = [[GmyMessageViewController alloc] init];
        [self PushToViewController:gMessage WithAnimation:YES];
    }else if ([MessageType intValue] == 1 || [MessageType intValue] == 2)
    {
        MatchingAddressBookViewController * matchingV = [[MatchingAddressBookViewController alloc] init];
        [self PushToViewController:matchingV WithAnimation:YES];
        
    }else if ([MessageType intValue] == 6)
    {
        MessageViewController * message = [[MessageViewController alloc] init];
        [self PushToViewController:message WithAnimation:YES];
    }
}

/*
 *
 */
-(void)HaveNewMessage:(NSNotification *)notification
{
    NSLog(@"notification ---  %@",notification.userInfo);
    
    isHaveNewMessage = YES;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    notificationNum++;
    
    notificationDic=[NSDictionary dictionary];
    
    notificationDic = notification.userInfo;
    
    NSString * MessageType = [[notificationDic objectForKey:@"aps"] objectForKey:@"type"];
    
    if ([MessageType intValue] == 3 || [MessageType intValue] == 4 || [MessageType intValue] == 5)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"systemMessageRemind"];
        
        [self loadTableHeaderView];
        
        self.myTableView.tableHeaderView = headerView;
        
        [self.myTableView reloadData];
        
    }else if ([MessageType intValue] == 1 || [MessageType intValue] == 2)
    {
        tixing_imageView.hidden = NO;
        
        if (![[notification_dictionary allKeys] containsObject:@"friend"]) {
            [notification_dictionary setObject:@"new" forKey:@"friend"];
        }
        
        [self loadTableHeaderView];
        
        self.myTableView.tableHeaderView = headerView;
        
        [self.myTableView reloadData];
        
    }else if ([MessageType intValue] == 6)
    {
        tixing_imageView.hidden = NO;
        
        if (![[notification_dictionary allKeys] containsObject:@"message"]) {
            [notification_dictionary setObject:@"new" forKey:@"message"];
        }
        [self loadTableHeaderView];
        
        self.myTableView.tableHeaderView = headerView;
        
        [self.myTableView reloadData];
    }
}


-(void)haveReadMessage:(NSNotification *)notification
{
    notificationNum = 0;
    
    isHaveNewMessage = NO;
    
    notificationDic = nil;
    
    [self loadTableHeaderView];
    
    self.myTableView.tableHeaderView = headerView;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}



//退出登陆

-(void)logout:(NSNotification *)notification
{
    [FBCircleModel deleteAllBlog];
    [FBCircleModel deleteallComments];
    [FBCircleModel deleteAllNOComments];
    [FBCircleModel deleteAllNODeleteBlog];
    [FBCircleModel deleteAllNOForwardBlog];
    [FBCircleModel deleteAllNOPraiseBlog];
    [FBCircleModel deleteAllNOSendBlog];
    [FBCircleModel deleteallPraises];
    
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appdelegate.uploadData cancelAllRequest];//张少南 这里需要修改
    
    
    
    [self.data_array removeAllObjects];
    [self.cell_height_array removeAllObjects];
    _personModel = [[FBCirclePersonalModel alloc] init];
    
    notificationNum = 0;
    
    isHaveNewMessage = NO;
    
    notificationDic = nil;
    
    [bannerView loadImageFromURL:@"" withPlaceholdImage:[UIImage imageNamed:@"fengmian_loading_640_512.png"]];
    
    user_header_imageView.image = PERSONAL_DEFAULTS_IMAGE;
    
    userName_label.text = @"";
    
    [self.myTableView reloadData];
}

//登陆成功

-(void)login:(NSNotification *)notification
{
    currentPage = 1;
    
    [self loadInfomationWithPage];
    
    [self loadPersonalData];
    
}



-(void)setupLeftMenuButton{
    //   MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //wo-34_38@2x.png   fabu-40_40@2x.png
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(10,0,40,40)];
    [button_back addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    //    [button_back setBackgroundImage:[UIImage imageNamed:@"wo-34_38.png"] forState:UIControlStateNormal];
    [button_back setImage:[UIImage imageNamed:@"wo-34_38.png"] forState:UIControlStateNormal];
    
    
    tixing_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    tixing_imageView.center = CGPointMake(28.5,13);
    tixing_imageView.backgroundColor = [UIColor redColor];
    tixing_imageView.layer.masksToBounds = YES;
    tixing_imageView.hidden = YES;
    tixing_imageView.layer.cornerRadius = 5;
    [button_back addSubview:tixing_imageView];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton,back_item];
}

-(void)setupRightMenuButton
{
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(0,0,44,44);
    back_button.backgroundColor = [UIColor clearColor];
    
    right_button=[[UIButton alloc]initWithFrame:CGRectMake(15,12,38/2,37.0/2)];
    right_button.backgroundColor = [UIColor clearColor];
    right_button.userInteractionEnabled = NO;
    [back_button addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setImage:[UIImage imageNamed:@"fabu-40_40.png"] forState:UIControlStateNormal];
    [back_button addSubview:right_button];
    
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:back_button];
    
    self.navigationItem.rightBarButtonItems = @[spaceButton,back_item];
 
    
    //    [self.navigationController.navigationBar addSubview:right_button];
    
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    
    GpersonallSettingViewController *_personalVC=[[GpersonallSettingViewController alloc]init];
    _personalVC.dic = [NSDictionary dictionaryWithDictionary:notification_dictionary];
    _personalVC.personModel = _personModel;
    [self PushToViewController:_personalVC WithAnimation:YES];
    [notification_dictionary removeAllObjects];
    
    NSLog(@"消息推送   ---    %@",_personalVC.dic);
    
    tixing_imageView.hidden = YES;
    
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    //    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
    
    [UIView animateWithDuration:0.4 delay:0 options:0 animations: ^{
        
        right_button.transform = CGAffineTransformRotate(right_button.transform, DegreesToRadians(45));
    } completion: ^(BOOL completed) {
        
    }];
    
    ZActionSheet * actionSheet = [[ZActionSheet alloc] initWithTitle:nil buttonTitles:[NSArray arrayWithObjects:@"拍照",@"从手机相册选择",@"说说",nil] buttonColor:RGBCOLOR(0,203,4) CancelTitle:@"取消" CancelColor:RGBCOLOR(245,245,245) actionBackColor:RGBCOLOR(236,237,241)];
    actionSheet.tag = 602;
    actionSheet.delegate = self;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow WithAnimation:YES];
    
}

#pragma mark--匹配通讯录

-(void)matchingAddressBook{
    
    UIAlertView *alerV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"看看手机通讯录里谁在使用FB圈，若不允许，您将无法在FB圈中使用好友推荐功能（不保存通讯录中得任何资料，仅使用特征码做匹配识别）" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"好", nil];
    
    [alerV show];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 100000)
    {
        if (buttonIndex == 1)
        {
            [self deleteBlog];
        }
    }else
    {
        switch (buttonIndex) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                MatchingAddressBookViewController *VCn=[[MatchingAddressBookViewController alloc]init];
                VCn.str_title=@"匹配通讯录";
                [self PushToViewController:[[MatchingAddressBookViewController alloc]init] WithAnimation:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - UIActionSheetDelegate

-(void)zactionSheet:(ZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 602) {//右边的加号
        [UIView animateWithDuration:0.4 delay:0 options:0 animations: ^{
            
            right_button.transform = CGAffineTransformIdentity;
        } completion: ^(BOOL completed) {
            
        }];
        
        
        switch (buttonIndex)
        {
            case 1:
            {
                NSLog(@"拍照");
                
                isUpdataBanner = NO;
                
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
                    pickerC.delegate = self;
                    pickerC.allowsEditing = NO;
                    pickerC.sourceType = sourceType;
                    [self presentViewController:pickerC animated:YES completion:nil];
                }
                else
                {
                    NSLog(@"模拟其中无法打开照相机,请在真机中使用");
                }
                
            }
                break;
            case 2:
            {
                isUpdataBanner = NO;
                
                NSLog(@"从手机相册选择");
                
                if (!imagePickerController)
                {
                    imagePickerController = nil;
                }
                
                imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                
                [self presentViewController:navigationController animated:YES completion:NULL];
                
            }
                break;
            case 3:
            {
                NSLog(@"说说");
                
                WriteBlogViewController * WriteBlog = [[WriteBlogViewController alloc] init];
                
                WriteBlog.theType = WriteBlogWithContent;
                
                WriteBlog.delegate = self;
                
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WriteBlog];
                
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
                
                
            }
                break;
            case 0:
            {
                NSLog(@"取消");
            }
                break;
                
            default:
                break;
        }
        
        
    }else if (actionSheet.tag == 601){//更改用户banner
        isUpdataBanner = YES;
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        [picker.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
        picker.navigationBar.barTintColor = [UIColor blackColor];
        UIColor * cc = [UIColor whiteColor];//RGBCOLOR(91,138,59);
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:18],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
        picker.navigationBar.titleTextAttributes = dict;
        
        
        switch (buttonIndex) {
            case 1://拍照
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                }else{
                    NSLog(@"无法打开相机");
                }
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
                
                break;
            case 2://相册
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                #define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
                [self presentViewController:picker animated:YES completion:^{
                    if (IOS7_OR_LATER) {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    }
                }];
                break;
                
            case 3://取消
                break;
                
            default:
                break;
        }
    }
    
    
    
    
}

#pragma mark-QBImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    //    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    NSMutableArray * allImageArray = [NSMutableArray array];
    
    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage * newImage = [SzkAPI scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
        [allImageArray addObject:newImage];
        
        NSURL * url = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        NSString * url_string = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        url_string = [url_string stringByAppendingString:@".png"];
        
        [allAssesters addObject:url_string];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [ZSNApi saveImageToDocWith:url_string WithImage:image];
        });
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        WriteBlogViewController * WriteBlog = [[WriteBlogViewController alloc] init];
        WriteBlog.TempAllImageArray = allImageArray;
        WriteBlog.TempAllAssesters = allAssesters;
        WriteBlog.delegate = self;
        WriteBlog.theType = WriteBlogWithImagesAndContent;
        
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WriteBlog];
        
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if (!isUpdataBanner)
    {
        NSMutableArray * allImageArray = [NSMutableArray array];
        
        NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
        
        UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * newImage = [ZSNApi scaleToSizeWithImage:image1 size:CGSizeMake(720,960)];
        NSLog(@"newImagew == %f ==%f ----  %@",newImage.size.width,newImage.size.height,newImage);
        [allImageArray addObject:newImage];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageToSavedPhotosAlbum:image1.CGImage orientation:(ALAssetOrientation)image1.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             //here is your URL : assetURL
             
             NSString * url_string = [[assetURL absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
             
             url_string = [url_string stringByAppendingString:@".png"];
             
             [allAssesters addObject:url_string];
             
             
             [picker dismissViewControllerAnimated:YES completion:^{
                 WriteBlogViewController * WriteBlog = [[WriteBlogViewController alloc] init];
                 WriteBlog.TempAllImageArray = allImageArray;
                 WriteBlog.TempAllAssesters = allAssesters;
                 WriteBlog.delegate = self;
                 WriteBlog.theType = WriteBlogWithImagesAndContent;
                 
                 UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WriteBlog];
                 [self presentViewController:nav animated:YES completion:^{
                 }];
             }];
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                 [ZSNApi saveImageToDocWith:url_string WithImage:newImage];
             });
         }];
    }else
    {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]) {
            
            //压缩图片 不展示原图
            UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            //按比例缩放
            UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
            
            //将图片传递给截取界面进行截取并设置回调方法（协议）
            MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
            imageCrop.delegate = self;
            
            //按像素缩放
            imageCrop.ratioOfWidthAndHeight = 640.0f/512.0f;//设置缩放比例
            
            imageCrop.image = scaleImage;
            //[imageCrop showWithAnimation:NO];
            picker.navigationBar.hidden = YES;
            [picker pushViewController:imageCrop animated:YES];
            
        }
    }
}


#pragma mark- 缩放图片
//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark - 图片回传协议方法
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage{
    
    //按像素缩放
    UIImage *doneImage = cropImage;
    NSData * userUpImageData = UIImageJPEGRepresentation(doneImage, 0.5);
    //缓存banner到本地
    [GlocalUserImage setUserBannerImageWithData:userUpImageData];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
    
    NSLog(@"上传用户修改topview背景图");
    [self testWith:userUpImageData];
    
    
}


//上传
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)testWith:(NSData *)userUpImageData
{
    
    @try {
        
        NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=front&authkey=%@",[SzkAPI getAuthkey]];
        
        NSLog(@"上传图片请求的地址===%@",fullURL);
        
        ASIFormDataRequest *request__ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        request__.delegate = self;
        request__.tag = 123;
        
        
        [request__ addRequestHeader:@"frontpic" value:[NSString stringWithFormat:@"%d", [userUpImageData length]]];
        //设置http body
        [request__ addData:userUpImageData withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"frontpic"]];
        
        [request__ setRequestMethod:@"POST"];
        request__.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
        request__.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        [request__ startAsynchronous];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传完成");
    
    @try {
        if (request.tag == 123)
        {
            NSLog(@"走了555");
            NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
            
            NSLog(@"tupiandic==%@",dic);
            
            if ([[dic objectForKey:@"errcode"] intValue] == 0) {
                NSLog(@"上传成功");
                NSString *str = @"no";
                [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
                
            }else{
                NSString *str = @"yes";
                [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


#pragma mark-UITableViewHeaderView

-(void)loadTableHeaderView
{
    self.myTableView.sectionHeaderHeight = BANNAR_HEIGHT + 70 + (isHaveNewMessage?40:0);
    
    if (!headerView)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,BANNAR_HEIGHT + 70 + (isHaveNewMessage?40:0))];
        bannerView = [[AsyncImageView alloc]  initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,BANNAR_HEIGHT)];
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.tag = 319;
        bannerView.clipsToBounds = YES;
        bannerView.contentMode = UIViewContentModeScaleAspectFill;
        bannerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * doTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPersonalBanner:)];
        
        [bannerView addGestureRecognizer:doTap];
        
        [headerView addSubview:bannerView];
        
        
        UIView * headerBackView = [[UIView alloc] initWithFrame:CGRectMake(234.5,204,75,75)];
        headerBackView.layer.cornerRadius = 5;
        headerBackView.layer.borderWidth = 2;
        headerBackView.layer.borderColor = [RGBACOLOR(198, 196, 196, 0.75) CGColor];
        headerBackView.backgroundColor = [UIColor whiteColor];
      //  [headerView addSubview:headerBackView];
        
        
        user_header_imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-85,BANNAR_HEIGHT-48,75,75)];
//        user_header_imageView.center = CGPointMake(75.0/2,75.0/2);
        user_header_imageView.layer.masksToBounds = YES;
//        user_header_imageView.layer.cornerRadius = 5;
        user_header_imageView.layer.borderWidth = 2;
        user_header_imageView.layer.borderColor = [[UIColor whiteColor] CGColor];

        user_header_imageView.tag = 320;
        user_header_imageView.layer.cornerRadius = 5;
        
        UITapGestureRecognizer *tap_one=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dotap:)];
        
        user_header_imageView.userInteractionEnabled=YES;
        [user_header_imageView addGestureRecognizer:tap_one];
        
        
        [headerView addSubview:user_header_imageView];
        
        userName_label = [[UILabel alloc] initWithFrame:CGRectMake(22,225,DEVICE_WIDTH-130,20)];
        userName_label.textAlignment = NSTextAlignmentRight;
        userName_label.layer.masksToBounds = NO;
        userName_label.layer.shadowColor = [UIColor blackColor].CGColor;
        userName_label.layer.shadowOffset = CGSizeMake(0,1);
        userName_label.layer.shadowRadius = 0.5;
        userName_label.layer.shadowOpacity = 0.8;
        userName_label.font = [UIFont systemFontOfSize:18];
        userName_label.textColor = [UIColor whiteColor];
        userName_label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:userName_label];
        
        
        bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,BANNAR_HEIGHT + 70 + (isHaveNewMessage?40:0) - 0.5,DEVICE_WIDTH,0.5)];
        bottom_line_view.backgroundColor = RGBCOLOR(233,233,233);
        bottom_line_view.hidden = YES;
        [headerView addSubview:bottom_line_view];
        
    }else
    {
        bannerView.image = [UIImage imageNamed:@"fengmian_loading_640_512.png"];
        
        userName_label.text = @"";
        
        user_header_imageView.image = PERSONAL_DEFAULTS_IMAGE;
    }
    
    
    headerView.frame = CGRectMake(0,0,DEVICE_WIDTH,BANNAR_HEIGHT + 70 + (isHaveNewMessage?40:0));
    
    if ([GlocalUserImage getUserBannerImage])
    {
        bannerView.image = [GlocalUserImage getUserBannerImage];
    }else
    {
        NSString * string = [NSString stringWithFormat:@"%@",_personModel.person_frontpic];
        if ([string isEqualToString:@"http://quan.fblife.com/resource/front//"])
        {
            [bannerView loadImageFromURL:@"" withPlaceholdImage:[UIImage imageNamed:@"fengmian_640_512.png"]];
        }else
        {
            [bannerView setImageWithURL:[NSURL URLWithString:_personModel.person_frontpic] placeholderImage:[UIImage imageNamed:@"fengmian_loading_640_512.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [GlocalUserImage setUserBannerImageWithData:UIImageJPEGRepresentation(image,0.5)];
            }];
        }
    }
    
//    [bannerView sd_setImageWithURL:[NSURL URLWithString:@"http://fb.cn/images/userface/000/01/56/face_60_0.jpg"] placeholderImage:nil];
    
    
    if ([GlocalUserImage getUserFaceImage])
    {
        user_header_imageView.image = [GlocalUserImage getUserFaceImage];
    }else
    {
        
        [user_header_imageView setImageWithURL:[NSURL URLWithString:[_personModel.person_face stringByReplacingOccurrencesOfString:@"middle" withString:@"big"]] placeholderImage:PERSONAL_DEFAULTS_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [GlocalUserImage setUserFaceImageWithData:UIImageJPEGRepresentation(image,0.5)];
        }];
    }
    
    
    if ([_personModel.person_username isEqualToString:@"(null)"]) {
        userName_label.text = @"";
    }else
    {
        userName_label.text = _personModel.person_username;
    }
    
    bottom_line_view.frame = CGRectMake(0,BANNAR_HEIGHT + 70 + (isHaveNewMessage?40:0)-0.5,DEVICE_WIDTH,0.5);
    
    
    if (isHaveNewMessage)
    {
        bottom_line_view.hidden = NO;
        
        if (connectV)
        {
            [connectV setNoticeNumber:[[notificationDic objectForKey:@"aps"] objectForKey:@"badge"] Hearimg:[[notificationDic objectForKey:@"aps"] objectForKey:@"headimg"]];
            
            return;
        }
        
        connectV = [[ConnectofMineView alloc] initWithFrame:CGRectMake(0,306,262/2,30) Thebloc:^{
            
            @try
            {
                notificationNum = 0;
                
                isHaveNewMessage = NO;
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"systemMessageRemind"];
                
                NSString * MessageType = [[notificationDic objectForKey:@"aps"] objectForKey:@"type"];
                
                if ([MessageType intValue] == 3 || [MessageType intValue] == 4 || [MessageType intValue] == 5)///系统通知（评论赞转发）
                {
                    GmyMessageViewController * gMessage = [[GmyMessageViewController alloc] init];
                    [self PushToViewController:gMessage WithAnimation:YES];
                    
                }else if ([MessageType intValue] == 1 || [MessageType intValue] == 2)///添加好友
                {
                    SuggestFriendViewController * friend = [[SuggestFriendViewController alloc] init];
                    [self PushToViewController:friend WithAnimation:YES];
                    
                }else if ([MessageType intValue] == 6)///私信
                {
                    MessageViewController * messageVC = [[MessageViewController alloc] init];
                    [self.navigationController pushViewController:messageVC animated:YES];
                }
                
                notificationDic = nil;
                
                [self loadTableHeaderView];
                
                self.myTableView.tableHeaderView = headerView;
    
                
               
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }];
        
        
        [connectV setNoticeNumber:[[notificationDic objectForKey:@"aps"] objectForKey:@"badge"] Hearimg:[[notificationDic objectForKey:@"aps"] objectForKey:@"headimg"]];
        connectV.tag = 567;
        [headerView addSubview:connectV];
    }else
    {
        [connectV removeFromSuperview];
        connectV = nil;
        bottom_line_view.hidden = YES;
    }
    
    
}


#pragma mark - 计算行高并保存
///array:要计算高度的数组  isNew:是否把之前的干掉重新计算
-(void)returnCellHeightWith:(NSMutableArray *)array WithNew:(BOOL)isNew
{
    if (!test_cell)
    {
        test_cell = [[FBCircleCustomCell alloc] init];
        [test_cell setAllViews];
    }
    
    if (currentPage == 1)
    {
        [_cell_height_array removeAllObjects];
    }
    
    __weak typeof(self)bself = self;
    
        for (FBCircleModel * model in array)
        {
            float height = [test_cell returnCellHeightWith:model];
            [bself.cell_height_array addObject:[NSNumber numberWithFloat:height]];
        }
        
//        [bself.myTableView reloadData];
}



#pragma mark--点击头像进入跳转

-(void)dotap:(UITapGestureRecognizer*)sender{
    
    
    GmyFootViewController *_gmyVC=[[GmyFootViewController alloc]init];
    _gmyVC.userModel = _personModel;
    [self PushToViewController:_gmyVC WithAnimation:YES];
}

#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBCircleModel * model = [self.data_array objectAtIndex:indexPath.row];
    if (_cell_height_array && indexPath.row < _cell_height_array.count) {
        return [[_cell_height_array objectAtIndex:indexPath.row] floatValue] + (model.isShowMenuView?42:0);
    }else
    {
        return 0;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    FBCircleCustomCell * cell = (FBCircleCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[FBCircleCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.delegate = self;
    }
    
    [cell.content_label removeFromSuperview];
    cell.content_label = nil;
    [cell.rContent_label removeFromSuperview];
    cell.rContent_label = nil;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FBCircleModel * model = [_data_array objectAtIndex:indexPath.row];

    [cell setAllViews];
    
    [cell setInfomationWith:model];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBCircleModel * model = [self.data_array objectAtIndex:indexPath.row];
    
    if (model.isShowMenuView) {
        model.isShowMenuView = NO;
        [self reloadTableViewWithIndexPath:[NSArray arrayWithObjects:indexPath,nil]];
    }
    
    FBCircleDetailViewController * detailView = [[FBCircleDetailViewController alloc] init];
    
    detailView.theModel = model;
    
    [detailView reloadDataWhenBackWith:^{
    }];
    [self PushToViewController:detailView WithAnimation:YES];
}

-(void)reloadTableViewWithIndexPath:(NSArray *)arrary
{
    [self.myTableView reloadRowsAtIndexPaths:arrary withRowAnimation:UITableViewRowAnimationNone];
}


#pragma FBCircleCellDelegate

-(void)reloadMyTableViewWithCell:(FBCircleCustomCell *)cell
{
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    
    FBCircleModel * model = [self.data_array objectAtIndex:indexPath.row];
    
    model.isShowMenuView = NO;
    
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    history_selected_menu_page = indexPath.row;
}


-(void)selectedButtonWithType:(FBCircleMenuType)theType With:(FBCircleModel *)model WithCell:(FBCircleCustomCell *)cell
{
    [self reloadMyTableViewWithCell:cell];
    
    switch (theType) {
        case FBCircleMenuZan:
            [self praiseRequestWith:model];
            break;
        case FBCircleMenuPinglun:
            [self.inputToolBarView.myTextView becomeFirstResponder];
            break;
        case FBCircleMenuZhuanFa:
        {
            if ([model.fb_uid isEqualToString:[SzkAPI getUid]])
            {
                [ZSNApi showAutoHiddenMBProgressWithText:@"不能转发自己的文章" addToView:self.view];
                return;
            }
            
            
            if ((model.rfb_tid.length == 0 || [model.rfb_tid isEqualToString:@"(null)"] || [model.rfb_tid isKindOfClass:[NSNull class]]) && [model.rfb_content isEqualToString:@"此内容已删除"])
            {
                [ZSNApi showAutoHiddenMBProgressWithText:@"此内容已删除" addToView:self.view];
                return;
            }
            
            
            __weak typeof(self) bself = self;
            
            ZSNAlertView * alertView = [[ZSNAlertView alloc] init];
            
            BOOL isForward = NO;
            
            if ([model.fb_topic_type intValue] == 2 || [model.fb_sort intValue] == 1)
            {
                isForward = YES;
            }
            
            
            [alertView setInformationWithUrl:isForward?model.rfb_face:model.fb_face WithUserName:isForward?model.rfb_username:model.fb_username WithContent:isForward?model.rfb_content:model.fb_content WithBlock:^(NSString *theString) {
                
                [bself ForwardBlogRequestWith:isForward WithMode:model WithContent:theString];
                
            }];
            
            [alertView show];
            
        }
            break;
            
        default:
            break;
    }
}


-(void)deleteTheBlogWithCell:(FBCircleCustomCell *)cell
{
    UIAlertView * deleteAlert = [[UIAlertView alloc] initWithTitle:@"确定删除吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    deleteAlert.tag = 100000;
    [deleteAlert show];
    
    deleteIndexPath = [self.myTableView indexPathForCell:cell];
}


-(void)deleteBlog
{
    loading_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"正在删除" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil,nil];
    
    FBCircleModel * model = [self.data_array objectAtIndex:deleteIndexPath.row];
    
    [self.data_array removeObjectAtIndex:deleteIndexPath.row];
    
    [self.cell_height_array removeObjectAtIndex:deleteIndexPath.row];
    
    [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:deleteIndexPath,nil] withRowAnimation:UITableViewRowAnimationRight];
    
    
    NSString * fullUrl = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=topicdel&authkey=%@&tid=%@&fbtype=json",[SzkAPI getAuthkey],model.fb_tid];
    
    NSLog(@"删除微博url-----  %@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc]  initWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [loading_alertView removeFromSuperview];
         
         @try {
             NSDictionary * allDic = [operation.responseString objectFromJSONString];
             
             NSLog(@"删除微博结果-----%@",allDic);
             
             if ([[allDic objectForKey:@"errcode"] intValue] == 0)
             {
                 NSLog(@"删除微博成功");
                 [FBCircleModel deleteCommentByTid:model.fb_tid];
                 [FBCircleModel deletePraiseByTid:model.fb_tid];
                 [FBCircleModel deleteBlogWithTid:model.fb_tid];
                 [FBCircleModel updateRfbTidid:model.fb_tid WithTid:@""];
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                     
                     for (FBCircleModel * aModel in self.data_array)
                     {
                         if ([aModel.rfb_tid isEqualToString:model.fb_tid]) {
                             aModel.rfb_tid = @"";
                         }
                     }
                 });
             }else
             {
                 NSLog(@"删除微博失败-----%@",[allDic objectForKey:@"errinfo"]);
                 
                 FBCirclePraiseModel * praise_model = [[FBCirclePraiseModel alloc] init];
                 praise_model.praise_dateline = [ZSNApi timechangeToDateline];
                 praise_model.praise_image_url = [SzkAPI getUserFace];
                 praise_model.praise_tid = model.fb_tid;
                 praise_model.praise_uid = [SzkAPI getUid];
                 praise_model.praise_username = [SzkAPI getUsername];
                 int result = [FBCircleModel addNOSendDeleteWith:praise_model];
                 
                 NSLog(@"添加删除缓存结果 ---   %d",result);
             }
         }
         @catch (NSException *exception) {
             
         }
         @finally {
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         FBCirclePraiseModel * praise_model = [[FBCirclePraiseModel alloc] init];
         
         praise_model.praise_dateline = [ZSNApi timechangeToDateline];
         
         praise_model.praise_image_url = [SzkAPI getUserFace];
         
         praise_model.praise_tid = model.fb_tid;
         
         praise_model.praise_uid = [SzkAPI getUid];
         
         praise_model.praise_username = [SzkAPI getUsername];
         
         int result = [FBCircleModel addNOSendDeleteWith:praise_model];
         
         NSLog(@"添加删除缓存结果 ---   %d",result);
         
     }];
    
    
    [operation start];
}


#pragma mark - 转发文章

-(void)ForwardBlogRequestWith:(BOOL)isForward WithMode:(FBCircleModel *)model WithContent:(NSString *)string
{
    if (string.length == 0)
    {
        string = @"文章转发";
    }
    
    FBCircleModel * forward_model = [[FBCircleModel alloc] init];
    forward_model.fb_rootid = isForward?model.rfb_tid:model.fb_tid;
    forward_model.fb_deteline = [ZSNApi timechangeToDateline];
    forward_model.fb_content = string;
    forward_model.fb_uid = [SzkAPI getUid];
    forward_model.fb_username = [SzkAPI getUsername];
    forward_model.fb_face = [SzkAPI getUserFace];
    forward_model.fb_topic_type = @"2";
    forward_model.rfb_tid = isForward?model.rfb_tid:model.fb_tid;
    forward_model.rfb_uid = isForward?model.rfb_uid:model.fb_uid;
    forward_model.rfb_username = isForward?model.rfb_username:model.fb_username;
    forward_model.rfb_content = isForward?model.rfb_content:model.fb_content;
    forward_model.rfb_imageid = isForward?model.rfb_imageid:model.fb_imageid;
    forward_model.rfb_topic_type = isForward?model.rfb_topic_type:model.fb_topic_type;
    forward_model.rfb_zan_num = isForward?model.rfb_zan_num:model.fb_zan_num;
    forward_model.rfb_reply_num = isForward?model.rfb_reply_num:model.fb_reply_num;
    forward_model.rfb_forward_num = isForward?model.rfb_forward_num:model.fb_forward_num;
    forward_model.rfb_replyid = isForward?model.rfb_replyid:model.fb_replyid;
    forward_model.rfb_rootid = isForward?model.rfb_rootid:model.fb_rootid;
    forward_model.rfb_ip = isForward?model.rfb_ip:model.fb_ip;
    forward_model.rfb_lng = isForward?model.rfb_lng:model.fb_lng;
    forward_model.rfb_lat = isForward?model.rfb_lat:model.fb_lat;
    forward_model.rfb_area = isForward?model.rfb_area:model.fb_area;
    forward_model.rfb_status = isForward?model.rfb_status:model.fb_status;
    forward_model.rfb_deteline = isForward?model.rfb_deteline:model.fb_deteline;
    forward_model.rfb_image = isForward?model.rfb_image:model.fb_image;
    forward_model.rfb_face = isForward?model.rfb_face:model.fb_face;
    
    if ([model.fb_sort isEqualToString:@"1"])
    {
        forward_model.fb_sort = @"1";
        forward_model.fb_topic_type = @"1";
        forward_model.rfb_face = model.rfb_face;
    }
    
    [FBCircleModel addBlogWith:forward_model];
    
    [self.data_array insertObject:forward_model atIndex:0];
    
    if (!test_cell)
    {
        test_cell = [[FBCircleCustomCell alloc] init];
        [test_cell setAllViews];
    }
    
    float height = [test_cell returnCellHeightWith:forward_model];
    [self.cell_height_array insertObject:[NSNumber numberWithFloat:height] atIndex:0];
    
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
    
//#define URL_FORWARD @"http://fb.fblife.com/openapi/index.php?mod=doweibo&code=addforward&content=%@&tid=%@&forwardtid=%@&type=%@&fromtype=b5eeec0b&authkey=%@&fbtype=json"
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_FORWARD]];
    [request setPostValue:[string stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:isForward?model.rfb_tid:model.fb_tid forKey:@"forwardtid"];
    
    __weak typeof(request)arequest = request;
    __weak typeof(self) bself = self;
    [request setCompletionBlock:^{
        @try {
            NSDictionary * allDic = [arequest.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
                
                bself.inputToolBarView.myTextView.text = @"";
                
                [bself refreshBecauserUpdatasuccess:nil];
                
            }else
            {
                NSLog(@"转发失败");
                
                if (myAlertView)
                {
                    [myAlertView removeFromSuperview];
                    myAlertView = nil;
                }
                
                
                myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
                myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-50);
                [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:[allDic objectForKey:@"errinfo"]];
                [self.view addSubview:myAlertView];
                [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1.5];
                
                
                [self.data_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    if ([(FBCircleModel*)obj isEqual:forward_model])
                    {
                        *stop = YES;
                        if (*stop == YES)
                        {
                            [self.data_array removeObject:forward_model];
                            
                            [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationRight];
                        }
                    }
                    
                    if (*stop) {
                        NSLog(@"array is %@",bself.data_array);
                    }
                    
                }];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request setFailedBlock:^{
        FBCircleCommentModel * commentModel = [[FBCircleCommentModel alloc] init];
        commentModel.comment_tid = isForward?model.rfb_tid:model.fb_tid;
        commentModel.comment_uid = isForward?model.rfb_uid:model.fb_uid;
        commentModel.comment_content = string;
        commentModel.comment_dateline = [ZSNApi timechangeToDateline];
        int result = [FBCircleModel addNOSendForwardWith:commentModel];
        NSLog(@"添加转发到数据库 ---  %d",result);
    }];
    
    [request startAsynchronous];
    
}

#pragma mark- 消失提示框

-(void)dismissPromptView
{
    [myAlertView removeFromSuperview];
    
    myAlertView = nil;
}

#pragma mark-点赞

-(void)praiseRequestWith:(FBCircleModel *)model
{
    
    FBCircleModel * info = [self.data_array objectAtIndex:history_selected_menu_page];
    
    
    for (FBCirclePraiseModel * praiseModel in info.fb_praise_array)
    {
        if ([praiseModel.praise_username isEqualToString:[SzkAPI getUsername]])
        {
            myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
            
            myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-50);
            
            [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"您已经赞过了"];
            
            [self.view addSubview:myAlertView];
            
            [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
            
            return;
        }
    }
    
    
    FBCirclePraiseModel * praiseModel = [[FBCirclePraiseModel alloc] init];
    praiseModel.praise_image_url = [SzkAPI getUserFace];
    praiseModel.praise_uid = [SzkAPI getUid];
    praiseModel.praise_tid = info.fb_tid;
    praiseModel.praise_dateline = [ZSNApi timechangeToDateline];
    praiseModel.praise_username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    [info.fb_praise_array addObject:praiseModel];
    
    info.fb_zan_num = [NSString stringWithFormat:@"%d",([info.fb_zan_num intValue]+1)];
    
    [FBCircleModel addPraiseWith:praiseModel withtid:info.fb_tid];
    
    if (!test_cell)
    {
        test_cell = [[FBCircleCustomCell alloc] init];
        [test_cell setAllViews];
    }
    
    float height = [test_cell returnCellHeightWith:model];
    [self.cell_height_array replaceObjectAtIndex:history_selected_menu_page withObject:[NSNumber numberWithFloat:height]];

    
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:history_selected_menu_page inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_PRAISE_URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"autherkey"],model.fb_tid];
    
    NSURLRequest * UrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    NSLog(@"赞接口----%@",fullUrl);
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:UrlRequest];
    
    __block AFHTTPRequestOperation * request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
             
         }else
         {
             [FBCircleModel addNOSendPraiseWith:praiseModel];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [FBCircleModel addNOSendPraiseWith:praiseModel];
     }];
    
    [operation start];
}


-(void)clickMenuTapWith:(FBCircleCustomCell *)cell
{
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    
    FBCircleModel * model = [self.data_array objectAtIndex:indexPath.row];
    
    model.isShowMenuView = !model.isShowMenuView;
    
    FBCircleModel * history_model = [self.data_array objectAtIndex:history_selected_menu_page];
    
    if (history_selected_menu_page != indexPath.row && history_model.isShowMenuView)
    {
        history_model.isShowMenuView = NO;
        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,[NSIndexPath indexPathForRow:history_selected_menu_page inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    history_selected_menu_page = indexPath.row;
}

#pragma mark-UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    NSLog(@".........  %f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (loadview.normalLabel.hidden || [loadview.normalLabel.text isEqualToString:@"没有更多数据了"])
        {
            return;
        }
        
        [loadview startLoading];
        
        currentPage++;
        
        [self loadInfomationWithPage];
        /*
        __weak typeof(self) bself = self;
        [_theModel initHttpRequestWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:USERID] Page:currentPage WithType:1 WithCompletionBlock:^(NSMutableArray *array)
         {
             [bself doneLoadingTableViewData];
             [loadview stopLoading:1];
             
             loadsucess=YES;
             
             [bself dotheSuccessloadDtat:array];
             
             if (array.count == 0)
             {
                 currentPage--;
                 loadview.normalLabel.text = @"没有更多数据了";
             }
             
         } WithFailedBlock:^(NSString *operation) {
             [bself doneLoadingTableViewData];
             currentPage--;
             [loadview stopLoading:1];
             loadsucess=YES;
         }];
        */
    }
}
#pragma mark-下拉刷新的代理
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}
- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView];
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    if (loadsucess==YES) {
        loadsucess=!loadsucess;
        currentPage = 1;
        
        [self loadInfomationWithPage];
        [self loadPersonalData];
        
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return ccif data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark-ChatInputViewDelegate
- (void)FBCirclehandleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)FBCirclehandleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

-(void)FBCircleUserInfomationChanged:(NSNotification *)notification
{
    UIImage * headerImg = [GlocalUserImage getUserFaceImage];
    if (headerImg)
    {
        user_header_imageView.image = headerImg;
    }
    
    UIImage * bannerImg = [GlocalUserImage getUserBannerImage];
    if (bannerImg) {
        bannerView.image = bannerImg;
    }
    
//    [self.myTableView reloadData];
}

-(void)pushToDetailBlogWith:(FBCircleModel *)model
{
    
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    if (!isMyTextView) {
        return;
    }
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[ZSNApi animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         if(self.view.frame.size.height == keyboardY)
                             inputViewFrameY = keyboardY;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         _theTouchView.frame = CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y);
                     }
                     completion:^(BOOL finished) {
                     }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _theTouchView.hidden = YES;
    self.inputToolBarView.frame = CGRectMake(0,DEVICE_HEIGHT-20-44,DEVICE_WIDTH,44);
//    self.inputToolBarView.myTextView.frame = CGRectMake(17,6,248,32);
    temp_count = 1;
    [self.inputToolBarView resetInputView];
    isMyTextView = NO;
}


#pragma mark-发表说说成功代理

-(void)upLoadBlogWith:(FBCircleModel *)model
{
    [self.myTableView setContentOffset:CGPointMake(0,0) animated:YES];
    
    [self.data_array insertObject:model atIndex:0];
    
    if (!test_cell)
    {
        test_cell = [[FBCircleCustomCell alloc] init];
        [test_cell setAllViews];
    }
    
    float height = [test_cell returnCellHeightWith:model];
    [self.cell_height_array insertObject:[NSNumber numberWithFloat:height] atIndex:0];
    
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationLeft];
}




#pragma mark - Text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    isMyTextView = YES;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if (!_theTouchView)
    {
        _theTouchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y)];
        _theTouchView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:_theTouchView];
        [self.view addSubview:_theTouchView];
    }else
    {
        _theTouchView.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [self sendPinglun];
    
    [txtView resignFirstResponder];
    
    return NO;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    isMyTextView = NO;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!temp_textView)
    {
        temp_textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,textView.frame.size.width,textView.frame.size.height)];
        temp_textView.font = [UIFont systemFontOfSize:15];
    }
    
    temp_textView.text = textView.text;
    
    CGFloat height = [temp_textView sizeThatFits:CGSizeMake(textView.frame.size.width,CGFLOAT_MAX)].height;
    
    int count = 1;
    
    if (height > 34)
    {
        count = ((height-34)/18)+1;
    }
    
    float theheight = (count-temp_count)*18;
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         if (count > 6)
                         {
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:0];
                             
                             return ;
                         }else
                         {
                             if (count == 6 && theheight < 0)
                             {
                                 return;
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - theheight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + theheight);
                             
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:theheight];
                             _theTouchView.frame = CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y);
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
    
    temp_count = count;
    
    
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}


#pragma mark-ChatInputDelegate

-(void)sendMessageToSomeBodyWith:(NSString *)content
{    
    isFace = !isFace;
    
    [_inputToolBarView.sendButton setImage:[UIImage imageNamed:!isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    
    [self.inputToolBarView.myTextView resignFirstResponder];
    
    isMyTextView = NO;
    
    
    if (!isFace)
    {
        self.inputToolBarView.myTextView.inputView = nil;
    }else
    {
        self.inputToolBarView.myTextView.inputView = faceScrollView;
    }
    
    isMyTextView = YES;
    
    [self.inputToolBarView.myTextView becomeFirstResponder];
}


-(void)expressionClickWith:(NewFaceView *)faceView faceName:(NSString *)name
{
    self.inputToolBarView.myTextView.text = [self.inputToolBarView.myTextView.text stringByAppendingString:name];
    [self textViewDidChange:self.inputToolBarView.myTextView];
}


#pragma mark-发表评论


-(void)panduanwangluo
{
    //开启监控
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //设置网络状况监控后的代码块
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch ([[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus])
        {
                
            case AFNetworkReachabilityStatusReachableViaWiFi || AFNetworkReachabilityStatusReachableViaWWAN :
            {
                AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [appdelegate.uploadData upload];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"Unknown");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                
                break;
            default:
                break;
        }
    }];
}


-(void)sendPinglun
{
    NSString * myTextString = [self.inputToolBarView.myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (myTextString.length == 0)
    {
        myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
        myAlertView.center = CGPointMake(DEVICE_WIDTH,DEVICE_HEIGHT/2-20);
        [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"发送内容不能为空"];
        [self.view addSubview:myAlertView];
        [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
        return;
    }
    
    NSString * theContent = self.inputToolBarView.myTextView.text;
    
    FBCircleModel * model = [self.data_array objectAtIndex:history_selected_menu_page];
    
    FBCircleCommentModel * commentModel = [[FBCircleCommentModel alloc] init];
    commentModel.comment_content = theContent;
    commentModel.comment_uid = [SzkAPI getUid];
    commentModel.comment_tid = model.fb_tid;
    commentModel.comment_username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    commentModel.comment_face = [ZSNApi returnUrl:[SzkAPI getUid]];
    commentModel.comment_dateline = [ZSNApi timechangeToDateline];
    [model.fb_comment_array addObject:commentModel];
    model.fb_reply_num = [NSString stringWithFormat:@"%d",([model.fb_reply_num intValue]+1)];
    [FBCircleModel addCommentWith:commentModel withtid:model.fb_tid];
    
    if (!test_cell)
    {
        test_cell = [[FBCircleCustomCell alloc] init];
        [test_cell setAllViews];
    }
    
    float height = [test_cell returnCellHeightWith:model];
    [self.cell_height_array replaceObjectAtIndex:history_selected_menu_page withObject:[NSNumber numberWithFloat:height]];
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:history_selected_menu_page inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.inputToolBarView.frame = CGRectMake(0,DEVICE_HEIGHT-20-44,DEVICE_WIDTH,44);
    self.inputToolBarView.myTextView.frame = CGRectMake(17,6,248,32);
    self.inputToolBarView.myTextView.text = @"";

    ASIFormDataRequest * comment_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REPLY]];
    [comment_request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [comment_request setPostValue:model.fb_tid forKey:@"tid"];
    [comment_request setPostValue:[theContent stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    __weak typeof(comment_request)brequest = comment_request;
    
    [brequest setCompletionBlock:^{
        @try {
            NSDictionary * allDic = [comment_request.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                NSLog(@"发表评论成功");
            }else
            {
                [FBCircleModel addNOSendCommentWith:commentModel];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [brequest setFailedBlock:^{
        [FBCircleModel addNOSendCommentWith:commentModel];
    }];
    
    [comment_request startAsynchronous];
}



#pragma mark-修改背景图片

-(void)uploadPersonalBanner:(UITapGestureRecognizer *)sender
{
    
    ZActionSheet *gactionSheet = [[ZActionSheet alloc]initWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] buttonColor:RGBCOLOR(31,188,34) CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
    gactionSheet.delegate = self;
    [gactionSheet showInView:[UIApplication sharedApplication].keyWindow WithAnimation:YES];
    gactionSheet.tag = 601;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















