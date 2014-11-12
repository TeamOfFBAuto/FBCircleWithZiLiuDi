
//
//  GJiuYuanDuiViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GJiuYuanDuiViewController.h"
#import "GJiuYuanCell.h"

#import "BMapKit.h"

#import "GBMKPointAnnotation.h"
#import "GMAPI.h"


#import "GallJiuyuanduiTableViewCell.h"

typedef enum{
    perJiuyanduiInfoTableView = 2013,
    allJiuyuanduiInfoTableView = 2014
}downTableViewType;

@interface GJiuYuanDuiViewController ()
{
    GJiuYuanCell *_tmpCell;//用户获取高度的临时cell
}
@end

@implementation GJiuYuanDuiViewController

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
    
    //导航栏
    UIView *navigationbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
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
    titleLabel.text = @"救援队";
    [navigationbar addSubview:titleLabel];
    
    
    
    //地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, 320, iPhone5?568-64:480-64)];
    [_mapView setZoomLevel:13];// 设置地图级别
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.delegate = self;//设置代理
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //判断是否开启定位
    if ([CLLocationManager locationServicesEnabled]==NO) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务已被关闭，开启定位请前往 设置->隐私->定位服务" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }
    
    
    //下面信息view
    _downInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 206)];
    _downInfoView.backgroundColor = RGBCOLOR(211, 214, 219);
    
    //底层view
    _downBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 300, 206-12-14)];
    _downBackView.backgroundColor = [UIColor whiteColor];
    _downBackView.layer.borderWidth = 0.5;
    _downBackView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    _downBackView.layer.cornerRadius = 5;
    [_downInfoView addSubview:_downBackView];
    
    
    [self.view addSubview:_downInfoView];
    
    
    //初始化分配内存
    _poiAnnotationDic  = [[NSMutableDictionary alloc]init];
    
    
    //每隔一段时间 更新用户位置
//    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateMyLocal) userInfo:nil repeats:YES];
//    
//    _isFire = NO;
    
    
    //上传自己的坐标
    [self updateMyLocal];
    
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == perJiuyanduiInfoTableView) {
        static NSString *identifier = @"dd";
        GJiuYuanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GJiuYuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0,53,0,0);
        
        
        [cell loadViewWithIndexPath:indexPath];
        
        [cell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
        return cell;
    }else if (tableView.tag == allJiuyuanduiInfoTableView){
        static NSString *all = @"alljiuyuan";
        GallJiuyuanduiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:all];
        if (!cell) {
            cell = [[GallJiuyuanduiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:all];
        }
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0f;
    if (_tmpCell) {
        cellHeight = [_tmpCell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
    }else{
        _tmpCell = [[GJiuYuanCell alloc]init];
        cellHeight = [_tmpCell configWithDataModel:self.tableViewCellDataModel indexPath:indexPath];
    }
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
    if (tableView.tag == perJiuyanduiInfoTableView) {
        if (indexPath.row == 3) {
            if ([[GMAPI exchangeStringForDeleteNULL:self.tableViewCellDataModel.phone]isEqualToString:@"暂无"]) {
                
            }else{
                NSString *phoneStr = [self.tableViewCellDataModel.phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                NSString *phoneStr1 = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
                _phoneNum = phoneStr1;
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"拨号" message:phoneStr1 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [al show];
            }
            
        }
    }else if (tableView.tag == allJiuyuanduiInfoTableView){
        
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
    
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _guserLocation = userLocation;
    
    //判断是否有经纬度
    if (_guserLocation.location) {//有经纬度的话 停止定位 上传自己坐标
        [_locService stopUserLocationService];
        //上传自己的坐标
        NSString *api = [NSString stringWithFormat:FBFOUND_UPDATAUSERLOCAL,[SzkAPI getAuthkey],_guserLocation.location.coordinate.latitude,_guserLocation.location.coordinate.longitude];
        NSLog(@"上传自己的坐标接口：%@",api);
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data.length > 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",dic);
                [self getJiuyuandui];
            }
        }];
    }

    
}


//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}




#pragma mark -救援队网络请求
-(void)getJiuyuandui{
    
    NSString *api = [NSString stringWithFormat:FBFOUND_HELPLOCAL,[SzkAPI getAuthkey],1,100];
    
    NSLog(@"%@",api);
    
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data.length > 0) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dataDic);
            
            // 清楚屏幕中所有的annotation
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            
            NSArray *modelArray = [dataDic objectForKey:@"datainfo"];
            
            for (int i = 0; i < modelArray.count; i++) {
                NSDictionary *modelInfo = [modelArray objectAtIndex:1];
                BMKPoiInfo *poi = [[BMKPoiInfo alloc]init];
                poi.name = [modelInfo objectForKey:@"name"];
                poi.address = [modelInfo objectForKey:@"address"];
                poi.phone = [modelInfo objectForKey:@"phone"];
                poi.uid = [modelInfo objectForKey:@"id"];
                poi.postcode = [modelInfo objectForKey:@"owner"];//救援队联系人
                CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([[modelInfo objectForKey:@"wei_lat"]floatValue], [[modelInfo objectForKey:@"jing_lng"]floatValue]);
                poi.pt = pt;
                
                
                [_poiAnnotationDic setObject:poi forKey:poi.name];
                
                BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
                item.coordinate = poi.pt;
                item.title = poi.name;
                item.subtitle = poi.address;
                
                
                NSLog(@"%@",item.title);
                
                [_mapView addAnnotation:item];//addAnnotation方法会掉BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
                
//                if(i == 0){
//                    //将第一个点的坐标移到屏幕中央
//                    _mapView.centerCoordinate = poi.pt;
//                }
            }
            
        }
        
    }];
    
    
    
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
    
    
    
//    //加载所有救援队的tableview
//    _allJiuyuanduiTableView = nil;
//    _allJiuyuanduiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iPhone5?568-216:480-216, 320, 216) style:UITableViewStylePlain];
//    _allJiuyuanduiTableView.delegate = self;
//    _allJiuyuanduiTableView.dataSource = self;
//    _allJiuyuanduiTableView.tag = allJiuyuanduiInfoTableView;
//    [self.view addSubview:_allJiuyuanduiTableView];
    
    
    
    annotationView.image = [UIImage imageNamed:@"gpin.png"];
    
    return annotationView;
}
#pragma mark - 点击标注执行的方法
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    NSLog(@"%s",__FUNCTION__);
    
    if (_isShowDownInfoView) {
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, 568, 320, 206);
        }];
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 206-12-14) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.borderWidth = 0.5;
    _tableView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    _tableView.layer.cornerRadius = 5;
    _tableView.tag = perJiuyanduiInfoTableView;
    [_downBackView addSubview:_tableView];
    
    NSLog(@"---------%@",[view.annotation title]);
    NSLog(@"---------%@",[view.annotation subtitle]);
    
    BMKPoiInfo *poi = [_poiAnnotationDic objectForKey:[view.annotation title]];
    NSLog(@"%@",poi.postcode);
    NSLog(@"%@",poi.phone);
    
    self.tableViewCellDataModel = poi;
    
    
    if (!_isShowDownInfoView) {
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, 568-206, 320, 206);
        } completion:^(BOOL finished) {
            _isShowDownInfoView = !_isShowDownInfoView;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, 568, 320, 206);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 上传自己的经纬度
-(void)updateMyLocal{
    //打开定位
    [_locService startUserLocationService];
    
}


@end
