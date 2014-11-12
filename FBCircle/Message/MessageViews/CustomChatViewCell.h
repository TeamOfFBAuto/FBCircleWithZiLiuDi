//
//  CustomChatViewCell.h
//  FBCircle
//
//  Created by soulnear on 14-5-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "RTLabel.h"
#import "OHAttributedLabel.h"


typedef enum {
    MyChatViewCellTypeIncoming = 0,
    MyChatViewCellTypeOutgoing
} MyChatViewCellType;


@interface CustomChatViewCell : UITableViewCell<AsyncImageDelegate,OHAttributedLabelDelegate>
{
    
}



@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) AsyncImageView *avatarImageView;
@property(nonatomic,strong)UIImageView * background_imageView;




-(void)loadAllViewsWith:(ChatModel *)theModel WithType:(MyChatViewCellType)theType WithOtherHeaderImage:(NSString *)theImage;

-(CGPoint)returnHeightWithArray:(NSArray *)array WithType:(MyChatViewCellType)theType;

@end
