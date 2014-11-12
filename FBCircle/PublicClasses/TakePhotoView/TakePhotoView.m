//
//  TakePhotoView.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "TakePhotoView.h"

@implementation TakePhotoView
@synthesize theNav_view = _theNav_view;
@synthesize close_button = _close_button;
@synthesize bottom_view = _bottom_view;
@synthesize shoot_button = _shoot_button;
@synthesize view_finder_view = _view_finder_view;



- (id)initWithFrame:(CGRect)frame WithBlock:(TakePhotoViewBlock)theBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        take_photo_block = theBlock;
        
        
        
        _view_finder_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"take_photo_view_finder_image"]];
        
        _view_finder_view.center = self.center;
        
        [self addSubview:_view_finder_view];
        
        [self animationWithView:_view_finder_view];
        
        
        
        _theNav_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,64)];
        
        _theNav_view.userInteractionEnabled = YES;
        
        _theNav_view.image = [UIImage imageNamed:@"take_photo_navigation_image.png"];
        
        [self addSubview:_theNav_view];
        
        
        _close_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _close_button.frame = CGRectMake(0,20,40,44);
        
        _close_button.tag = 101;
        
        [_close_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_close_button setImage:[UIImage imageNamed:@"take_photo_close_image.png"] forState:UIControlStateNormal];
        
        [_theNav_view addSubview:_close_button];
        
        
        _bottom_view = [[UIView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-53,320,53)];
        
        _bottom_view.backgroundColor = RGBCOLOR(31,31,31);
        
        [self addSubview:_bottom_view];
        
        _shoot_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _shoot_button.tag = 100;
        
        [_shoot_button setImage:[UIImage imageNamed:@"take_photo_snak_image.png"] forState:UIControlStateNormal];
        
        _shoot_button.frame = CGRectMake(0,0,80,53);
        
        _shoot_button.center = CGPointMake(160,53/2);
        
        [_shoot_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottom_view addSubview:_shoot_button];
        
    }
    return self;
}


#pragma makr - 取景框动画

-(void)animationWithView:(UIView *)sender
{
    sender.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.5,1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            sender.transform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finished)
        {
            [self performSelector:@selector(hiddenTheView:) withObject:sender afterDelay:0.5];
        }];
    }];
}

-(void)hiddenTheView:(id)sender
{
    [(UIView *)sender setHidden:YES];
}



-(void)buttonTap:(UIButton *)sender
{
    take_photo_block(sender.tag -100);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currTouchPoint = [touch locationInView:self];
    
    _view_finder_view.center = currTouchPoint;
    
    [self animationWithView:_view_finder_view];
}





@end
























