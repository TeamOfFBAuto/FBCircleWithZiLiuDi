//
//  AppDelegate.m
//  FBCircle
//越野e族s
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//szk

#import "AppDelegate.h"
#import "FriendCircleViewController.h"///自留地
#import "MainViewController.h"//fb圈
#import "MicroBBSViewController.h"//微论坛
#import "MessageViewController.h"//消息
#import "FoundViewController.h"//发现
#import "MineViewController.h"//我

#import "LeftViewController.h"//侧滑到左边的，暂时用不到
#import "RightViewController.h"//侧滑到右边的，暂时用不到
#import "MMDrawerController.h"

#import "MobClick.h"//友盟
#import "WXApi.h"





@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];
    }
    
    
        
    _uploadData = [[FBCircleUploadData alloc] init];
    
    MainViewController * mainVC = [[MainViewController alloc] init];
//    FriendCircleViewController * mainVC = [[FriendCircleViewController alloc] init];
    
    MicroBBSViewController * microBBSVC = [[MicroBBSViewController alloc] init];
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    
    FoundViewController * foundVC = [[FoundViewController alloc] init];
    
    MineViewController * mineVC = [[MineViewController alloc] init];
    
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:microBBSVC];
    
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:foundVC];
    
    UINavigationController * navc5 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
    navc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FB圈" image:[UIImage imageNamed:@"unselected_fbcircle_image.png"] selectedImage:[UIImage imageNamed:@"selected_fbcircle_image.png"]];
    
    navc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微论坛" image:[UIImage imageNamed:@"unselected_small_bbs_icon.png"] selectedImage:[UIImage imageNamed:@"selected_small_bbs_icon_image.png"]];
    
    navc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的消息" image:[UIImage imageNamed:@"unselected_message_icon.png"] selectedImage:[UIImage imageNamed:@"selected_message_icon.png"]];
    
    navc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"unselected_found_image.png"] selectedImage:[UIImage imageNamed:@"selected_found_image.png"]];
    
    navc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"unselected_mine_image.png"] selectedImage:[UIImage imageNamed:@"selected_mine_image.png"]];
    
    
    UITabBarController * tabbarVC = [[UITabBarController alloc] init];
    
    tabbarVC.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,navc5,nil];
    
    tabbarVC.selectedIndex = 0;
    
  //  tabbarVC.tabBar.tintColor=[UIColor redColor];
    
    
    tabbarVC.tabBar.backgroundImage = FBCIRCLE_TABBAR_BACK_IMAGE;
    
    
    
    MMDrawerController *_RootVC=[[MMDrawerController alloc]initWithCenterViewController:tabbarVC leftDrawerViewController:nil rightDrawerViewController:nil];
    
    
    [_RootVC setMaximumRightDrawerWidth:200];
    [_RootVC setMaximumLeftDrawerWidth:320];
    _RootVC.shouldStretchDrawer = NO;
    [_RootVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_RootVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    [MobClick startWithAppkey:@"5368ab4256240b6925029e29"];
    
    //微信
    [WXApi registerApp:@"wx278bfca281b3cfd1"];
    
    
    self.window.rootViewController = _RootVC;
    
    
//    NSString *url = @"http://cmstest.fblife.com/ajax.php?c=newstwonew&a=newsslide&classname=newcar&type=json";
//    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
//    
//    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
//        
//        NSLog(@"result %@",[result objectForKey:@"news"]);
//        
//        
//        
//    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        
//        NSLog(@"faildic %@",failDic);
//    }];
    
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"f985Mywkhv2tLIQnGazj4VAZ"  generalDelegate:nil];
    
    if (!ret) {
        
        NSLog(@"manager start failed!");
    }

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //设置状态栏(如果整个app是统一的状态栏，其他地方不用再设置)
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    
    
    //push start
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            
            // [alert show];
            dic_push =   [[NSDictionary alloc]initWithDictionary:pushNotificationKey];
            
//            [[NSNotificationCenter defaultCenter]postNotificationName:YINGYONGWAINOTIFICATION object:self userInfo:dic_push];
            
            [[NSUserDefaults standardUserDefaults] setObject:dic_push forKey:YINGYONGWAINOTIFICATION];
            
            /*
             
             小红点的位置及大小找王晴要要图
             应用外的操作
             *  转发，评论，赞直接进高猛写的消息列表页面
             接受和申请好友的进推荐好友ps:推荐好友页面要换，后台需要按时间排出来
             私信的跳到私信列表页面
             */
            
            
            
            //
           
            
        }
    }
    
    
    //push end
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    
    //判断网络是否可用
    //开启监控
    //[[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    AFNetworkReachabilityManager *afnrm =[AFNetworkReachabilityManager sharedManager];
    [afnrm startMonitoring];
    //设置网络状况监控后的代码块
    [afnrm setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch ([[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus]) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                [_uploadData upload];
                [_uploadData uploadBannerAndFace];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"WWAN");
                [_uploadData upload];
                [_uploadData uploadBannerAndFace];
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"Unknown");
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"NotReachable");
                
                break;
            default:
                break;
        }
    }];
    
    
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            
            // [alert show];
            dic_push =   [[NSDictionary alloc]initWithDictionary:pushNotificationKey];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:YINGYONGWAINOTIFICATION object:self userInfo:dic_push];
            
            
            
            NSLog(@"PushDic==%@",dic_push);
            
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            
            /*
             
             小红点的位置及大小找王晴要要图
             应用外的操作
             *  转发，评论，赞直接进高猛写的消息列表页面
             接受和申请好友的进推荐好友ps:推荐好友页面要换，后台需要按时间排出来
             私信的跳到私信列表页面
             */
            
            
            
            //
            //            UIAlertView *_alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",dic_push] delegate:nil cancelButtonTitle:@"launchOptions" otherButtonTitles:nil, nil];
            //            [_alert show];
            
        }
    }

    //定位 上传自己坐标
    
    //百度定位
    _locServiceDDD = [[BMKLocationService alloc]init];
    _locServiceDDD.delegate = self;
    [_locServiceDDD startUserLocationService];
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 上传的代理回调方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传完成");
    
    if (request.tag == 100 || request.tag == 123)//上传用户头像
    {
        
        NSLog(@"走了request.tag = %d    123:grxx4    100:gupdata",request.tag);
        
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        NSLog(@"tupiandic==%@",dic);
        
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            request.delegate = nil;
            NSString *str = @"no";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            [ZSNApi deleteFileWithUrl:[SzkAPI getUserFace]];
            
            NSArray * array = [dic objectForKey:@"datainfo"];
            if ([array isKindOfClass:[NSArray class]]) {
                if (array.count > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:[[array objectAtIndex:0] objectForKey:@"small"] forKey:USERFACE];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
        }else{
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        }
        
        
        NSLog(@"上传头像标志位%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpFace"]);
        
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }else if (request.tag == 101 || request.tag == 122)//上传用户banner
    {
        
        NSLog(@"走了request.tag = %d    122:gmyfootvc     101:gupdata",request.tag);
        
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        
        NSLog(@"tupiandic==%@",dic);
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            NSLog(@"上传成功");
            NSString *str = @"no";
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
            
        }else{
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
            
        }
        
        NSLog(@"上传banner标志位%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpBanner"]);
        
        
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
}

#pragma mark-Push

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //
    //    UIAlertView *_alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"靠谱" otherButtonTitles:nil, nil];
    //    [_alert show];
    /**
     *  应用内的操作
     转发、评论、赞的还是像先前一样显示，这个右上角也有红点
     好友相关的，来了消息之后人头的右上角加红点
     私信的也是右上角有红点
     红点的消失与下个界面有关系
     
     */
    NSLog(@"PushDic==%@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [[NSNotificationCenter defaultCenter]postNotificationName:COMEMESSAGES object:self userInfo:userInfo];
    /**
     这里收到了信息
     */
    

}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSLog(@"My token is: %@", deviceToken);
    
    
    NSString *string_pushtoken=[NSString stringWithFormat:@"%@",deviceToken];
    
    while ([string_pushtoken rangeOfString:@"<"].length||[string_pushtoken rangeOfString:@">"].length||[string_pushtoken rangeOfString:@" "].length) {
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:string_pushtoken forKey:DEVICETOKEN];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    
    NSLog(@"Failed to get token, error: %@", error);
}







- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBCircle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBCircle.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}





#pragma mark - 百度地图定位代理方法

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    _guserLocationDDD = userLocation;
    
    int lat = (int)_guserLocationDDD.location.coordinate.latitude;
    int lonn = (int)_guserLocationDDD.location.coordinate.longitude;
    
    if (lat != 0 && lonn != 0) {
        [_locServiceDDD stopUserLocationService];
        _locServiceDDD.delegate = nil;
        _locServiceDDD = nil;
        NSString *api = [NSString stringWithFormat:FBFOUND_UPDATAUSERLOCAL,[SzkAPI getAuthkey],_guserLocationDDD.location.coordinate.latitude,_guserLocationDDD.location.coordinate.longitude];
        NSLog(@"delegate上传自己的位置%@",api);
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data.length > 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"delegate上传自己的位置返回的字典%@",dic);
            }
            
            
        }];
    }
}






@end
