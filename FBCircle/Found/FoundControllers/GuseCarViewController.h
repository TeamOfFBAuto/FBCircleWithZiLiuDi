//
//  GuseCarViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//用车服务
#import <UIKit/UIKit.h>
@interface GuseCarViewController : MyViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKAnnotation,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
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
    UIView *_downBackView;
    
    //信息字典
    NSMutableDictionary *_poiAnnotationDic;
    
    
    
    //打电话
    NSString *_phoneNum;
}

@property(nonatomic,strong)NSMutableArray *btnArray;//上面三个按钮的数组

@property(nonatomic,strong)BMKPoiInfo *tableViewCellDataModel;

@property(nonatomic,assign)BOOL isFirstOpenOfjiayouzhan;//第一次进入时自动定位加油站

//协议属性
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;



@end
