//
//  GQianmingViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHolderTextView.h"

@class GRXX4ViewController;

@interface GQianmingViewController : MyViewController
{
    GHolderTextView *_gholderTextView;
    MBProgressHUD *_hud;
}

@property(nonatomic,assign)GRXX4ViewController *delegate;

@property(nonatomic,strong)UILabel *lastLength;

@property(nonatomic,strong)NSString *yuanlaiQianming;





@property(nonatomic,assign)BOOL isGRXX4;//从个人信息4条转过来


@end
