//
//  CreateBBSChooseTypeViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSModel.h"

typedef void(^CreateBBSChooseTypeBlock)(BBSModel * model);


@interface CreateBBSChooseTypeViewController : MyViewController<UITableViewDelegate,UITableViewDataSource>
{
    CreateBBSChooseTypeBlock chooseType_block;
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)UILabel * name_Label;

@property(nonatomic,assign)int icon_num;


-(void)chooseTypeBlock:(CreateBBSChooseTypeBlock)theType;


@end
