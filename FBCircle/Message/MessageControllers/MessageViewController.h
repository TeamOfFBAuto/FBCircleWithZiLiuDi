//
//  MessageViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "CustomMessageCell.h"
#import "ChatViewController.h"
#import "GmyMessageViewController.h"

@interface MessageViewController : MyViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    UIImageView *    _tixing_label ;
    
    BOOL isnewfbnotification;
    
    NSTimer * theTimer;
}

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)MessageModel * theModel;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)NSDictionary * system_notification_dictionary;




@end
