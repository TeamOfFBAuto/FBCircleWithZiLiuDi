//
//  GmyFootViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmyFootViewController.h"
#import "GRXX4ViewController.h"

#import "GlocalUserImage.h"
//判断系统版本
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface GmyFootViewController ()

@end

@implementation GmyFootViewController


- (void)dealloc
{
    
    
    NSLog(@"123");
    
    NSLog(@"%s",__FUNCTION__);
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _isJiaHaoPick = NO;
    //[self prepareNetDataWithPage:1];
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //适配ios7navigationBar坐标
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    _currentPage = 1;
    
    //接收通知
    
    //更改个人用户信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWenzhangArrayNetDataWithPageOne) name:@"chagePersonalInformation" object:nil];
    
    
    
    
    
    //发布文章
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWenzhangArrayNetDataWithPageOne) name:SUCCESSUPDATA object:nil];
    
    
    
    //设置navigation左右按钮格式类型
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeDelete];
    
    
    //设置navigation的titile
    self.titleLabel.text = @"我的足迹";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    
    //本页是个人足迹页面
    self.userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    
    //主tableveiw
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-64:480-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//设置分割线风格
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    
    
    //如果缓存有数据的话
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([FBCircleModel findGzuji]) {
            [self panxuWenzhangWithArray:[FBCircleModel findGzuji]];
            
            NSLog(@"%d",self.wenzhangTimeArray.count);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        
    });
    
    
    
    
    //下拉刷新
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_tableView.bounds.size.height, 320, _tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    _currentPage = 1;
    _isupMore = NO;//是否为上提加载
    _isUpMoreSuccess = NO;//上提加载是否成功
    
    
    
    //上提加载更多
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _upMoreView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _upMoreView.type = 1;
    _upMoreView.hidden = YES;
    [view addSubview:_upMoreView];
    
    _tableView.tableFooterView = view;
    
    
    //请求网络数据 文章数据 和 用户信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self prepareNetDataWithPage:1];
    });
    
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}


#pragma 按时间排序文章
-(void)panxuWenzhangWithArray:(NSMutableArray *)array{
    //按文章时间分类的二维数组 self.wenzhangTimeArray
    
    [self.wenzhangTimeArray removeAllObjects];
    self.wenzhangTimeArray = [NSMutableArray arrayWithCapacity:1];
    
    int count = array.count;
    
    for (FBCircleModel *timeWZ in array) {
        timeWZ.time = NO;
        timeWZ.timeStr = [GTimeSwitch testtime:timeWZ.fb_deteline];
    }
    
    NSLog(@"%d",count);
    
    //找出同一天的文章 放到一个数组里
    for (int i = 0; i < count; i++) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        
        for (int j = i+1; j<count; j++) {
            FBCircleModel *wz1 = array[i];
            FBCircleModel *wz2 = array[j];
            //判断时间
            if ([wz1.timeStr isEqualToString:wz2.timeStr]) {
                //如果相同并且time = NO 就加入数组里
                
                NSLog(@"%@",wz1.timeStr);
                
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
        
        FBCircleModel *wz1 = array[i];
        if (arr.count == 0 && !wz1.time) {//判断一天只有一个文章的情况
            [arr addObject:wz1];
        }
        
        if (arr.count > 0) {
            
            [self.wenzhangTimeArray addObject:arr];
            
            NSLog(@"%d",self.wenzhangTimeArray.count);
            
            NSLog(@"%d",arr.count);
            
        }
    }
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求网络数据
-(void)prepareNetDataWithPage:(int)thePage{
    
    
    
//    [_tableView reloadData];
    
//    __weak typeof (_tableView)btableView = _tableView;
    
    @try {
        _wzRefresh = NO;
        _perRefresh = NO;
        
        NSLog(@"============================%d  %d",_currentPage,thePage);
        __weak typeof (self)bself = self;
        
        //请求文章信息=======================================================
        self.wenzhangModel = [[FBCircleModel alloc]init];
        
        [self.wenzhangModel initHttpRequestWithUid:[SzkAPI getUid] Page:thePage WithType:2 WithCompletionBlock:^(NSMutableArray *array) {
            
            
                //数据持久化 缓存
                if (thePage == 1) {
                    [bself saveWenzhangDataWithArray:array];
                    
                }
            
            [bself loadWenZhangBlockWithArray:array];
            
        } WithFailedBlock:^(NSString *operation) {
            
            
        }];
        
        
        
        //请求用户信息=======================================================
        
        self.userModel = [[FBCirclePersonalModel alloc]init];
        [self.userModel loadPersonWithUid:[SzkAPI getUid] WithBlock:^(FBCirclePersonalModel *model) {
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



//多线程缓存文件到数据库
-(void)saveWenzhangDataWithArray:(NSArray *)theArray{
        [FBCircleModel deleteAllGzuji];
        for (FBCircleModel *model in theArray) {
            [FBCircleModel addGzuji:model];
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
            

        }else{//不是上提加载更多
            self.wenzhangArray = array;
        }

        //按文章时间分类的二维数组 self.wenzhangTimeArray
    
        int count = self.wenzhangArray.count;
    
        for (FBCircleModel *timeWZ in self.wenzhangArray) {
            timeWZ.time = NO;
            timeWZ.timeStr = [GTimeSwitch testtime:timeWZ.fb_deteline];
        }
    
    

    
    
    
    NSLog(@"%d",count);

        //找出同一天的文章 放到一个数组里
        for (int i = 0; i < count; i++) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            
            for (int j = i+1; j<count; j++) {
                FBCircleModel *wz1 = self.wenzhangArray[i];
                FBCircleModel *wz2 = self.wenzhangArray[j];
                //判断时间
                if ([wz1.timeStr isEqualToString:wz2.timeStr]) {
                    //如果相同并且time = NO 就加入数组里
                    
                    NSLog(@"%@",wz1.timeStr);
                    
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
                
                NSLog(@"%d",arr.count);
                
            }
        }
    
    NSLog(@"%d",self.wenzhangTimeArray.count);
    
    

       _isUpMoreSuccess = YES;//上体加载更多的标志位


    NSLog(@"%@",self.wenzhangTimeArray);

        //有文章再显示上提加载更多
        if (self.wenzhangArray.count>0) {
            _upMoreView.hidden = NO;
        }else{
            _upMoreView.hidden = YES;
        }

    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
        
        
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

        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });

        //数据请求完成之后改变refresh状态
        _perRefresh = YES;
        if (_wzRefresh && _perRefresh) {


            [self doneLoadingTableViewData];
        }
}



#pragma mark - 请求page=1时的文章信息
-(void)reloadWenzhangArrayNetDataWithPageOne{
    _currentPage = 1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self prepareNetDataWithPage:_currentPage];
    });
    
    
    
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }else{
        NSArray *arr = self.wenzhangTimeArray[section -1];
        num = arr.count;
    }
    
    return num;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GmyFootCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GmyFootCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.isHaoyou = NO;//点击头像跳转个人信息页面
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        if (_isChooseTopView) {
            cell.isChangeTopViewImage = YES;
            cell.changeTopImage = self.userUpImage;
            
        }
        //加载个人信息顶部view
        [cell loadRow0CutomViewWithModel:self.userModel];
        _isChooseTopView = NO;
        
        //设置topView点击block
        _acts = [[GcustomActionSheet alloc]initWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择"] buttonColor:RGBCOLOR(31,188,34) CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
        _acts.delegate = self;
        __weak typeof (_acts)bacts = _acts;
        __weak typeof (self)bself = self;
        [cell.topImageView setAvatarClickedBlock:^{
//            [bacts showInView:bself.view];
            [bacts showInView:bself.view WithAnimation:YES];
        }];

        
        //设置头像点击block
        [cell.userFaceView setAvatarClickedBlock:^{
            [bself faceViewClickdBlock];
            
        }];
        
//        UIView *aView = [self photoAdd];
//        CGRect aFrame = aView.frame;
//        aFrame.origin.y = cell.frame.size.height - 103;
//        aView.frame = aFrame;
//        aView.tag = 1000;
//        [cell addSubview:aView];
        
        
    }else{
        //加载文章视图 并 填充数据
        cell.isHaoyou = NO;
        [cell loadCutomViewWithNetData:self.wenzhangTimeArray[indexPath.section-1] indexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - 设置头像点击block
-(void)faceViewClickdBlock{
    GRXX4ViewController *Grxx4Vc = [[GRXX4ViewController alloc]init];
    if (self.isMineVCPush) {
        Grxx4Vc.isMinVc = YES;
    }
    Grxx4Vc.passUserid = [SzkAPI getUid];
    Grxx4Vc.personModel = self.userModel;
    Grxx4Vc.isGmyFootPass = YES;
    Grxx4Vc.wenzhangArray = self.wenzhangArray;//用于显示个人足迹的图片
    Grxx4Vc.personModel = self.userModel;
    //Grxx4Vc.isPersonalSettingClicked = NO;//不是个人设置跳转的个人信息界面
    //Grxx4Vc.isSearch = NO;//不是搜索界面跳转的个人信息界面
    [self PushToViewController:Grxx4Vc WithAnimation:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_tmpCell) {
        _tmpCell = [[GmyFootCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tmp"];
    }
    
    CGFloat height = 0.0f;
    if (indexPath.row == 0 && indexPath.section == 0) {//个人topview 头像 个性签名
        height = [_tmpCell loadRow0CutomViewWithModel:self.userModel];
    }else{
        height = [_tmpCell loadCutomViewWithNetData:self.wenzhangTimeArray[indexPath.section - 1] indexPath:indexPath];
    }
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.wenzhangTimeArray.count +1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat num = 0.0f;
    if (section == 0) {
        num = 103;
    }else{
        num = 24;
    }
    return num;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}



//今天、加号部分

//- (UIView *)photoAdd
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
//    
//        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 103)];
//        view.backgroundColor = [UIColor whiteColor];
//        
//        //今天label
//        UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 57, 35)];
//        [todayLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
//        todayLabel.text = @"今天";
//        [view addSubview:todayLabel];
//        
//        //加号
//        GavatarView *addView = [[GavatarView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(todayLabel.frame)+15, 0, 75, 75)];
//        addView.userInteractionEnabled = YES;
//        
//        
//        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",@"说说", nil];
//        _actionSheet.tag = 100;
//        __weak typeof (_actionSheet)bactionSheet = _actionSheet;
//        
//        __weak typeof (self)bself = self;
//        [addView setAvatarClickedBlock:^{
//            
//            [bactionSheet showInView:bself.view];
//            
//        }];
//        addView.image = [UIImage imageNamed:@"tianjia-150_150.png"];
//        [view addSubview:addView];
//        
//    
//    //view.backgroundColor = [UIColor redColor];
//    return view;
//}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    if (section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 103)];
        view.backgroundColor = [UIColor whiteColor];
        
        //今天label
        UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 57, 35)];
        [todayLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
        todayLabel.text = @"今天";
        [view addSubview:todayLabel];
        
        //加号
        GavatarView *addView = [[GavatarView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(todayLabel.frame)+15, 0, 75, 75)];
        addView.userInteractionEnabled = YES;
        
        
//        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",@"说说", nil];
        
        _actionSheet = [[GcustomActionSheet alloc]initWithTitle:nil buttonTitles:@[@"拍照",@"从手机相册选择",@"说说"] buttonColor:RGBCOLOR(31,188,34) CancelTitle:@"取消" CancelColor:[UIColor whiteColor] actionBackColor:RGBCOLOR(236, 237, 241)];
        _actionSheet.delegate = self;
        
        _actionSheet.tag = 100;
        __weak typeof (_actionSheet)bactionSheet = _actionSheet;

        __weak typeof (self)bself = self;
        [addView setAvatarClickedBlock:^{
            
            [bactionSheet showInView:bself.view WithAnimation:YES];
            
        }];
        addView.image = [UIImage imageNamed:@"tianjia-150_150.png"];
        [view addSubview:addView];
        
        
    }
    
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"row = %d   section = %d",indexPath.row,indexPath.section);
    if (indexPath.section != 0) {
        FBCircleModel *wenzhang = self.wenzhangTimeArray[indexPath.section-1][indexPath.row];
        NSLog(@"文章id:%@",wenzhang.fb_tid);
        FBCircleDetailViewController *fbdvc = [[FBCircleDetailViewController alloc]init];
        fbdvc.theModel = wenzhang;
        [self.navigationController pushViewController:fbdvc animated:YES];
    }
    
    
    
}







#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    //判断是否点击加号
    if (_isJiaHaoPick) {//点击加号
        NSLog(@"info ------   %@",info);
        NSMutableArray * allImageArray = [NSMutableArray array];
        
        NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
        
        UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage * newImage = [ZSNApi scaleToSizeWithImage:image1 size:CGSizeMake(720,960)];
        
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
                 [ZSNApi saveImageToDocWith:url_string WithImage:image1];
             });
         }];
    }else{//更换topviewImage不是点击加号
        
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




#pragma mark-QBImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}

-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    
    
    
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
    
    __weak typeof (self)bself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        WriteBlogViewController * WriteBlog = [[WriteBlogViewController alloc] init];
        
        WriteBlog.TempAllImageArray = allImageArray;
        
        WriteBlog.TempAllAssesters = allAssesters;
        
        WriteBlog.theType = WriteBlogWithImagesAndContent;
        
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WriteBlog];
        
        [bself presentViewController:nav animated:YES completion:^{
            
        }];
    }];
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

////按像素缩放
//-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
//    
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
//}





#pragma mark - 图片回传协议方法

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage{
    self.userUpImage = cropImage;
    _isChooseTopView = YES;
    self.userUpImageData = UIImageJPEGRepresentation(self.userUpImage, 0.5);
    //缓存banner到本地
    [GlocalUserImage setUserBannerImageWithData:self.userUpImageData];
    
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
    
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
    
    
    NSLog(@"上传用户修改topview背景图");
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self test];
    });
}




#pragma mark - GcustomActionSheetDelegate
-(void)zactionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    if (actionSheet.tag == 100) {//加号
        _isJiaHaoPick = YES;
        switch (buttonIndex) {
            case 1://拍照
            {
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
            case 2://从相册选择
            {
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
            case 3://说说
            {
                NSLog(@"说说");
                
                WriteBlogViewController * WriteBlog = [[WriteBlogViewController alloc] init];
                
                WriteBlog.theType = WriteBlogWithContent;
                
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:WriteBlog];
                
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            }
                
                
                break;
            default:
                _isJiaHaoPick = NO;
                break;
        }

        
        
    }else{//点击topView
        
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
                    if (IOS7_OR_LATER) {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    }
                }];
                
                break;
            case 2://相册
            {
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
                [self presentViewController:picker animated:YES completion:^{
                    if (IOS7_OR_LATER) {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                    }
                }];
            }
                
                break;
                
            case 0://取消
                break;
                
            default:
                break;
        }
        
    }
    
}



//上传
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)test{
    
        NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=front&authkey=%@",[SzkAPI getAuthkey]];
        
        NSLog(@"上传banner请求的地址===%@ %s",fullURL,__FUNCTION__);
    
    //上传标志位
    NSString *str = @"yes";
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpBanner"];
    
    
        ASIFormDataRequest *request__ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        
        AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        request__.delegate = _appDelegate;
        request__.tag = 122;
        
        
        [request__ addRequestHeader:@"frontpic" value:[NSString stringWithFormat:@"%d", [self.userUpImageData length]]];
        //设置http body
        [request__ addData:self.userUpImageData withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"frontpic"]];
        
        [request__ setRequestMethod:@"POST"];
        request__.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
        request__.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        [request__ startAsynchronous];
    
    
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
