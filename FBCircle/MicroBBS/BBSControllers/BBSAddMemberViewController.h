//
//  BBSAddMemberViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbFriendListHeaderView.h"
#import "ZkingSearchView.h"
#import "BBSAddMemberCell.h"

@interface BBSAddMemberViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,BBSAddMemberCellDelegate>{
    
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
///论坛id
@property(nonatomic,strong)NSString * fid;

@end
