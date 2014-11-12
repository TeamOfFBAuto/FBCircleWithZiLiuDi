//
//  FriendListViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-6.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbFriendListHeaderView.h"
#import "ZkingSearchView.h"

@interface FriendListViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    NSMutableArray *arrayOfCharacters;//'A'~'Z'
    
    NSArray *arrayinfoaddress;//把电话本里面的放到这个数组里面
    
    NSMutableArray *arrayOfSearchResault;//搜索结果
    NSMutableArray *   arrayname;//每个人一个字典，封装成model
    
    NSMutableArray *myfirendListArr;
    
    
}

@property(nonatomic,strong)UITableView *mainTabV;

@property(nonatomic,strong)UITableView *searchTabV;//搜索出的好友的tab;

@property(nonatomic,strong)UIView *halfBlackV;//黑色半透明的view;


@property(nonatomic,strong)FbFriendListHeaderView *headerV;

@property(nonatomic,strong)ZkingSearchView *zkingSearchV;


@property(nonatomic,strong)UITextField *_textfield;


@property(nonatomic,strong)UIView *SearchheaderV;




@end
