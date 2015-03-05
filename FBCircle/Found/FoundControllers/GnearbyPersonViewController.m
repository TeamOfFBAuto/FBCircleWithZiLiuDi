//
//  GnearbyPersonViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GnearbyPersonViewController.h"
#import "GpersonInfoViewController.h"//用户信息界面
#import "GmPrepareNetData.h"//网络请求类
#import "GnearbyPersonCell.h"//自定义cell


@interface GnearbyPersonViewController ()
{
    
    NSArray *_dataArray;//数据源
}
@end

@implementation GnearbyPersonViewController


- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    
    _tableView.refreshDelegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any addi
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"附近的人";
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    NSLog(@"%p",_locService);
    
    //判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]==NO) {
        [self loadDingweiPanduanView];
    }else{
        [self fujinderen];
    }
    
    
    
}



//加载提示开启定位的视图
-(void)loadDingweiPanduanView{
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(62, 158, 210, 14)];
    titleLabel1.font = [UIFont systemFontOfSize:14];
    titleLabel1.textColor = RGBCOLOR(106, 113, 128);
    titleLabel1.text = @"在这里可以找到附近e族的族友，";
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(titleLabel1.frame)+7, 172, 14)];
    titleLabel2.font = [UIFont systemFontOfSize:14];
    titleLabel2.textColor = RGBCOLOR(106, 113, 128);
    titleLabel2.text = @"这需要使用您当前的位置。";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, CGRectGetMaxY(titleLabel2.frame)+35, DEVICE_WIDTH-16-16, 42);
    btn.backgroundColor = RGBCOLOR(36, 192, 38);
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"进入附近的人" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fujinderen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    [self.view addSubview:btn];
}


-(void)fujinderen{
    
    if ([CLLocationManager locationServicesEnabled]==NO) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取您的位置信息，若要使用该功能，请到手机系统的设置-隐私-定位服务中打开定位服务，并允许fb使用定位服务。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        _tableView = [[GMRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, iPhone5 ? (DEVICE_HEIGHT-64):(DEVICE_HEIGHT-64))];
        _tableView.refreshDelegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_tableView];
        [_tableView showRefreshHeader:YES];
    }
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GnearbyPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GnearbyPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    [cell loadCustomViewWithIndexPath:indexPath];//加载控件
    [cell configNetDataWithIndexPath:indexPath dataArray:_dataArray distanceDic:_distanceDic];//填充数据
    
    
    __weak typeof (self)bself = self;
    __block NSString *celluserid = cell.userId;
    [cell setSendMessageBlock:^{
        GpersonInfoViewController *gp = [[GpersonInfoViewController alloc]init];
        gp.passUserid = celluserid;
        [bself.navigationController pushViewController:gp  animated:YES];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.separatorInset = UIEdgeInsetsZero;
    

    
    
    
    return cell;
    
}






//请求网络数据
-(void)prepareNetData{
    
    NSString *api = [NSString stringWithFormat:FBFOUND_NEARBYPERSON,[SzkAPI getAuthkey]];
    
    //请求附近的人接口
    NSLog(@"请求附近的人接口:%@",api);
    
    __weak typeof (self)bself = self;
    
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length>0) {
            NSLog(@"data有数据");
            NSDictionary *allDataInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"请求附近的人获取一组用户id 和距离请求到的数据字典：%@",allDataInfo);
            
            NSString *erroCode = [allDataInfo objectForKey:@"errcode"];
            NSString *erroInfo = [allDataInfo objectForKey:@"errinfo"];
            
            NSLog(@"errocode %@ erroInfo %@ ",erroCode,erroInfo);
            if ([erroCode intValue] == 0) {
                if ([allDataInfo isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *datainfo = [allDataInfo objectForKey:@"datainfo"];
                    
                    _userids = [datainfo objectForKey:@"uid"];
                    _distanceDic = [datainfo objectForKey:@"udistance"];
                    
                    
                    //拿到一组id后请求一组用户信息
                    NSString *userIdStr = [[NSString alloc]init];
                    userIdStr = [_userids componentsJoinedByString:@","];
                    NSString *userIdApi = [NSString stringWithFormat:FUFOUND_USERSID,userIdStr];
                    
                    NSLog(@"请求一组用户接口：%@",userIdApi);
                    
                    NSURL *url = [NSURL URLWithString:userIdApi];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        NSDictionary *datadic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        
                        NSLog(@"一组用户dic%@",datadic);
                        
                        _dataArray = [datadic objectForKey:@"datainfo"];
                        
                        NSLog(@"数据源数组个数%d",_dataArray.count);
                        
                        _tableView.isReloadData = YES;
                        [bself reloadData:_dataArray isReload:_tableView.isReloadData];
                        
                    }];
                    
                }
            }else{
                
                _tableView.isReloadData = NO;
                [bself reloadData:_dataArray isReload:_tableView.isReloadData];
                
                
            }
            
        }
    }];
    

}



//通过多个uid获取用户信息
-(void)getUsersInfoWithUids:(NSArray *)userids{
    
}

#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    
    [self updateMyLocalNear];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}



#pragma mark - 上传自己的经纬度
-(void)updateMyLocalNear{
    
    [_locService startUserLocationService];//启动LocationService
    
    
}


#pragma mark - 定位代理方法

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _guserLocation = userLocation;
    
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    _guserLocation = userLocation;
    
    int lat = (int)_guserLocation.location.coordinate.latitude;
    int lonn = (int)_guserLocation.location.coordinate.longitude;
    
    NSLog(@"%d %d",lat,lonn);
    
    if (lat != 0 && lonn != 0) {
        [_locService stopUserLocationService];
        NSString *api = [NSString stringWithFormat:FBFOUND_UPDATAUSERLOCAL,[SzkAPI getAuthkey],_guserLocation.location.coordinate.latitude,_guserLocation.location.coordinate.longitude];
        
        //测试没有附近的人
//        NSString *api = [NSString stringWithFormat:FBFOUND_UPDATAUSERLOCAL,[SzkAPI getAuthkey],0.0];
        
        NSLog(@"不是delegate上传自己的位置%@",api);
        
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data.length > 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"上传自己的位置返回的字典%@",dic);
                
                [self prepareNetData];
            }
            
            
            
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
