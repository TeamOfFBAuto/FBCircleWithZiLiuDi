//
//  ChooseAreaViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAreaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSString * myArea;

@property(nonatomic,strong)NSString * myCountryName;

@property(nonatomic,strong)NSMutableArray * areas;


@end
