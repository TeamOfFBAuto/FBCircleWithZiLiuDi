//
//  ZSNAlertView.m
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ZSNAlertView.h"

@implementation ZSNAlertView
@synthesize backgroundImageView = _backgroundImageView;
@synthesize forward_label = _forward_label;
@synthesize imageView = _imageView;
@synthesize userName_label = _userName_label;
@synthesize content_label = _content_label;
@synthesize textField = _textField;
@synthesize cancel_button = _cancel_button;
@synthesize done_button = _done_button;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIWindowLevelStatusBar;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        
        if (!_backgroundImageView) {
            //            _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-540_420.png"]];
            
            _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,271,195)];
            
            _backgroundImageView.image = [UIImage imageNamed:@"bg-540_420.png"];
            
            //lcw iPhone5: 20
            CGPoint aCenter = self.center;
            aCenter.y -= 55;
            _backgroundImageView.center = aCenter;
            
            _backgroundImageView.userInteractionEnabled = YES;
            
            [self addSubview:_backgroundImageView];
        }
        
        if (!_forward_label) {
            
            _forward_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_backgroundImageView.frame.size.width,41)];
            _forward_label.text = @"转发";
            _forward_label.textAlignment = NSTextAlignmentCenter;
            _forward_label.textColor = RGBCOLOR(3,3,3);
            _forward_label.backgroundColor = [UIColor clearColor];
            [_backgroundImageView addSubview:_forward_label];
        }
        
        if (!_imageView) {
            _imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(25.5,52.5,40,40)];
            _imageView.clipsToBounds = YES;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            [_backgroundImageView addSubview:_imageView];
        }
        
        if (!_userName_label) {
            _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(75,52.5,180,15)];
            _userName_label.textAlignment = NSTextAlignmentLeft;
            _userName_label.textColor = RGBCOLOR(153,153,153);
            _userName_label.font = [UIFont systemFontOfSize:15];
            _userName_label.numberOfLines = 0;
            [_backgroundImageView addSubview:_userName_label];
        }
        
        if (!_content_label)
        {
            _content_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(75,72.5,180,20)];
            _content_label.textAlignment = NSTextAlignmentLeft;
            _content_label.textColor = RGBCOLOR(3,3,3);
            _content_label.font = [UIFont systemFontOfSize:14];
            _content_label.backgroundColor = [UIColor clearColor];
            [_backgroundImageView addSubview:_content_label];
        }
        
        if (!_textField)
        {
            UIImageView * shurukuang = [[UIImageView alloc]  initWithFrame:CGRectMake(8.75+15,104,223,30)];
            shurukuang.userInteractionEnabled = YES;
            shurukuang.image = [UIImage imageNamed:@"shuru-446_60.png"];
            [_backgroundImageView addSubview:shurukuang];
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(8,0,207,30)];
            _textField.placeholder = @"输入内容...";
            _textField.delegate = self;
            _textField.returnKeyType = UIReturnKeyDone;
            _textField.font = [UIFont systemFontOfSize:14];
            _textField.backgroundColor = [UIColor clearColor];
            [shurukuang addSubview:_textField];
            
        }
        
        if (!_cancel_button) {
            _cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _cancel_button.frame = CGRectMake(0,151,135,44);
            
            _cancel_button.backgroundColor = [UIColor clearColor];
            
//            [_cancel_button setBackgroundImage:[UIImage imageNamed:@"button1-up252_94.png"] forState:UIControlStateNormal];
//            
            [_cancel_button setBackgroundImage:[UIImage imageNamed:@"button1-down252_94.png"] forState:UIControlStateHighlighted];
            
            [_cancel_button setTitle:@"取消" forState:UIControlStateNormal];
            
            [_cancel_button setTitleColor:RGBCOLOR(18,107,255) forState:UIControlStateNormal];
            
            [_cancel_button addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_backgroundImageView addSubview:_cancel_button];
        }
        
        
        if (!_done_button) {
            _done_button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _done_button.frame = CGRectMake(136,151,135,44);
            
            _done_button.backgroundColor = [UIColor clearColor];
            
//            [_done_button setBackgroundImage:[UIImage imageNamed:@"button2-up252_94.png"] forState:UIControlStateNormal];
//            
            [_done_button setBackgroundImage:[UIImage imageNamed:@"button2-down252_94.png"] forState:UIControlStateHighlighted];
            
            [_done_button addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_done_button setTitle:@"确认" forState:UIControlStateNormal];
            
            [_done_button setTitleColor:RGBCOLOR(18,107,255) forState:UIControlStateNormal];
            
            [_backgroundImageView addSubview:_done_button];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}


-(void)setInformationWithUrl:(NSString *)url WithUserName:(NSString *)userName WithContent:(NSString *)content WithBlock:(ZSNAlertViewBlock)theBlock
{
    zsnAlertViewBlock = theBlock;
    _content_label.frame = CGRectMake(75,72.5,180,22);
    [_imageView loadImageFromURL:url withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
    _userName_label.text = userName;
    [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:content] stringByReplacingEmojiCheatCodesWithUnicode] Label:_content_label OHDelegate:nil WithWidht:IMAGE_SMALL_WIDTH WithHeight:IMAGE_SMALL_HEIGHT WithLineBreak:YES];
    
}

-(void)show
{
    CAKeyframeAnimation * animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.5;
    
    animation.delegate = self;
    
    animation.removedOnCompletion = YES;
    
    animation.fillMode = kCAFillModeForwards;
    
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [_backgroundImageView.layer addAnimation:animation forKey:nil];
}


-(void)cancelButtonClick:(UIButton *)sender
{
    [self removeFromSuperview];
}


-(void)doneButtonClick:(UIButton *)sender
{
    if (zsnAlertViewBlock) {
        zsnAlertViewBlock(_textField.text);
    }
    
    [self removeFromSuperview];
}


#pragma mark-UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
