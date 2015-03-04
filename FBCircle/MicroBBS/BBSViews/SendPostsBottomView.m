//
//  SendPostsBottomView.m
//  FBCircle
//
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsBottomView.h"

@implementation SendPostsBottomView

- (SendPostsBottomView *)initWithFrame:(CGRect)frame WithBlock:(SendPostsBottomViewBlock)theBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        sendPosts_block = theBlock;
        
        [self setup];
    }
    return self;
}


-(void)setup
{
    NSArray * image_array = [NSArray arrayWithObjects:@"sendPosts_camera.png",@"sendPosts_photo_album.png",nil];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0.5)];

    lineView.backgroundColor = RGBCOLOR(181,181,183);
    
    [self addSubview:lineView];
    
    
    for (int i = 0;i < 2;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(3.5+50*i,0.5,50,40);
        
        button.tag = 100 + i;
        
        button.backgroundColor = [UIColor clearColor];
        
        [button setImage:[UIImage imageNamed:[image_array objectAtIndex:i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
}


-(void)buttonTap:(UIButton *)sender
{
    if (sendPosts_block)
    {
        sendPosts_block(sender.tag-100);
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
