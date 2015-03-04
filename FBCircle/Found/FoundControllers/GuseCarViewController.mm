//
//  GuseCarViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GuseCarViewController.h"
#import "GcustomUseCarDownInfoCell.h"//底层view自定义cell


#import "GMAPI.h"


@interface GuseCarViewController ()
{
    GcustomUseCarDownInfoCell *_tmpCell;//临时cell 用于返回高度
}
@end

@implementation GuseCarViewController



- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}




-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
    
    _mapView.delegate = nil; // 不用时，置nil
    
    
    _poisearch.delegate = nil; // 不用时，置nil
    
    
    _locService.delegate = nil;
    
    

    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _isShowDownInfoView = NO;
    
    
    
    //导航栏
    UIView *navigationbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    navigationbar.backgroundColor = RGBCOLOR(34, 41, 44);
    [self.view addSubview:navigationbar];
    
    
    //导航栏上的返回按钮和titile
    
    //返回view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 74, 64)];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ttt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gBackBtnClicked)];
    [backView addGestureRecognizer:ttt];
    [navigationbar addSubview:backView];
    //返回箭头
    UIImageView *backImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+20, 10, 19)];
    [backImv setImage:[UIImage imageNamed:@"fanhui-daohanglan-20_38.png"]];
    backImv.userInteractionEnabled = YES;
    [backView addSubview:backImv];
    //返回文字
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backImv.frame)+8, backImv.frame.origin.y, 34, 20)];
    backLabel.textColor = [UIColor whiteColor];
    backLabel.userInteractionEnabled = YES;
    backLabel.text = @"发现";
    [backView addSubview:backLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 20, 70, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =  [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"用车服务";
    [navigationbar addSubview:titleLabel];
    
    
    
    
    
    
    //按钮下面的背景view
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, 44)];
    btnBackView.backgroundColor = RGBCOLOR(240, 241, 243);
    [self.view addSubview:btnBackView];
    
    //分配内存
    self.btnArray = [NSMutableArray arrayWithCapacity:1];
    
    //按钮
    NSArray *array  = @[@"停车场",@"加油站",@"维修厂"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+(DEVICE_WIDTH/3.0+1)*i, 64, DEVICE_WIDTH/3.0, 44);
        btn.tag = 10+i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(106, 114, 126) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn addTarget:self action:@selector(FoundBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.btnArray addObject:btn];
        if (i == 1) {
            [btn setTitleColor:RGBCOLOR(44, 114, 213) forState:UIControlStateNormal];
        }
    }
    
    //竖线
    for (int i = 0; i<2; i++) {
        UIView *shuxian = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/3.0+(DEVICE_WIDTH/3.0+1)*i, 64+7, 0.5, 28)];
        shuxian.backgroundColor = RGBCOLOR(216, 216, 218);
        [self.view addSubview:shuxian];
    }
    
    //横线
    UIView *hengxian = [[UIView alloc]initWithFrame:CGRectMake(0, 64+43, DEVICE_WIDTH, 0.5)];
    hengxian.backgroundColor = RGBCOLOR(148, 149, 153);
    [self.view addSubview:hengxian];
    
    
    curPage = 0;
    
    
    //地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 88+20, DEVICE_WIDTH, iPhone5?DEVICE_HEIGHT-88-20:DEVICE_HEIGHT-88-20)];
    [_mapView setZoomLevel:17];// 设置地图级别
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.delegate = self;//设置代理
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
    
    //搜索类
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    
    
    
    
    //判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]==NO) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务已被关闭，开启定位请前往 设置->隐私->定位服务" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        //定位
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        self.isFirstOpenOfjiayouzhan = YES;
        [_locService startUserLocationService];//启动LocationService
        
    }
   
    
    
    
    
    //下面信息view
    _downInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206)];
    _downInfoView.backgroundColor = RGBCOLOR(211, 214, 219);
    //底层view
    _downBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, DEVICE_WIDTH-20, 150)];
    _downBackView.backgroundColor = [UIColor whiteColor];
    _downBackView.layer.borderWidth = 0.5;
    _downBackView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    _downBackView.layer.cornerRadius = 5;
    [_downInfoView addSubview:_downBackView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-20, 150) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.borderWidth = 0.5;
    _tableView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    _tableView.layer.cornerRadius = 5;
    [_downBackView addSubview:_tableView];
    
    _poiAnnotationDic = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    
    [self.view addSubview:_downInfoView];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"dd";
    
    GcustomUseCarDownInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[GcustomUseCarDownInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0,53,0,0);
    
    
    [cell loadViewWithIndexPath:indexPath];
    
    
    [cell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0f;
    
    if (_tmpCell) {
        [_tmpCell loadViewWithIndexPath:indexPath];
        cellHeight = [_tmpCell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
    }else{
        
        _tmpCell = [[GcustomUseCarDownInfoCell alloc]init];
        cellHeight = [_tmpCell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
    }
    
    NSLog(@"vc heightForRow代理方法 : cellHeight: %f",cellHeight);
    
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%s",__FUNCTION__);
    
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    if (indexPath.row == 2) {
        
        if ([[GMAPI exchangeStringForDeleteNULL:self.tableViewCellDataModel.phone]isEqualToString:@"暂无"]) {
            
        }else{
            NSString *phoneStr = [self.tableViewCellDataModel.phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            NSString *phoneStr1 = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            _phoneNum = [NSString stringWithFormat:@"%@",phoneStr1];
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"拨号" message:phoneStr1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [al show];
        }
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    
    //0取消    1确定
    if (buttonIndex == 1) {
        NSString *strPhone = [NSString stringWithFormat:@"tel://%@",_phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
    }
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
    [_mapView updateLocationData:userLocation];
    _guserLocation = userLocation;
    NSLog(@"heading is %@",userLocation.heading);
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{

    _guserLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    
    if (userLocation.location) {//定位成功
         _mapView.centerCoordinate = userLocation.location.coordinate;
        [_locService stopUserLocationService];
        if (self.isFirstOpenOfjiayouzhan) {
            //发起检索
            BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
            option.pageIndex = curPage;
            option.radius = 2000;
            option.pageCapacity = 100;
            option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
            option.keyword = @"加油站";
            BOOL flag = [_poisearch poiSearchNearBy:option];
            if(flag)
            {
                NSLog(@"周边检索发送成功");
            }
            else
            {
                NSLog(@"周边检索发送失败");
            }
        }else{
            [_locService stopUserLocationService];
        }
   
    }
    
    
}


//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}



#pragma mark - 按钮点击方法  搜索周边
-(void)FoundBtnClicked:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
    
    //改变字体和背景颜色
    for (UIButton *btn in self.btnArray) {
        
        if (btn.tag == sender.tag) {
            [btn setTitleColor:RGBCOLOR(44, 114, 213) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR(106, 114, 126) forState:UIControlStateNormal];
        }
        
    }
    
    //进行地图搜索相关操作
    if (sender.tag == 10) {//停车场
        
        
        if (_isShowDownInfoView) {
            [UIView animateWithDuration:0.3 animations:^{
                _downInfoView.frame = CGRectMake(0, 568, 320, 206);
            } completion:^(BOOL finished) {
                _isShowDownInfoView = !_isShowDownInfoView;
            }];
        }
        
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.radius = 2000;
        option.pageCapacity = 20;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
            option.keyword = @"停车场";
            BOOL flag = [_poisearch poiSearchNearBy:option];
            if(flag)
            {
                NSLog(@"周边检索发送成功");
            }  
            else  
            {  
                NSLog(@"周边检索发送失败");  
            }
        
        
    }else if (sender.tag == 11){//加油站
        
        
        if (_isShowDownInfoView) {
            [UIView animateWithDuration:0.3 animations:^{
                _downInfoView.frame = CGRectMake(0, 568, 320, 206);
            } completion:^(BOOL finished) {
                _isShowDownInfoView = !_isShowDownInfoView;
            }];
        }
        
        
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.radius = 2000;
        option.pageCapacity = 100;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
        option.keyword = @"加油站";
        BOOL flag = [_poisearch poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
        
    }else if (sender.tag == 12){//维修厂
        
        
        if (_isShowDownInfoView) {
            [UIView animateWithDuration:0.3 animations:^{
                _downInfoView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
            } completion:^(BOOL finished) {
                _isShowDownInfoView = !_isShowDownInfoView;
            }];
        }
        
        
        
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.radius = 2000;
        option.pageCapacity = 100;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
        option.keyword = @"汽车维修";
        BOOL flag = [_poisearch poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
    }
    
    
}


//周边搜索回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            
            BMKPoiInfo *poi = [poiResultList.poiInfoList objectAtIndex:i];
            
            NSLog(@"%@",poi.name);
            NSLog(@"%@",poi.address);
            NSLog(@"%@",poi.phone);
            [_poiAnnotationDic setObject:poi forKey:poi.name];
            
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = poi.address;
            [_mapView addAnnotation:item];//addAnnotation方法会掉BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
            
//            if(i == 0)
//            {
//                //将第一个点的坐标移到屏幕中央
//                _mapView.centerCoordinate = poi.pt;
//            }
            
            
        }
  
        
	} else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        
        NSLog(@"起始点有歧义");
    } else {
        
        // 各种情况的判断。。。
    }
}


#pragma mark - 地图view代理方法 BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";

    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }

    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;

    
    
    annotationView.image = [UIImage imageNamed:@"gpin.png"];
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    
    if (_isShowDownInfoView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
        }];
        _isShowDownInfoView = NO;
    }
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}



#pragma mark - 弹出框点击代理方法
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
    
    
    
    
    NSLog(@"---------%@",[view.annotation title]);
    NSLog(@"---------%@",[view.annotation subtitle]);
    
    BMKPoiInfo *poi = [_poiAnnotationDic objectForKey:[view.annotation title]];
    NSLog(@"%@",poi.postcode);
    NSLog(@"%@",poi.phone);
    
    self.tableViewCellDataModel = poi;
    
    NSLog(@"333%@",self.tableViewCellDataModel.name);
    NSLog(@"444%@",self.tableViewCellDataModel.address);
    
    [_tableView reloadData];
    
    
    if (!_isShowDownInfoView) {
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, DEVICE_HEIGHT-206, DEVICE_WIDTH, 206);
        } completion:^(BOOL finished) {
            _isShowDownInfoView = !_isShowDownInfoView;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 206);
        } completion:^(BOOL finished) {
            _isShowDownInfoView = !_isShowDownInfoView;
        }];
    }
    
}






//左上角返回按钮
-(void)gBackBtnClicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




@end
