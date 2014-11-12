//
//  AddFriendViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//添加好友主界面

#import <UIKit/UIKit.h>

#import "WXApi.h"
@interface AddFriendViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,WXApiDelegate>{
    enum WXScene _scene;


    
}
@property(nonatomic,strong)UITableView *mainTabV;




@property(nonatomic,strong)UIView *halfBlackV;//黑色半透明的view;


@property(nonatomic,strong)UITableView *searchTabV;//搜索出的好友的tab;


@property(nonatomic,strong)NSArray *array_searchResault;

@property(nonatomic,assign)BOOL isnavgationBarhiden;//


//扫一扫完成后的回调
-(void)pushWebViewWithStr:(NSString *)stringValue;

-(void)pushMyerweimaVc;

-(void)pushToPersonInfoVcWithStr:(NSString *)stringValue;

-(void)pushToGrxx4;

@end
