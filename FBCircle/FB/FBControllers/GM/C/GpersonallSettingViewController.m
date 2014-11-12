//
//  GpersonallSettingViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//
#import "SzkAPI.h"

#import "GpersonallSettingViewController.h"



#import "FullyLoaded.h"

#import "GlocalUserImage.h"

#import "GRXX4ViewController.h"


//扫一扫
#import "GscanfViewController.h"

@interface GpersonallSettingViewController ()
{
    GmyFootViewController *thirdVC;
}
@end

@implementation GpersonallSettingViewController





- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    //适配ios7navigationbar高度
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    //设置navigation左右按钮格式类型
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeDelete];
    
    //设置中间的图片
    UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,26,23)];
    
    titleImageView.image = [UIImage imageNamed:@"fb-52_46.png"];
    
    self.navigationItem.titleView = titleImageView;
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prepareNetData) name:@"chagePersonalInformation" object:nil];
    
    //顶部灰色条
//    UIView *topTiao = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
//    topTiao.backgroundColor = RGBCOLOR(229, 229, 229);
//    [self.view addSubview:topTiao];
    
  
    
    //头像 和 用户名 能点击部位
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"geren320_103.png"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 6, 320, 103);
    [btn addTarget:self action:@selector(doTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIView *userFaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 6, 320, 103)];
    
    
    
    
    
    
    //[self.view addSubview:userFaceView];
    
    //箭头
    UIImageView *jiantouV = [[UIImageView alloc]initWithFrame:CGRectMake(288, 45+6, 7, 14)];
    [jiantouV setImage:[UIImage imageNamed:@"geren-jiantou.png"]];
    [self.view addSubview:jiantouV];
    
    
    //头像图片
    
    UIView *backFaceView = [[UIView alloc]initWithFrame:CGRectMake(23.5, 19.5+6, 63, 63)];
    backFaceView.backgroundColor = [UIColor whiteColor];
    backFaceView.layer.cornerRadius = 5;
    backFaceView.layer.borderColor = [RGBCOLOR(211, 211, 211)CGColor];
    backFaceView.layer.borderWidth = 0.3;
    backFaceView.layer.masksToBounds = YES;
    
    
    self.userFaceImageView = [[GavatarView alloc]initWithFrame:CGRectMake(24, 20+6, 62, 62)];
    self.userFaceImageView.layer.cornerRadius = 5;
    self.userFaceImageView.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    self.userFaceImageView.layer.borderColor = [[UIColor whiteColor] CGColor];//设置边框的颜色
    self.userFaceImageView.layer.masksToBounds = YES;
    self.userFaceImageView.userInteractionEnabled = YES;
    __weak typeof(self)bself = self;
    [self.userFaceImageView setAvatarClickedBlock:^{
        [bself doTap];
    }];
    
    
    [self.view addSubview:backFaceView];
    [self.view addSubview:self.userFaceImageView];
    
    if ([GlocalUserImage getUserFaceImage]) {
        [self.userFaceImageView setImage:[GlocalUserImage getUserFaceImage]];
    }else{
        [self.userFaceImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"geren_morentouxiang126_126.png"]];
    }
    
    
    
    
    
    
    
    //用户名
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImageView.frame)+12, 30, 188, 18)];
    //self.userNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    
    [self.view addSubview:self.userNameLabel];
    
    //个性签名
    self.userWordsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+3, 169, 40)];
    self.userWordsLabel.font = [UIFont systemFontOfSize:12];
    self.userWordsLabel.textColor = [UIColor grayColor];
    self.userWordsLabel.numberOfLines = 2;
    
    [self.view addSubview:self.userWordsLabel];
    
    //图片数组
    NSMutableArray *picsArray = [NSMutableArray array];
    UIImage *zuji = [UIImage imageNamed:@"geren_zuji_up212_212.png"];
    UIImage *haoyou = [UIImage imageNamed:@"geren_haoyou_up212_212.png"];
    UIImage *xiaoxi = [UIImage imageNamed:@"geren_xiaoxi_up212_212.png"];
    UIImage *saoyisao = [UIImage imageNamed:@"geren_sao_up212_212.png"];
    UIImage *qingchu = [UIImage imageNamed:@"geren_qingchu_up212_212.png"];
    UIImage *fankui = [UIImage imageNamed:@"geren_l_up212_212.png"];
    
    [picsArray addObject:zuji];
    [picsArray addObject:haoyou];
    [picsArray addObject:xiaoxi];
    [picsArray addObject:saoyisao];
    [picsArray addObject:qingchu];
    [picsArray addObject:fankui];
    
    NSMutableArray *picsArray1 = [NSMutableArray array];
    UIImage *zuji1 = [UIImage imageNamed:@"geren_zuji_down212_212.png"];
    UIImage *haoyou1 = [UIImage imageNamed:@"geren_haoyou_down212_212.png"];
    UIImage *xiaoxi1 = [UIImage imageNamed:@"geren_xiaoxi_down212_212.png"];
    UIImage *saoyisao1 = [UIImage imageNamed:@"geren_sao_down212_212.png"];
    UIImage *qingchu1 = [UIImage imageNamed:@"geren_qingchu_down212_212.png"];
    UIImage *fankui1 = [UIImage imageNamed:@"geren_l_down212_212.png"];
    
    [picsArray1 addObject:zuji1];
    [picsArray1 addObject:haoyou1];
    [picsArray1 addObject:xiaoxi1];
    [picsArray1 addObject:saoyisao1];
    [picsArray1 addObject:qingchu1];
    [picsArray1 addObject:fankui1];
    
    
    
    
    
    
    
    
    
    
    
    //分割线
    
    //横线
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userFaceView.frame), 320, 1)];
    view1.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame)+106, 320, 1)];
    view2.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame)+106, 320, 1)];
    view3.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view3];
    
    //竖线
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(106, 103+6, 1, 107+107)];
    view4.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view4];
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view4.frame)+106, 103+6, 1, view4.frame.size.height)];
    view5.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view5];
    
    
    
    
    //按钮
    NSArray *btnNameArray = @[@"我的足迹",@"我的好友",@"我的消息",@"扫一扫",@"清除缓存",@"意见反馈"];
    for (int i=0; i<6; i++) {
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(107*(i%3), (321/3)*(i/3)+103+6+1, 106, 106)];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor whiteColor];
        
        UIImage *imag = picsArray[i];
        UIImage *imag1 = picsArray1[i];
        NSString *title = [[NSString alloc]init];
        title = btnNameArray[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        //设置图文
        [btn setBackgroundImage:imag forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn setBackgroundImage:imag1 forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(25, 40, 60, 40)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(70, 20, 22, 20)];
        
        
        
        
        [self.view addSubview:btn];
    }
    
    
    
    UIButton *fbBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 324, 320, 75)];
    fbBtn.tag = 16;
    
    [fbBtn setBackgroundImage:[UIImage imageNamed:@"geren_guanyu_up460_148.jpg"] forState:UIControlStateNormal];
    [fbBtn setBackgroundImage:[UIImage imageNamed:@"geren_guanyu_down460_148.jpg"] forState:UIControlStateHighlighted];
    [fbBtn setTitle:@"关于fb圈" forState:UIControlStateNormal];
    fbBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fbBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -94, 0, 0)];
    [fbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fbBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbBtn];
    //箭头
    UIImageView *fbJiantouView = [[UIImageView alloc]initWithFrame:CGRectMake(286, 354, 8, 15)];
    fbJiantouView.image = [UIImage imageNamed:@"geren_jiantou30_16.png"];
    [self.view addSubview:fbJiantouView];
    
    //分割线
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fbBtn.frame), 320, 1)];
    view6.backgroundColor = RGBCOLOR(225, 225, 225);
    [self.view addSubview:view6];
    
    
    
    
    //两个小红点
    self.red1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 7)];
    self.red1.center = CGPointMake(176, 135);
    self.red1.backgroundColor = [UIColor whiteColor];
    self.red1.layer.cornerRadius = 3.5;
    self.red1.hidden = YES;
    [self.view addSubview:self.red1];
    
    self.red2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 7)];
    self.red2.center = CGPointMake(176+110, 135);
    self.red2.backgroundColor = [UIColor redColor];
    self.red2.layer.cornerRadius = 3.5;
    self.red2.hidden = YES;
    [self.view addSubview:self.red2];
    
    //self.dic = @{@"friend": @"new",@"message":@"new"};
    
    NSDictionary *dic = self.dic;
    if ([[dic objectForKey:@"friend"]isEqualToString:@"new"]) {//有好友消息
        self.red1.hidden = NO;
    }
    if ([[dic objectForKey:@"message"]isEqualToString:@"new"]) {//有我的消息
        self.red2.hidden = NO;
    }
    
    
    
    
    
    
    
    
    
    
    //请求网络数据
    [self prepareNetData];
    
    
    
    
}




//6个按钮的点击
-(void)btnClicked:(UIButton*)sender{
    
    switch (sender.tag) {
            
        case 10://足迹
        {
            //推到我的足迹界面
            GmyFootViewController *gmyFootVC = [[GmyFootViewController alloc]init];
            [self.navigationController pushViewController:gmyFootVC animated:YES];
        }
            break;
        case 11://好友
        {
            if (self.red1.hidden == NO) {
                self.red1.hidden = YES;
            }
            
            FriendListViewController *_friendListV=[[FriendListViewController alloc]init];
            [self.navigationController pushViewController:_friendListV animated:YES];
            
            
        }
            break;
        case 12://消息
        {
            if (self.red2.hidden == NO) {
                self.red2.hidden = YES;
            }
            //张少南 跳到消息的
//            MessageViewController *messageVC = [[MessageViewController alloc]init];
//            messageVC.system_notification_dictionary = self.dic;
//            [self.navigationController pushViewController:messageVC animated:YES];
            
        }
            break;
        case 13://扫一扫
        {
            
            [self loopDrawLine];
            
        }
            break;
        case 14://清除缓存
        {
            //清除缓存
            [self clearTmpPics];
            
        }
            break;
            
        case 15://意见反馈
        {
            
            UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
            feedbackViewController.appkey = @"5368ab4256240b6925029e29";
            [self.navigationController pushViewController:feedbackViewController animated:YES];
            
        }
            break;
            
        case 16://关于
        {
            AboutFBQuanViewController *_aboutV=[[AboutFBQuanViewController alloc]init];
            
            [self.navigationController pushViewController:_aboutV animated:YES];
        }
            
        default:
            break;
    }
    
}

#pragma mark - 清除缓存
-(void)removeCache
{
    
    
    
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/data"];
    NSString *strdate=[NSString stringWithFormat:@"成功清除缓存%@",[SzkAPI fileSizeAtPath:path]];
    [[SDImageCache sharedImageCache] clearDisk];
    
    
    //弹出提示信息
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:strdate delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    
    
    
//    //document路径
//    NSString *documentPathStr = [GlocalUserImage documentFolder];
//    NSString *userFace = @"/guserFaceImage.png";
//    NSString *userBanner = @"/guserBannerImage.png";
//    //文件管理器
//    NSFileManager *fileM = [NSFileManager defaultManager];
//    //清除 头像和 banner
//    [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
//    [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userBanner] error:nil];
    
    
    
    //    //清除图片
    [[FullyLoaded sharedFullyLoaded] removeAllCacheDownloads];
    
    
    
    //上传标志位
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpBanner"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
    
    
    
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    
    UIAlertView *_alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:clearCacheName delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [_alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求网络数据

-(void)prepareNetData{
    
    
    FBCirclePersonalModel *fbPersonModel = [[FBCirclePersonalModel alloc]init];
    
    [fbPersonModel loadPersonWithUid:[[NSUserDefaults standardUserDefaults] objectForKey:USERID] WithBlock:^(FBCirclePersonalModel *model) {
        
        
        self.personModel = model;
        NSLog(@"danteng===%@",self.personModel.person_face);
        [self.userFaceImageView setImageWithURL:[NSURL URLWithString:self.personModel.person_face] placeholderImage:[UIImage imageNamed:@"headimg150_150.png"]];
        self.userNameLabel.text = self.personModel.person_username;
        self.userWordsLabel.text = self.personModel.person_words;
        
        
        
        
    } WithFailedBlcok:^(NSString *string) {
        
    }];
    
}


#pragma 头像点击跳转个人设置
-(void)doTap{
    GRXX4ViewController *grxx4 = [[GRXX4ViewController alloc]init];
    //grxx4.isPersonalSettingClicked = YES;
    grxx4.passUserid = [SzkAPI getUid];
    [self.navigationController pushViewController:grxx4 animated:YES];
    
}






#pragma mark-扫一扫
//扫一扫

-(void)loopDrawLine
{
    GscanfViewController *gscanf = [[GscanfViewController alloc]init];
    gscanf.delegete = self;
    [self presentViewController:gscanf animated:YES completion:^{
        
    }];
    
}


//扫完的回调
-(void)pushWebViewWithStr:(NSString *)stringValue{
    NSLog(@"%s",__FUNCTION__);
    
    FBCircleWebViewController *fbwebvc = [[FBCircleWebViewController alloc]init];
    fbwebvc.web_url = stringValue;
    
    [self.navigationController pushViewController:fbwebvc animated:YES];
    
}






@end