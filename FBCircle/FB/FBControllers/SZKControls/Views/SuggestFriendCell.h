//
//  SuggestFriendCell.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FriendAttribute.h"

typedef enum {
    SuggestFriendCellButtonTypeAdd=0,//添加
    SuggestFriendCellButtonTypeAccepting=1,//接受
    SuggestFriendCellButtonTypeVertificating=2,//验证中
    SuggestFriendCellButtonTypeAccepted=3,//已经接受的
    SuggestFriendCellButtonTypeInvention=4,//邀请状态

}SuggestFriendCellButtonType;

typedef void(^SuggestFriendCellbloc)(FriendAttribute * suggestmodel ,int type);


@interface SuggestFriendCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageV;



@property(nonatomic,strong)UILabel *namelabel;

@property(nonatomic,strong)UILabel *resourceLabel;

@property(nonatomic,strong)UIButton *typeButton;

@property(nonatomic,strong)FriendAttribute *model;

@property(nonatomic,assign)NSInteger rowofsuggest;

@property(nonatomic,copy)SuggestFriendCellbloc mybloc;


-(void)setindexpathrow:(NSInteger)row suggestmodel:(FriendAttribute *)themodel  mybloc:(SuggestFriendCellbloc)thebloc;

@end
