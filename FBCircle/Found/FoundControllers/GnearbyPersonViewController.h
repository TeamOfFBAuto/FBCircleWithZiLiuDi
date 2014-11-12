//
//  GnearbyPersonViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//附近的人
#import <UIKit/UIKit.h>
#import "GMRefreshTableView.h"

@interface GnearbyPersonViewController : MyViewController<RefreshDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
{
    GMRefreshTableView *_tableView;//主tableview
    
    //定位相关
    BMKUserLocation *_guserLocation;//用户当前位置
    BMKLocationService *_locService;//定位服务
    
    
    NSTimer * timer;
    BOOL _isFire;
    
    
    NSArray *_userids;//获取到的用户的ids
    
    NSDictionary *_distanceDic;//以uid为key的距离数组
    
}
@end
