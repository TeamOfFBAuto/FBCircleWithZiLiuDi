//
//  FbSMSIVCell.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendAttribute.h"

typedef void(^FbSMSIVCellBloc)(NSInteger therow,BOOL theisSelect,FriendAttribute *_theFbSMSIVCellModel);


@interface FbSMSIVCell : UITableViewCell

@property(nonatomic,strong)UIButton *selectButton;

@property(nonatomic,strong)UIImageView *selectimV;


@property (nonatomic,strong)UILabel  *nameLabel;

@property(nonatomic,assign)BOOL isSelected;




@property(assign,nonatomic)NSInteger rowOfpath;

@property(copy,nonatomic)FbSMSIVCellBloc mybloc;

@property(nonatomic,strong)FriendAttribute *FbSMSIVCellModel;

-(void)setNameStr:(NSString*)strName row:(NSInteger)theRowOfPath FriendAttributes:(FriendAttribute *)theModel  fbsmsbloc:(FbSMSIVCellBloc)thebloc;

-(void)setSelect;
@end
