//
//  GRXX4ViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-6-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GRXX4ViewController.h"

#import "GlocalUserImage.h"

#import "MainViewController.h"

#import "MineViewController.h"


#import "GcustomActionSheet.h"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#import "MBProgressHUD.h"

@interface GRXX4ViewController ()
{
    GcustomActionSheet *_gactionsheet;
    MBProgressHUD *_hud;
    MBProgressHUD *_hud1;
    
}
@end

@implementation GRXX4ViewController

- (void)dealloc
{
  
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.isTuichuDenglu) {
        self.tabBarController.selectedIndex = 0;
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.cellType = 10;
    
    _row4section1BtnClicked = NO;
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.titleLabel.text = @"个人资料";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    //设置左右barBtn样式
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeDelete];
    
    
    
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self selector:@selector(prepareNetData) name:@"chagePersonalInformation" object:nil];
    
    
    
    
    isUpDiqu = NO;
    
    //主tableview
    self.navigationItem.title = @"个人信息";
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
    
    
    
    
    if ([self.passUserid isEqualToString:[SzkAPI getUid]]) {//自己
        self.cellType = GRXX1;
        [_tableView reloadData];
    };
    
    
    
    //判断是否为好友 判断完成之后请求网络数据
    
    
    _hud = [ZSNApi showMBProgressWithText:@"正在加载" addToView:self.view];
    _hud.delegate = self;
    
    
    
    [self panduanIsFriend];

    
}



-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud.delegate = nil;
    hud = nil;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    [self.view addSubview:_tableView];
//    [_tableView reloadData];
    
    
    
    //pickerview后面的view
    _backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 250)];
    _backPickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backPickView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(areaQueDing) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(270, 0, 35, 35)];
    [_backPickView addSubview:btn];
    
    //地区pickview
    _pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, DEVICE_WIDTH, 250)];
    _pickeView.delegate = self;
    _pickeView.dataSource = self;
    [_backPickView addSubview:_pickeView];
    _isChooseArea = NO;
    
    
}


-(void)areaQueDing{
    _isChooseArea = !_isChooseArea;
    [self areaHidden];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
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
                
            }];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
        
        
    }
    
    
    
    
}



#pragma mark - UITableViewDataSource && UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    num = 7;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GpersonCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GpersonCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    
    //足迹图片个数根据count设置图片坐标
    cell.imaCount = 0;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    
    
    //判断是否为好友
    if (self.cellType == GRXX2) {//是好友
        [cell loadCustomViewWithIndexPath:indexPath model:self.personModel GRXX:GRXX2 wenzhangArray:self.wenzhangArray];
        
        if (indexPath.row == 0 ) {//头像点击放大
            __weak typeof(cell) _weakCell=cell;
            __weak typeof(self) bself = self;
            
            //背景
            GavatarView *backview = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-40, 40, 0, 0)];
            backview.userInteractionEnabled = YES;
            backview.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
            
            __weak typeof (backview)_wbackview = backview;
            
            //头像
            GavatarView *view = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            
            
            __weak typeof (view) bview = view;
            
            //设置背景view点击的block
            [backview setAvatarClickedBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    _wbackview.frame =  CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                    view.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    [_wbackview removeFromSuperview];
                }];
            }];
            
            //设置头像点击的block
            [cell.touxiangImaView setAvatarClickedBlock:^{
                [bself.view addSubview:backview];
                [UIView animateWithDuration:0.2 animations:^{
                    bview.frame = CGRectMake(20, 20, 200, 200);
                    backview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
                } completion:^(BOOL finished) {
                    
                }];
                
                [view setImage:_weakCell.touxiangImaView.image];
                [view setAvatarClickedBlock:^{
                    [UIView animateWithDuration:0.2 animations:^{
                        backview.frame = CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                        bview.frame = CGRectMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        [backview removeFromSuperview];
                    }];
                    
                }];
                
                view.center = backview.center;
                [backview addSubview:view];
                
            }];
        }else if (indexPath.row == 6){
            __weak typeof (self)bself = self;
            [cell setfaxiaoxiClickedBlock:^{
                NSLog(@"在此处设置发消息的block");
                
                [bself faxiaoxiBlockMethod];
            }];
        }
        
    }else if(self.cellType == GRXX4){//非好友 正在添加中
        
        [cell loadCustomViewWithIndexPath:indexPath model:self.personModel GRXX:GRXX4 wenzhangArray:self.wenzhangArray];
        
        if (indexPath.row == 0) {//头像点击放大缩小
            __weak typeof(cell) _weakCell=cell;
            __weak typeof(self) bself = self;
            //背景
            GavatarView *backview = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-40, 40, 0, 0)];
            backview.userInteractionEnabled = YES;
            backview.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
            __weak typeof (backview)_wbackview = backview;
            //头像
            GavatarView *view = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            __weak typeof (view) bview = view;
            
            //设置背景view点击的block
            [backview setAvatarClickedBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    _wbackview.frame =  CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                    view.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    [_wbackview removeFromSuperview];
                }];
            }];
            
            //设置头像点击的block
            [cell.touxiangImaView setAvatarClickedBlock:^{
                [bself.view addSubview:backview];
                [UIView animateWithDuration:0.2 animations:^{
                    bview.frame = CGRectMake(20, 20, 200, 200);
                    backview.frame = CGRectMake(0, 0, 320, DEVICE_HEIGHT-64);
                } completion:^(BOOL finished) {
                    
                }];
                [view setImage:_weakCell.touxiangImaView.image];
                [view setAvatarClickedBlock:^{
                    [UIView animateWithDuration:0.2 animations:^{
                        backview.frame = CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                        bview.frame = CGRectMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        [backview removeFromSuperview];
                    }];
                    
                }];
                view.center = backview.center;
                [backview addSubview:view];
                
            }];
        }else if (indexPath.row == 6){
            
        }
    }else if(self.cellType == GRXX1){//自己
        [cell loadCustomViewWithIndexPath:indexPath model:self.personModel GRXX:GRXX1 wenzhangArray:self.wenzhangArray];
        if (indexPath.row == 0) {//头像点击放大
            cell.separatorInset = UIEdgeInsetsZero;
            __weak typeof(cell) _weakCell=cell;
            __weak typeof(self) bself = self;
            //背景
            GavatarView *backview = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-40, 40, 0, 0)];
            backview.userInteractionEnabled = YES;
            backview.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
            __weak typeof (backview)_wbackview = backview;
            //头像
            GavatarView *view = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            __weak typeof (view) bview = view;
            
            //设置背景view点击的block
            [backview setAvatarClickedBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    _wbackview.frame =  CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                    view.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    [_wbackview removeFromSuperview];
                }];
            }];
            
            //设置头像点击的block
            [cell.touxiangImaView setAvatarClickedBlock:^{
                
                
                [bself.view addSubview:backview];
                [UIView animateWithDuration:0.2 animations:^{
                    bview.frame = CGRectMake(20, 20, 200, 200);
                    backview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
                } completion:^(BOOL finished) {
                    
                }];
                
                [view setImage:_weakCell.touxiangImaView.image];
                [view setAvatarClickedBlock:^{
                    [UIView animateWithDuration:0.2 animations:^{
                        backview.frame = CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                        bview.frame = CGRectMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        [backview removeFromSuperview];
                    }];
                    
                }];
                view.center = backview.center;
                [backview addSubview:view];
                
            }];
        }
        
        //自定义actionsheet
//         _gactionsheet = [[GcustomActionSheet alloc]initWithTitle:nil buttonTitles:@[@"退出登录"] buttonColor:RGBCOLOR(234, 81, 85) CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
        _gactionsheet = [[GcustomActionSheet alloc]initWithTitle:nil logOutBtnImageName:@"ext.png" logOutBtnTitle:@"退出登录" buttonColor:nil CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
        _gactionsheet.tag = 50001;
        _gactionsheet.delegate = self;
        __weak typeof (_gactionsheet)bgactionsheet = _gactionsheet;
        __weak typeof (self)bself = self;

        [cell setTuichudengluClickedBlock:^{
            
            [bgactionsheet showInView:bself.view WithAnimation:YES];
            
        }];

        
    }else if(self.cellType == GRXX3){//非好友
        
        [cell loadCustomViewWithIndexPath:indexPath model:self.personModel GRXX:GRXX3 wenzhangArray:self.wenzhangArray];
        
        if (indexPath.row == 0) {//头像点击放大缩小
            __weak typeof(cell) _weakCell=cell;
            __weak typeof(self) bself = self;
            //背景
            GavatarView *backview = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-40, 40, 0, 0)];
            backview.userInteractionEnabled = YES;
            backview.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
            __weak typeof (backview)_wbackview = backview;
            //头像
            GavatarView *view = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            __weak typeof (view) bview = view;
            
            //设置背景view点击的block
            [backview setAvatarClickedBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    _wbackview.frame =  CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                    view.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    [_wbackview removeFromSuperview];
                }];
            }];
            
            //设置头像点击的block
            [cell.touxiangImaView setAvatarClickedBlock:^{
                [bself.view addSubview:backview];
                [UIView animateWithDuration:0.2 animations:^{
                    bview.frame = CGRectMake(20, 20, 200, 200);
                    backview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
                } completion:^(BOOL finished) {
                    
                }];
                [view setImage:_weakCell.touxiangImaView.image];
                [view setAvatarClickedBlock:^{
                    [UIView animateWithDuration:0.2 animations:^{
                        backview.frame = CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                        bview.frame = CGRectMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        [backview removeFromSuperview];
                    }];
                    
                }];
                view.center = backview.center;
                [backview addSubview:view];
                
            }];
        }else if (indexPath.row == 6){
            __weak typeof (self)bself = self;
            [cell setJiahaoyouClickedBlock:^{
                [bself jiahaoyouBlockMethod];
            }];
        }
        
        
        
    }else if(self.cellType == GRXX5){//接到邀请
        [cell loadCustomViewWithIndexPath:indexPath model:self.personModel GRXX:GRXX5 wenzhangArray:self.wenzhangArray];
        
        if (indexPath.row == 0) {//头像点击放大缩小
            
            __weak typeof(cell) _weakCell=cell;
            __weak typeof(self) bself = self;
            //背景
            GavatarView *backview = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-40, 40, 0, 0)];
            backview.userInteractionEnabled = YES;
            backview.backgroundColor = RGBACOLOR(255, 255, 255, 0.9);
            __weak typeof (backview)_wbackview = backview;
            //头像
            GavatarView *view = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            __weak typeof (view) bview = view;
            
            //设置背景view点击的block
            [backview setAvatarClickedBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    _wbackview.frame =  CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                    view.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    [_wbackview removeFromSuperview];
                }];
            }];
            
            //设置头像点击的block
            [cell.touxiangImaView setAvatarClickedBlock:^{
                [bself.view addSubview:backview];
                [UIView animateWithDuration:0.2 animations:^{
                    bview.frame = CGRectMake(20, 20, 200, 200);
                    backview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
                } completion:^(BOOL finished) {
                    
                }];
                [view setImage:_weakCell.touxiangImaView.image];
                [view setAvatarClickedBlock:^{
                    [UIView animateWithDuration:0.2 animations:^{
                        backview.frame = CGRectMake(DEVICE_WIDTH-40, 40, 0, 0);
                        bview.frame = CGRectMake(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        [backview removeFromSuperview];
                    }];
                    
                }];
                view.center = backview.center;
                [backview addSubview:view];
                
            }];
        }else if (indexPath.row == 6){
            __weak typeof (self)bself = self;
            [cell setYaoqingClickedBlock:^{
                [bself yaoqingBlockMethod];
            }];
        }
    }
    
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row == 0) {//头像
        cell.backgroundColor = RGBCOLOR(244, 244, 244);
    }if (indexPath.row == 6 || indexPath.row == 1) {//按钮和用户名
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{//其他
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBCOLOR(244, 244, 244);
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
    
    if (indexPath.row == 0 || indexPath.row == 5) {
        cell.separatorInset = UIEdgeInsetsZero;
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0,17,0,0);
    }
    
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat num = 0;
    
    if (indexPath.row == 0) {//头像
        num = 81;
    }else if(indexPath.row == 5){//足迹
        num = 83;
    }else if (indexPath.row ==6){//最下面按钮
        num = 155;
    }
    else{
        num = 47;
    }
    
    return num;
}







-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.cellType == GRXX1) {//自己
        if (indexPath.row == 0 ) {//更改头像
            //自定义actionSheet
            GcustomActionSheet *acts = [[GcustomActionSheet alloc]initWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] buttonColor:RGBCOLOR(31, 188, 34) CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
            acts.tag = 50000;
            acts.delegate = self;
            [acts showInView:self.view WithAnimation:YES];
            
            
        }else if (indexPath.row == 4){//个性签名
            NSLog(@"更改个性签名");
            NSLog(@"%@",self);
            GQianmingViewController *gxqmvc = [[GQianmingViewController alloc]init];
            gxqmvc.yuanlaiQianming = self.yuanlaiQianming;//原来签名传值
            gxqmvc.delegate = self;
            
            [self PushToViewController:gxqmvc WithAnimation:YES];
            
            
        }else if(indexPath.row == 2){//选择性别
            
            NSLog(@"%@",self.gender);
            //判断是否修改过性别
            
            if ([self.gender isEqualToString:@"0"]) {//没修改过
                
                UIAlertView *gender = [[UIAlertView alloc]initWithTitle:@"选择性别" message:@"只能选择一次,下次不能修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
                [gender show];
                
            }else{//修改过
                
            }
        }
        
        
        //另外一个单独if 判断是否选择地区 如果点击的不是 row1 section1的话 收回地址选择pickerview
        if (indexPath.row == 3) {//选择地区
            
            if (_isChooseArea == NO) {
                [self areaShow];
            }else{
                [self areaHidden];
            }
            
            _isChooseArea = !_isChooseArea;
            
            
            
        } else{
            _isChooseArea = NO;
            [self areaHidden];
        }
        
        
    }
    
    
    
    
    //根据 我 好友 非好友 进行足迹的跳转
    
    if (indexPath.row == 5) {
        NSLog(@"%s",__FUNCTION__);
        
        if (self.cellType == GRXX2) {//好友
            GHaoYouFootViewController *ghaoyou = [[GHaoYouFootViewController alloc]init];
            ghaoyou.userId = self.passUserid;
            [self.navigationController pushViewController:ghaoyou animated:YES];
        }else if (self.cellType == GRXX3 || self.cellType == GRXX4 || self.cellType == GRXX5){//非好友
            GfeiHaoyouFootViewController *gfeihaoyou = [[GfeiHaoyouFootViewController alloc]init];
            gfeihaoyou.userId = self.passUserid;
            [self.navigationController pushViewController:gfeihaoyou animated:YES];
        }else if(self.cellType == GRXX1){//自己
            if (self.isGmyFootPass) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                GmyFootViewController *gmyfoot = [[GmyFootViewController alloc]init];
                [self PushToViewController:gmyfoot WithAnimation:YES];
//                [self.navigationController pushViewController:gmyfoot animated:YES];
            }
            
        }
        
    }
}


#pragma mark - 加好友上传(文本) 加好友block方法
-(void)jiahaoyouBlockMethod{
    
    if (!_row4section1BtnClicked) {
        _row4section1BtnClicked = YES;
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
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }else{
                        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"添加失败" message:errorindo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [aler show];
                        NSLog(@"xxssx===%@",arrayinfo);
                        _row4section1BtnClicked = NO;
                    }
                    
                }];
            }
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    
    
    
    
    
}


-(void)faxiaoxiBlockMethod{
#pragma 在此设置发消息的跳转
    
    
    
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





#pragma mark - 请求网络数据
-(void)prepareNetData{
    
    
    __block BOOL isLoadUserInfoSuccess = NO;
    __block BOOL isLoadWenzhangInfoSuccess = NO;
    
    @try {
        __weak typeof(self) bself = self;
        __weak typeof (_hud)bhud = _hud;
//        __weak typeof (_isLoadUserInfoSuccess)bisLoadUserInfoSuccess = _isLoadUserInfoSuccess;
//        __weak typeof (_isLoadWenzhangInfoSuccess)bisLoadWenzhangInfoSuccess = _isLoadWenzhangInfoSuccess;
        //请求用户信息
        self.personModel = [[FBCirclePersonalModel alloc]init];
        
        [self.personModel loadPersonWithUid:self.passUserid WithBlock:^(FBCirclePersonalModel *model) {
            bself.personModel = model;
            bself.userName = model.person_username;
            
            NSLog(@"用户性别-------%@",model.person_gender);
            
            bself.gender = model.person_gender;//性别
            bself.yuanlaiQianming = model.person_words;//签名
            
            isLoadUserInfoSuccess = YES;
            if (isLoadUserInfoSuccess && isLoadWenzhangInfoSuccess) {
                [bself hudWasHidden:bhud];
            }
            
        } WithFailedBlcok:^(NSString *string) {
            
        }];
        
        
        
        
        //请求文章数据
//        FBCircleModel *fbModel = [[FBCircleModel alloc]init];
//        self.fbModel = fbModel;
//        [fbModel initHttpRequestWithUid:self.passUserid Page:1 WithType:2 WithCompletionBlock:^( NSMutableArray *array) {
//            
//            bself.wenzhangArray = array;
//            
//            isLoadWenzhangInfoSuccess = YES;
//            if (isLoadWenzhangInfoSuccess && isLoadUserInfoSuccess) {
//                [bself hudWasHidden:bhud];
//            }
//            
//        } WithFailedBlock:^(NSString *operation) {
//            
//        }];
        NSString *zujiStr = @"http://fb.fblife.com/openapi/index.php?mod=getweibo&code=mylist&fromtype=b5eeec0b&authkey=%@&page=%d&fbtype=json&uid=%@";
        NSString* fullURL = [NSString stringWithFormat:zujiStr,[SzkAPI getAuthkeyGBK],1,[SzkAPI getUid]];
        NSLog(@"请求足迹接口 : %@",fullURL);
        ASIHTTPRequest * weiBo_request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fullURL]];
        [weiBo_request setPersistentConnectionTimeoutSeconds:60];
        [weiBo_request startAsynchronous];
        __weak typeof(weiBo_request)wRequest = weiBo_request;
        [wRequest setCompletionBlock:^{
            NSDictionary * rootObject = [[NSDictionary alloc] initWithDictionary:[weiBo_request.responseData objectFromJSONData]];
            NSString *errcode =[NSString stringWithFormat:@"%@",[rootObject objectForKey:ERRCODE]];
            
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary* userinfo = [rootObject objectForKey:@"weiboinfo"];
                
                NSLog(@"-----%@",userinfo);
                
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                NSArray * arr = [ZSNApi sortArrayWith:[userinfo allKeys]];
                NSMutableArray * temp = [NSMutableArray array];
                for (int i = 0;i < arr.count;i++) {
                    NSString * key = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
                    FBCircleModel * model = [[FBCircleModel alloc] initWithDictionary:[userinfo objectForKey:key]];
                    [temp addObject:model];
                }
                [array addObjectsFromArray:temp];
                bself.wenzhangArray = array;

                isLoadWenzhangInfoSuccess = YES;
                if (isLoadWenzhangInfoSuccess && isLoadUserInfoSuccess) {
                    [bself hudWasHidden:bhud];
                }
                
            }
            
            
            
        }];
        
//        [wRequest setFailedBlock:^{
//            [ZSNApi showAutoHiddenMBProgressWithText:@"加载失败" addToView:self.view];
//        }];
        
        
        
        
        
    }
    @catch (NSException *exception) {
        
        
        
        
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    @finally {
        
    }
    
    
    
    
}




#pragma mark - 退出登录block
-(void)tuichudengluBlock{
    
    if (!_row4section1BtnClicked) {
        
        _row4section1BtnClicked = YES;
        
        
        
        NSLog(@"authkey===%@",[SzkAPI getAuthkey]);

        NSUserDefaults *standUDef=[NSUserDefaults standardUserDefaults];
        [standUDef setObject:@""  forKey:AUTHERKEY];
        [standUDef setObject:@""  forKey:USERID];
        [standUDef setObject:@""  forKey:USERNAME];
        [standUDef setObject:@"" forKey:USERFACE];
        [standUDef synchronize];
        
        
        NSLog(@"authkey===%@",[SzkAPI getAuthkey]);
        
        
        
        
        [standUDef removeObjectForKey:@"SuggestFriendViewControllerADDRESSBOOKARRAY"];
        [standUDef removeObjectForKey:@"ADDRESSBOOKARRAY"];
        [[NSNotificationCenter defaultCenter] postNotificationName:SUCCESSLOGOUT object:nil];
        
//        //document路径
//        NSString *documentPathStr = [GlocalUserImage documentFolder];
//        //文件管理器
//        NSFileManager *fileM = [NSFileManager defaultManager];
//        //清除document文件包
//        [fileM removeItemAtPath:documentPathStr error:nil];
        
        
        
        //上传标志位
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpBanner"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
        
        
        
        //document路径
        NSString *documentPathStr = [GlocalUserImage documentFolder];
        NSString *userFace = @"/guserFaceImage.png";
        NSString *userBanner = @"/guserBannerImage.png";
        
        
        //文件管理器
        NSFileManager *fileM = [NSFileManager defaultManager];
        
        //清除 头像和 banner
        
        [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
        
        [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userBanner] error:nil];
        
        
        
        @try {
            SzkLoadData *_test=[[SzkLoadData alloc]init];
            NSString *str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=dologout&authkey=%@&fbtype=json",[SzkAPI getAuthkey]];
            [_test SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
                
                if (errcode==0) {
                    NSLog(@"成功");
                    
                }else{
                    NSLog(@"xxssx===%@",arrayinfo);
                }
                
            }];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
        
    
        
        self.isTuichuDenglu = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    }
    
}







#pragma mark - 选择性别 UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 1://男
            NSLog(@"男");
            self.gender = @"1";
            
            _hud1 = [ZSNApi showMBProgressWithText:@"正在提交" addToView:self.view];
            _hud1.delegate = self;
            
            [self testGender];//上传
            break;
            
        case 2://女
            NSLog(@"女");
            self.gender = @"2";
            
            _hud1 = [ZSNApi showMBProgressWithText:@"正在提交" addToView:self.view];
            _hud1.delegate = self;
            
            [self testGender];//上传
            
        default:
            break;
    }
}


#pragma mark - 地区选择弹出
-(void)areaShow{//地区出现
    NSLog(@"_backPickView");
    [UIView animateWithDuration:0.3 animations:^{
        if (iPhone5) {
            _backPickView.frame = CGRectMake(0, 280*DEVICE_HEIGHT/568.0, DEVICE_WIDTH, 250);
        }else{
            _backPickView.frame = CGRectMake(0, 280*DEVICE_HEIGHT/568.0, DEVICE_WIDTH, 250);//CGRectMake(0, 218, DEVICE_WIDTH, 250)
        }
        
    }];
    
    
}

-(void)areaHidden{//地区隐藏
    
    [UIView animateWithDuration:0.3 animations:^{
        if (iPhone5) {
            _backPickView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 216);
        }else{
            _backPickView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 216);
        }
        
    }];
    
    NSLog(@"在此上传用户设置的地区信息");
    
    
    NSLog(@"%@ %@",self.province,self.city);
    if (self.province.length==0||self.city.length == 0) {
        
        NSLog(@"未选择省或市");
        
    }else{
        
        _hud1 = [ZSNApi showMBProgressWithText:@"正在提交" addToView:self.view];
        _hud1.delegate = self;
        
        [self testdiqu];
        
    }
    
}



//#pragma mark - UIActionSheetDelegate
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    
//}


#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s",__FUNCTION__);
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
        imageCrop.ratioOfWidthAndHeight = 400.0f/400.0f;//设置缩放比例
        
        imageCrop.image = scaleImage;
        //[imageCrop showWithAnimation:NO];
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
        
        
        
        
        
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

//按像素缩放
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}











#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    if (component == 0) {
        return _data.count;
        
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    if (component == 0) {
        self.province = _data[row][@"State"];
        if ([self.province isEqualToString:@"省份"]) {
            self.province = @"";
        }
        return _data[row][@"State"];
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        self.city = cities[row][@"city"];
        if ([self.city isEqualToString:@"市区县"]) {
            self.city =@"";
        }
        return cities[row][@"city"];
        
    }
    
    
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component == 0) {
        _flagRow = row;
    } else if (component == 1) {
        
    }

    [pickerView reloadAllComponents];
    
    
}





#pragma mark - 上传头像(图片)

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)test{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updatehead&authkey=%@",[SzkAPI getAuthkey]];
        
        NSLog(@"上传头像请求的地址===%@     ----%s",fullURL,__FUNCTION__);
        
        //设置标志位
        NSString *str = @"yes";
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        
        request__ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        request__.delegate = _appDelegate;
        request__.tag = 123;
        
        //得到图片的data
        NSData* data;
        //获取图片质量
        NSMutableData *myRequestData=[NSMutableData data];
        [request__ setPostFormat:ASIMultipartFormDataPostFormat];
        data = UIImageJPEGRepresentation(self.userUpFaceImage,0.5);
        NSLog(@"xxxx===%@",data);
        [request__ addRequestHeader:@"uphead" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
        //设置http body
        [request__ addData:data withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"uphead"]];
        
        [request__ setRequestMethod:@"POST"];
        request__.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
        request__.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        [request__ startAsynchronous];
        
    });
    
    
}







#pragma mark - 上传地区信息(文本)
-(void)testdiqu{
    
    __weak typeof (self)bself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SzkLoadData *_test=[[SzkLoadData alloc]init];
        NSString * pstr = [self.province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *cstr = [self.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=area&authkey=%@&province=%@&city=%@",[SzkAPI getAuthkey],pstr,cstr];
        //get
        [_test SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
            if (errcode==0) {
                NSLog(@"成功");
                //发通知
                [bself hudWasHidden:_hud1];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
                
                
            }else{
                [bself hudWasHidden:_hud1];
                
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"更改失败" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
                NSLog(@"xxssx===%@",arrayinfo);
            }
            
        }];
    });
    
    
    
    
    
    
    
    
    
}

#pragma mark - 上传性别信息
-(void)testGender{
    
    
    __weak typeof (self)bself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SzkLoadData *_test = [[SzkLoadData alloc]init];
        
        NSString *str = [[NSString alloc]init];
        
        if ([self.gender isEqualToString:@"1"]) {
            //设置上传接口参数
            str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=gender&gender=1&authkey=%@",[SzkAPI getAuthkey]];
            NSLog(@"xsx==%@",str);
            
            
            
        }else if([self.gender isEqualToString:@"2"]){
            //设置上传接口参数
            str = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=gender&gender=2&authkey=%@",[SzkAPI getAuthkey]];
        }
        
        //上传
        [_test SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
            
            NSLog(@"code==%d",errcode);
            
            if (errcode == 0) {
                
                NSLog(@"%@",arrayinfo);
                NSLog(@"%@",errorindo);
                
                NSLog(@"成功");
                
                [bself hudWasHidden:_hud1];
                
                //发通知
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
                [self prepareNetData];
                
                UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [a show];
                
                
            }else{
                
                [bself hudWasHidden:_hud1];
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"设置失败" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
                
                NSLog(@"errinfo = %@",arrayinfo);
            }
        }];
    });
    
    
    
}



#pragma mark - 接受别人的好友请求
-(void)yaoqingBlockMethod{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof (self)bself = self;
        __weak typeof (_tableView)btableview = _tableView;
        
        NSString *str = [NSString stringWithFormat:ACCEPTAPI,[SzkAPI getAuthkey],self.passUserid];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            bself.cellType = GRXX2;
            [btableview reloadData];
        }];
    });
    
    
    
    
    
    
    
    
}




#pragma mark - crop delegate
#pragma mark - 图片回传协议方法
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    
    //按像素缩放
    //UIImage *doneImage = [self scaleToSize:cropImage size:CGSizeMake(400, 400)];
    
    //用户需要上传的剪裁后的头像image
    self.userUpFaceImage = cropImage;
    NSLog(@"在此设置用户上传的头像");
    self.userUpFaceImagedata = UIImagePNGRepresentation(self.userUpFaceImage);
    
    
    //缓存到本地
    [GlocalUserImage setUserFaceImageWithData:self.userUpFaceImagedata];
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
    
    
    //ASI上传
    [self test];
    
    
    _isChooseTouxiang = YES;
    [_tableView reloadData];
    
}




#pragma mark - GcustomActionSheetDelegate
-(void)zactionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    
    if (actionSheet.tag == 50001) {//退出登录
        if (buttonIndex == 1) {//退出登录
            [self tuichudengluBlock];
        }
    }else if (actionSheet.tag == 50000){//修改头像
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
                
                [self presentViewController:picker animated:YES completion:^{
                    if (IOS7_OR_LATER) {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    }
                }];
                break;
                
            case 0://取消
                break;
                
            default:
                break;
        }
    }
    
}




@end
