//
//  MyBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyBBSCell.h"
#import "BBSInfoModel.h"

@implementation MyBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithModel:(BBSInfoModel *)aModel
{
    self.aImageView.image = [LTools imageForBBSId:aModel.headpic];
    
    NSMutableString *name = [NSMutableString stringWithString:aModel.name];
    aModel.name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.nameLabel.text = aModel.name;
    
    if ([aModel.newthread_num isKindOfClass:[NSString class]]) {
        self.numLabel.text = aModel.newthread_num;
    }else
    {
        self.numLabel.text = [NSString stringWithFormat:@"%@",aModel.newthread_num];
    }
    
    NSString *numText = @"0";
    if ([aModel.newthread_num intValue] < 10) {
        numText = aModel.newthread_num;
    }else
    {
        numText = [NSString stringWithFormat:@"%d+",[aModel.newthread_num intValue]/10 * 10];
    }
    
    _nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE_BIG];
    _nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _numLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_13];
    _numLabel.textColor = [UIColor colorWithHexString:@"aaabad"];
}

@end
