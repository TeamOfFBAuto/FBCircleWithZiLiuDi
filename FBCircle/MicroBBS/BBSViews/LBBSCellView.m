//
//  LBBSCellView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LBBSCellView.h"
#import "TopicModel.h"

@implementation LBBSCellView
{
    id _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _target = target;
        _action = action;
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 53, 53)];
        [self addSubview:_aImageView];
        
        self.aTitleLabel = [LTools createLabelFrame:CGRectMake(_aImageView.right + 7 , 13, 200 - 20, 18 - 2) title:@"testlll" font:FONT_SIZE_BIG align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"1d222d"]];
        _aTitleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MID];
        _aTitleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_aTitleLabel];
        
        self.subTitleLabel = [LTools createLabelFrame:CGRectMake(_aTitleLabel.left, _aTitleLabel.bottom, 188, 36) title:@"aksdlkajksldjalkdsjklasjdlkajskdlajklsjdakldjakl" font:FONT_SIZE_SMALL align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"9197a3"]];
        [self addSubview:_subTitleLabel];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        UIImageView *arrow_image = [[UIImageView alloc]initWithFrame:CGRectMake(276 , self.height/2.f - 13/2.f, 7, 13)];
        arrow_image.image = [UIImage imageNamed:@"geren-jiantou.png"];
        [self addSubview:arrow_image];
    }
    return self;
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    NSString *imageUrl;
    if ([aModel.img count] > 0) {
        imageUrl = [aModel.img objectAtIndex:0];
    }
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.aTitleLabel.text = aModel.title;
    
    NSString *sub = aModel.sub_content ? aModel.sub_content : aModel.content;
    
    self.subTitleLabel.text = [LTools stringHeadNoSpace:sub];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.5;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target && [_target respondsToSelector:_action]) {
        
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_target performSelector:_action withObject:self];
        
#pragma clang diagnostic pop
        
        
    }
    
    self.alpha = 1.0;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
}


@end
