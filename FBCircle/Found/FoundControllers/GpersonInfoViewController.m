//
//  GpersonInfoViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


#import "GpersonInfoViewController.h"

#import "GfeiHaoyouFootViewController.h"
#import "GHaoYouFootViewController.h"
#import "ChatViewController.h"

#import "GMAPI.h"


#import "MBProgressHUD.h"
//typedef enum{
//    GRXX1 = 0,//自己
//    GRXX2 ,//好友 接口返回0
//    GRXX3 ,//非好友 接口返回3
//    GRXX4 ,//非好友 正在添加中 接口返回1
//    GRXX5 ,//接到邀请  接口返回2
//}GRXX;
@interface GpersonInfoViewController ()
{
    MBProgressHUD *_hud;
}
@end

@implementation GpersonInfoViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"详细信息";
    
    _hud = [ZSNApi showMBProgressWithText:@"正在加载" addToView:self.view];
    _hud.delegate = self;
    
    //判断是否为好友
    [self panduanIsFriend];
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)btnClicked:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}



#pragma mark - 加载控件
-(void)loadCustomView{
    self.imaCount = 0;
    
    //头像 名字 的背景view==========================================================
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 66)];
    [self.view addSubview:nameView];
    //    nameView.backgroundColor = [UIColor orangeColor];
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 46, 46)];
    [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:self.personModel.person_face]];
    [nameView addSubview:self.userFaceImv];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, CGRectGetMinY(self.userFaceImv.frame)+13, 200, 16)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = self.personModel.person_username;
    [nameView addSubview:nameLabel];
    
    //分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 66, 320, 0.5)];
    line.backgroundColor = RGBCOLOR(230, 229, 234);
    [nameView addSubview:line];
    
    
    
    //信息view======================================================
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(nameView.frame)+21, 320-16-16, 184)];
    infoView.layer.borderWidth = 0.5;
    infoView.layer.borderColor = [RGBCOLOR(229, 230, 232)CGColor];
    infoView.layer.cornerRadius = 5;
    [self.view addSubview:infoView];
    
    //标题titleLabel
    
    NSArray *tLabelArray = @[@"地区",@"个性签名",@"个人相册"];
    
    
    for (int i = 0; i<3; i++) {
        
        UILabel *tLabel = [[UILabel alloc]init];
        
        if (i == 0) {//地区
            tLabel.frame = CGRectMake(12, 18, 50, 13);
            self.userAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tLabel.frame)+14, tLabel.frame.origin.y, 205, 13)];
            NSString *diqu = [self.personModel.person_province stringByAppendingString:self.personModel.person_city];
            self.userAreaLabel.text = [GMAPI exchangeStringForDeleteNULLWithWeiTianXie:diqu];
            self.userAreaLabel.font = [UIFont boldSystemFontOfSize:12];
            self.userAreaLabel.textColor = RGBCOLOR(143, 143, 143);
            [infoView addSubview:self.userAreaLabel];
            
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tLabel.frame)+19, infoView.frame.size.width, 0.5)];
            line.backgroundColor = RGBCOLOR(229, 230, 232);
            [infoView addSubview:line];
            
        }else if (i == 1){//个性签名
            tLabel.frame = CGRectMake(12, 18+13+37, 50, 13);
            self.gexingqianmingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tLabel.frame)+14, tLabel.frame.origin.y, 205, 13)];
            self.gexingqianmingLabel.font = [UIFont boldSystemFontOfSize:12];
            self.gexingqianmingLabel.textColor = RGBCOLOR(143, 143, 143);
            self.gexingqianmingLabel.text = [GMAPI exchangeStringForDeleteNULLWithWeiTianXie:self.personModel.person_words];
            [infoView addSubview:self.gexingqianmingLabel];
            
            
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tLabel.frame)+19, infoView.frame.size.width, 0.5)];
            line.backgroundColor = RGBCOLOR(229, 230, 232);
            [infoView addSubview:line];
            
        }else if (i == 2){//个人相册
            tLabel.frame = CGRectMake(12, 18+13+37+13+52, 50, 13);
        }
        tLabel.textColor = [UIColor blackColor];
        tLabel.font = [UIFont boldSystemFontOfSize:12];
        tLabel.text = tLabelArray[i];
        [infoView addSubview:tLabel];
    }
    
    
    //展示图片的view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(62+14, 112, 182, 56)];
    UITapGestureRecognizer *ttaa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFoot)];
    [view addGestureRecognizer:ttaa];
    
    //足迹展示图片的数组
    NSMutableArray *imavMutableArray = [NSMutableArray arrayWithCapacity:1];
    
    //文章对象
    FBCircleModel *wenzhang = [[FBCircleModel alloc]init];
    
    int count = self.wenzhangArray.count;
    
    //解决wenzhangArray.count等于0崩溃问题
    for (int i =0; i<count; i++) {
        //获得文章对象
        wenzhang = self.wenzhangArray[i];
        
        //获取文章对象中图片的数组
        NSMutableArray *imageArr =wenzhang.fb_image;
        
        //初始化一个dic 里面存图片地址
        if (imageArr.count>0) {//图片数组里有东西
            self.imaCount++;
            //取出第一张图片
            id temp = wenzhang.fb_image[0];
            NSString *str;
            if ([temp isKindOfClass:[NSString class]]) {
                str = temp;
            }else if ([temp isKindOfClass:[NSDictionary class]]){
                str = temp[@"link"];
            }
            
            
            //创建展示图片iamge
            UIImageView *imv = [[UIImageView alloc]init];
            
            @try {
                [imv setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            //把需要展示的图片view放到数组中
            [imavMutableArray addObject:imv];
            
        }
        
        if (self.imaCount == 3) {
            break;//图片数量等于3的时候跳出循环 最多展示3张图片 break跳出for循环走下面的遍历数组 return 直接跳到最后
        }
        
        
    }
    
    //遍历数组 倒着放图片
    NSLog(@"%d",self.imaCount);
    for (int i = 0; i<self.imaCount; i++) {
        UIImageView *imv = imavMutableArray[self.imaCount-i-1];
        imv.frame = CGRectMake(200-(i+1)*63-10, 0, 56, 56);
        [view addSubview:imv];
    }
    
    [infoView addSubview:view];
    
    
    //箭头
    UIImageView *jiantouImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou.png"]];
    jiantouImv.frame = CGRectMake(CGRectGetMaxX(view.frame)+15, CGRectGetMinY(view.frame)+23, 8, 13);
    [infoView addSubview:jiantouImv];
    
    
    
    
    
    //发消息或加好友view==========================================
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(infoView.frame.origin.x, CGRectGetMaxY(infoView.frame)+20, infoView.frame.size.width, 41);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [RGBCOLOR(35, 153, 36)CGColor];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    if (self.cellType == GRXX2) {
        [btn setTitle:@"发消息" forState:UIControlStateNormal];
    }else if (self.cellType == GRXX3){
        [btn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    }else if (self.cellType == GRXX4){
        [btn setTitle:@"正在添加中" forState:UIControlStateNormal];
    }
    [btn setBackgroundColor:RGBCOLOR(36, 192, 38)];
    btn.tag = 11;
    
    [btn addTarget:self action:@selector(bttnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}



-(void)bttnClick:(UIButton*)sender{
    
    
    NSLog(@"----- %d",sender.tag);
    
    
    
    if (sender.tag == 10) {
        
    }else if (sender.tag == 11){
        if (self.cellType == GRXX3) {
            self.cellType = GRXX4;
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            
            //加好友
            
            [self jiahaoyouBlockMethod];
            
            [self loadCustomView];
        }
        
        if (self.cellType == GRXX2) {
            ChatViewController * chatVC = [[ChatViewController alloc] init];
            
            MessageModel * messageInfo = [[MessageModel alloc] init];
            
            messageInfo.othername = self.personModel.person_username;
            
            messageInfo.otheruid = self.personModel.person_uid;
            
            messageInfo.to_uid = self.personModel.person_uid;
            
            messageInfo.to_username = self.personModel.person_username;
            
            chatVC.messageInfo = messageInfo;
            chatVC.otherHeaderImage = self.personModel.person_face;
            
            NSLog(@"%@",chatVC.otherHeaderImage);
            
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }
}



//加好友
-(void)jiahaoyouBlockMethod{
    
        @try {
            SzkLoadData *_test=[[SzkLoadData alloc]init];
            
            NSString * userName = [self.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *userId = [self.passUserid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *str = [NSString stringWithFormat:ADDFRIENDAPI,[SzkAPI getAuthkey],userId,userName];
            
            NSLog(@"添加好友接口:%@",str);
            
            
            if (self.userName == nil) {
            }else{
                //get
                [_test SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
                    
                    if (errcode==0) {
                        NSLog(@"成功");
                        self.cellType = GRXX4;//添加中
                        
                    }else{
                        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"添加失败" message:errorindo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [aler show];
                        NSLog(@"xxssx===%@",arrayinfo);
                    }
                    
                }];
            }
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
}
    






//跳转到足迹
-(void)pushToFoot{
    if (self.cellType == GRXX2) {
        GHaoYouFootViewController *ghaoyouFoot = [[GHaoYouFootViewController alloc]init];
        ghaoyouFoot.userId = self.passUserid;
        [self.navigationController pushViewController:ghaoyouFoot animated:YES];
        
    }else if (self.cellType == GRXX3 ||self.cellType == GRXX4){
        GfeiHaoyouFootViewController *gfeihaoyou = [[GfeiHaoyouFootViewController alloc]init];
        gfeihaoyou.userId = self.passUserid;
        [self.navigationController pushViewController:gfeihaoyou animated:YES];
    }
}

#pragma mark - 请求网络数据
-(void)prepareNetData{
    
    @try {
        __weak typeof(self) bself = self;
        __block BOOL isLoadUserInfoSuccess = NO;
        __block BOOL isLoadWenzhangInfoSuccess = NO;
        __weak typeof (_hud)bhud = _hud;
        
        //请求用户信息
        self.personModel = [[FBCirclePersonalModel alloc]init];
        
        [self.personModel loadPersonWithUid:self.passUserid WithBlock:^(FBCirclePersonalModel *model) {
            bself.personModel = model;
            bself.userName = model.person_username;
            NSLog(@"%@",model.person_gender);
            
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            self.imaCount = 0;
            isLoadUserInfoSuccess = YES;
            if (isLoadUserInfoSuccess && isLoadWenzhangInfoSuccess) {
                [bself hudWasHidden:bhud];
            }
            
           
        } WithFailedBlcok:^(NSString *string) {
            
        }];
        
        //请求文章数据
        FBCircleModel *fbModel = [[FBCircleModel alloc]init];
        [fbModel initHttpRequestWithUid:self.passUserid Page:1 WithType:2 WithCompletionBlock:^( NSMutableArray *array) {
            bself.wenzhangArray = [NSMutableArray arrayWithArray:array];
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            self.imaCount = 0;
            
            isLoadWenzhangInfoSuccess = YES;
            if (isLoadUserInfoSuccess && isLoadWenzhangInfoSuccess) {
                [bself hudWasHidden:bhud];
            }
            
            
        } WithFailedBlock:^(NSString *operation) {
            
        }];
    }
    @catch (NSException *exception) {
        
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    @finally {
        
    }
    
    
    
    
}



#pragma 先判断是否是自己 在判断是否为好友
-(void)panduanIsFriend{//判断是否为好友
    
    //判断是否为好友
    //http://quan.fblife.com/index.php?c=interface&a=checkbuddy&authkey=UmRSMFQ6XzVUZAFvBjAGfQDUBKEJ7FrNUZZR4g2UB+hQhVrZ&uid=1103383
    
    if ([self.passUserid isEqualToString:[SzkAPI getUid]]) {//自己
        self.cellType = GRXX1;//自己
        //请求网络数据
        @try {
            [self prepareNetData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }else{//判断是否为好友
        
        
        @try {
            NSString *str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=checkbuddy&authkey=%@&uid=%@",[SzkAPI getAuthkey],self.passUserid];
            
            
            
            NSLog(@"%@",str);
            
            
            
            NSURL *url = [NSURL URLWithString:str];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (data.length>0) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                    
                        NSLog(@"%@",dic);
                        
                        NSString *a = [NSString stringWithFormat:@"%@",[dic objectForKey:@"errcode"]];
                        
                        NSLog(@"%@",a);
                        
                        
                        if ([a isEqualToString:@"0"]) {//好友 接口返回0
                            self.cellType = GRXX2;
                        }else if ([a isEqualToString:@"1"]){//非好友 正在添加中 接口返回1
                            self.cellType = GRXX4;
                        }else if ([a isEqualToString:@"2"]){//接到邀请  接口返回2
                            self.cellType = GRXX5;
                        }else if([a isEqualToString:@"3"]){//非好友 接口返回3
                            self.cellType = GRXX3;
                        }
                        [self prepareNetData];
                    }
                    
                }else{
                    return;
                }
                
            }];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
        
        
    }
    
    
    
    
}



#pragma mark - MBProgressHUDDelegate
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
    [self loadCustomView];
}


@end
