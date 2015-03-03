//
//  FBCircleMenuView.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleMenuView.h"

@implementation FBCircleMenuView
@synthesize delegate = _delegate;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = NO;
        
        self.clipsToBounds = YES;
        
        CGFloat the_width = (DEVICE_WIDTH-2)/3.0f;
                
        NSArray * imageArray = [NSArray arrayWithObjects:@"pinglun-xin_up-24_24.png",@"pinglun-pinglun_up24_24.png",@"pinglun-zhuanfa_up-24_24.png",@"pinglun-xin-down-24_24.png",@"pinglun-pinglun_up24_24.png",@"pinglun-zhuanfa_up-24_24.png",nil];
        
        
        NSArray * contentArray = [NSArray arrayWithObjects:@"赞",@"评论",@"转发",nil];
        
        for (int i = 0;i < 3;i++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((the_width+1)*i,0,the_width,38);
            button.tag = 100 + i;
            [button setBackgroundImage:[UIImage imageNamed:@"pinglun-bg1-up-212_76.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"pinglun-bg1-down212_76.png"] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:3+i]] forState:UIControlStateHighlighted];
            [button setTitle:[contentArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
//            if (i == 0 && isZan) {
//                [button setImage:[UIImage imageNamed:@"FBCircleZanImageOK.png"] forState:UIControlStateNormal];
//            }
            
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,-8,0,0)];
            
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-15)];
            
            [self addSubview:button];
        }
    }
    return self;
}


-(void)buttonClicked:(UIButton *)sender
{
    FBCircleMenuType type;
    
    switch (sender.tag) {
        case 100:
            type = FBCircleMenuZan;
            break;
        case 101:
            type = FBCircleMenuPinglun;
            break;
        case 102:
            type = FBCircleMenuZhuanFa;
            break;
            
        default:
            break;
    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickButtonWithMenuType:)])
    {
        [_delegate clickButtonWithMenuType:type];
    }
    
}


-(void)setAllViewsWithZan:(BOOL)isZan
{
    
    NSArray * imageArray = [NSArray arrayWithObjects:@"FBCircleZanImageNO.png",@"FBCirclePinglunImageNO.png",@"FBCircleForwardingImageNO.png",@"FBCircleZanImageOK.png",@"FBCirclePinglunImageOK.png",@"FBCircleForwardingImageOK.png",nil];
    
    
    NSArray * contentArray = [NSArray arrayWithObjects:@"赞",@"评论",@"转发",nil];
    
    for (int i = 0;i < 3;i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake((106+1)*i,0,106,38);
        
        [button setBackgroundImage:[UIImage imageNamed:@"pinglun-bg2-down-216_76.png"] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"pinglun-bg1-down-216_76.png"] forState:UIControlStateHighlighted];
        
        [button setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:3+i]] forState:UIControlStateHighlighted];
        
        [button setTitle:[contentArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (i == 0 && isZan) {
            [button setImage:[UIImage imageNamed:@"wo-34_38.png"] forState:UIControlStateNormal];
        }
        
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,20,0,0)];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
        
        [self addSubview:button];
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
