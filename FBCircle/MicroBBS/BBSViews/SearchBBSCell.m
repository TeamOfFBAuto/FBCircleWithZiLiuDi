//
//  SearchBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SearchBBSCell.h"
#import "BBSInfoModel.h"

@implementation SearchBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(BBSInfoModel *)aModel
{
//    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.headpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    
    self.aImageView.image = [LTools imageForBBSId:aModel.forumclass];
    self.aTitleLabel.text = aModel.name;
    self.memberNumLabel.text = aModel.member_num;
    
    NSString *str__ = [NSString stringWithFormat:@"成员 %@ | 帖子 %@",aModel.member_num,aModel.thread_num];
    
    NSAttributedString *contentText;
    if ([aModel.member_num isEqualToString:aModel.thread_num]) {
        
        contentText = [LTools attributedString:str__ keyword:aModel.member_num color:[UIColor colorWithHexString:@"617dbc"]];
    }else
    {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithAttributedString:[LTools attributedString:nil originalString:str__ AddKeyword:aModel.member_num color:[UIColor colorWithHexString:@"617dbc"]]];
        
        contentText = [LTools attributedString:attr originalString:str__ AddKeyword:aModel.thread_num color:[UIColor colorWithHexString:@"617dbc"]];
    }
    
    self.memberNumLabel.attributedText = contentText;
}


@end
