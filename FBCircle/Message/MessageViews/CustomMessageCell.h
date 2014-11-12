//
//  CustomMessageCell.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface CustomMessageCell : UITableViewCell
{
    
}


@property(nonatomic,strong)AsyncImageView * headImageView;

@property(nonatomic,strong)UILabel * NameLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * contentLabel;

@property(nonatomic,strong)UILabel * contentLabel1;

@property(nonatomic,strong)UIImageView * tixing_label;


-(void)setAllViewWithType:(int)type;

-(void)setInfoWithType:(int)type withMessageInfo:(MessageModel *)info;



@end
