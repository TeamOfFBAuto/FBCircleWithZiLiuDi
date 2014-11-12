//
//  BBSListCellSingle.m
//  FBCircle
//
//  Created by lichaowei on 14/10/31.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSListCellSingle.h"
#import "TopicModel.h"

@implementation BBSListCellSingle

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(TopicModel *)aModel
{
    self.aTitleLabel.text = aModel.title;
    
    _aTitleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *address = [LTools NSStringNotNull:aModel.address];
    
    NSString *str = [address isEqualToString:@""] ? [NSString stringWithFormat:@"%@",aModel.username] : [NSString stringWithFormat:@"%@  |  %@",aModel.username,aModel.address];
    
    self.nameAndAddressLabel.text = str;
    _nameAndAddressLabel.textColor = [UIColor colorWithHexString:@"959595"];
    
    self.timeAndCommentLabel.text = [NSString stringWithFormat:@"%@  |   %@评论",[ZSNApi timestamp:aModel.time],aModel.comment_num];
    _timeAndCommentLabel.textColor = [UIColor colorWithHexString:@"959595"];

    
}

@end
