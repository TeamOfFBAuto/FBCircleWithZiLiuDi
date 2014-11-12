//
//  ChooseCountryViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCitiesViewController.h"

@interface ChooseCountryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSMutableArray * dataArray;



@end
