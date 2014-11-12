//
//  JoinBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "JoinBBSCell.h"
#import "BBSInfoModel.h"

@implementation JoinBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickToJoin:(id)sender {
    
    if (cellBlock) {
        cellBlock(topicId);
    }
}


- (void)setCellDataWithModel:(BBSInfoModel *)aModel cellBlock:(CellBlock)aBlock
{
    topicId = aModel.id;
    cellBlock = aBlock;
    
    self.aImageView.image = [LTools imageForBBSId:aModel.headpic];
    
    //标题
    self.aTitleLabel.text = [LTools stringHeadNoSpace:aModel.name];
    _aTitleLabel.font = [UIFont systemFontOfSize:15];
    
    UIColor *color1 = [UIColor colorWithHexString:@"6a7180"];
    UIColor *color2 = [UIColor colorWithHexString:@"627cbd"];
    
    //成员
    _memberTitle.textColor = color1;
    
    
    //成员数
    self.memeberLabel.text = aModel.member_num;
    self.memeberLabel.width = [LTools widthForText:aModel.member_num font:FONT_SIZE_SMALL];
    _memeberLabel.textColor = color2;
    
    self.line.left = self.memeberLabel.right + 5;
    
    //帖子
    self.topicTitle.left = self.line.right + 5;
    _topicTitle.textColor = color1;
    
    //帖子数
    self.topicLabel.text = aModel.thread_num;
    self.topicLabel.left = self.topicTitle.right;
    self.topicLabel.width = [LTools widthForText:aModel.thread_num font:FONT_SIZE_SMALL];
    _topicLabel.textColor = color2;
    
    //加入按钮
    
    int inform = aModel.inForum > aModel.inforum ? aModel.inForum : aModel.inforum;
        
    self.joinButton.selected = (inform >= 1) ? YES : NO;
    self.joinButton.userInteractionEnabled = (inform >= 1) ? NO : YES;
    
}

@end
