//
//  BBSAddMemberCell.h
//  FBCircle
//
//  Created by soulnear on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendAttribute.h"

@class BBSAddMemberCell;
@protocol BBSAddMemberCellDelegate <NSObject>

///选中取消选中用户
-(void)selectedButtonTap:(BBSAddMemberCell *)cell isSelected:(BOOL)isSelected WithType:(int)aType;

@end

@interface BBSAddMemberCell : UITableViewCell
{
    ///0联系人数据类型，1为搜索数据类型
    int type;
}

@property(nonatomic,weak)id<BBSAddMemberCellDelegate>delegate;

///头像
@property(nonatomic,strong)UIImageView *headImageV;

///选中按钮
@property(nonatomic,strong)UIButton * selected_button;

///名字
@property (nonatomic,strong)UILabel  *nameLabel;
///分割线
@property(nonatomic,strong)UIView * line_view;

-(void)setFriendAttribute:(FriendAttribute *)FriendAttributemodel WithType:(int)atype;

@end
