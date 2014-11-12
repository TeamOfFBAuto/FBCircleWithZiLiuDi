//
//  PraiseMemberCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "PraiseMemberCell.h"

@implementation PraiseMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.upMask = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 320 - 24, 4)];
        _upMask.backgroundColor = [UIColor whiteColor];
        [self addSubview:_upMask];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 320 - 24, 55)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (55-37)/2.0, 37, 37)];
        [self addSubview:_aImageView];
        
        self.aTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_aImageView.right + 6, 0, 150, 55)];
        _aTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_aTitleLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 54, 320-24, 1.f)];
        line.backgroundColor = COLOR_TABLE_LINE;
        [self addSubview:line];
        self.bottomLine = line;
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
