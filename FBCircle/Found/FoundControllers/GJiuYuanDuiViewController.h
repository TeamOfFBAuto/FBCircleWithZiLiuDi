//
//  GJiuYuanDuiViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//e族救援队

#import <UIKit/UIKit.h>

@interface GJiuYuanDuiViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKAnnotation,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BMKMapView *_mapView;//地图
    BMKLocationService *_locService;//定位服务
    
    
    //定位相关
    BMKUserLocation *_guserLocation;
    
    //检索相关
    BMKNearbySearchOption *_option;
    BMKPoiSearch* _poisearch;
    int curPage;
    
    
    //下面详细信息的view
    UIView *_downInfoView;
    UITableView *_tableView;
    BOOL _isShowDownInfoView;
    
    
    //底层弹上来的view
    UIView *_downBackView;
    
    
    NSTimer * timer;
    BOOL _isFire;
    
    
    //信息字典
    NSMutableDictionary *_poiAnnotationDic;
    
    //拨号
    NSString *_phoneNum;
    
    
    ///所有救援队信息的tableview
    UITableView *_allJiuyuanduiTableView;
    
}

//协议属性
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@property(nonatomic,strong)BMKPoiInfo *tableViewCellDataModel;


@end
