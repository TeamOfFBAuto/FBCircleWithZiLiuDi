//
//  CreateBBSChooseIconCell.m
//  FBCircle
//
//  Created by soulnear on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CreateBBSChooseIconCell.h"

@implementation CreateBBSChooseIconCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0;i < 6;i++)
        {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(6+54.8*i,14,34,34);
            button.tag = 1000 + i;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        
    }
    return self;
}


-(void)setAllImagesWithArray:(NSMutableArray *)array WithRow:(int)theRow WithSelectedIndex:(int)theIndex WithBlock:(CreateBBSChooseIconCellBlock)theBlock
{
    choose_icon_block = theBlock;
    
    for (int i = 0;i<6;i++)
    {
        UIButton * button = (UIButton *)[self.contentView viewWithTag:1000+i];
        
        [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        
        if (theRow*6 + i == theIndex)
        {
            button.backgroundColor = RGBCOLOR(171,169,170);
        }else
        {
            button.backgroundColor = [UIColor clearColor];
        }
    }
}


#pragma mark - 选择图标

-(void)buttonTap:(UIButton *)button
{
//    button.backgroundColor = RGBCOLOR(171,169,170);
    choose_icon_block(button.tag-1000);
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
