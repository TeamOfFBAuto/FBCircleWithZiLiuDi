//
//  FBCircleDetailPraiseView.m
//  FBCircle
//
//  Created by soulnear on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleDetailPraiseView.h"

@implementation FBCircleDetailPraiseView
@synthesize delegate = _delegate;
@synthesize praise_imageView = _praise_imageView;
@synthesize up_line_view = _up_line_view;
@synthesize bottom_line_view = _bottom_line_view;
@synthesize aView = _aView;
@synthesize left_view = _left_view;
@synthesize right_view = _right_view;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        data_array = [NSMutableArray array];
        
        if (!_aView) {
            _aView = [[UIView alloc] initWithFrame:CGRectMake(0,5,self.frame.size.width,self.frame.size.height-5)];
            
            _aView.backgroundColor = RGBCOLOR(249,249,249);
            
            [self addSubview:_aView];
        }
        
        if (!_praise_imageView) {
            _praise_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinglun-xin-down-24_24.png"]];
            
            _praise_imageView.center = CGPointMake(27,33);
            
            [self addSubview:_praise_imageView];
        }
        
        
        if (!_up_line_view) {
            _up_line_view = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"pinglun640_10.png"]];
            
            _up_line_view.center = CGPointMake(_aView.center.x,2.5);
            
            [self addSubview:_up_line_view];
        }
        
        if (!_bottom_line_view) {
            _bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,0.5)];
            
            _bottom_line_view.backgroundColor = RGBCOLOR(237,237,237);
            
            [self addSubview:_bottom_line_view];
        }
        
//        if (!_left_view)
//        {
//            _left_view = [[UIView alloc] initWithFrame:CGRectMake(0,5,0.5,0)];
//            
//            _left_view.backgroundColor = RGBCOLOR(237,237,237);
//            
//            [self addSubview:_left_view];
//        }
//        
//        
//        if (!_right_view)
//        {
//            _right_view = [[UIView alloc] initWithFrame:CGRectMake(297,5,0.5,0)];
//            
//            _right_view.backgroundColor = RGBCOLOR(237,237,237);
//            
//            [self addSubview:_right_view];
//        }
        
        
    }
    return self;
}



-(float)loadAllUserImagesWith:(NSMutableArray *)array
{
    data_array = array;
    
    float height = 5;
    
    if (array.count == 0) {
        _bottom_line_view.hidden = YES;
    }else
    {
        int rows = array.count%6?1:0 + array.count/6;
        
        for (int j = 0;j < rows;j++)
        {
            for (int i = 0;i < 6;i++)
            {
                if (i + j*6 < array.count)
                {
                    FBCirclePraiseModel * model = [array objectAtIndex:i];
                    
                    AsyncImageView * imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(44 + 40*i,8 + j*40,35,35)];
                    
                    if ([model.praise_uid isEqualToString:[SzkAPI getUid]])
                    {
                        [imageView loadImageFromURL:[SzkAPI getUserFace] withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
                    }else
                    {
                        [imageView loadImageFromURL:model.praise_image_url withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
                    }
                    
                    
                    imageView.userInteractionEnabled = YES;
                    
                    imageView.layer.masksToBounds = YES;
                    
                    imageView.layer.cornerRadius = 5;
                    
                    imageView.tag = 100 + i + j*6;
                    
                    [_aView addSubview:imageView];
                    
                    
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(headerClick:)];
                    
                    [imageView addGestureRecognizer:tap];
                    
                }
            }
        }
        height = 16+rows*40;
        
//        _left_view.frame = CGRectMake(_left_view.frame.origin.x,_left_view.frame.origin.y,_left_view.frame.size.width,height -5);
//        
//        _right_view.frame = CGRectMake(_right_view.frame.origin.x,_right_view.frame.origin.y,_right_view.frame.size.width,height -5);
        
        _bottom_line_view.frame = CGRectMake(_bottom_line_view.frame.origin.x,height - 0.5,_bottom_line_view.frame.size.width,_bottom_line_view.frame.size.height);
    }
    
    
    
    
    return height;
}

-(float)loadAllUserNameWith:(NSMutableArray *)theNameString
{
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64,18,12,12)];
    
    iconImageView.image = [UIImage imageNamed:@"fb_zan_28_28.png"];
    
    [self addSubview:iconImageView];
    
    
    
    float height = 0;
    
    RTLabel * _zan_label = [[RTLabel alloc] initWithFrame:CGRectMake(80,18,230,0)];
    
    _zan_label.font = [UIFont systemFontOfSize:14];
    
    _zan_label.lineBreakMode = NSLineBreakByCharWrapping;
    
    _zan_label.lineSpacing = 3;
    
    _zan_label.backgroundColor = [UIColor clearColor];
    
    _zan_label.text = [self returnZanStringWith:theNameString];
    
    CGSize zanOptimusize = [_zan_label optimumSize];
    
    _zan_label.frame = CGRectMake(_zan_label.frame.origin.x,18,_zan_label.frame.size.width,zanOptimusize.height+3);
    
    [_aView addSubview:_zan_label];
    
    height = zanOptimusize.height + 18;
    
    
    _left_view.frame = CGRectMake(_left_view.frame.origin.x,_left_view.frame.origin.y,_left_view.frame.size.width,height -5);
    
    _right_view.frame = CGRectMake(_right_view.frame.origin.x,_right_view.frame.origin.y,_right_view.frame.size.width,height -5);
    
    _bottom_line_view.frame = CGRectMake(_bottom_line_view.frame.origin.x,height - 0.5,_bottom_line_view.frame.size.width,_bottom_line_view.frame.size.height);
    
    
    return height;
}


-(NSString *)returnZanStringWith:(NSMutableArray *)array
{
    
    NSString * zanString = @"";
    
    for (int i = 0;i < array.count;i++)
    {
        FBCirclePraiseModel * model = [array objectAtIndex:i];
        
        if (i == 0) {
            zanString = [zanString stringByAppendingFormat:@"%@",model.praise_username];
        }else
        {
            zanString = [zanString stringByAppendingFormat:@",%@",model.praise_username];
        }
    }
    
    return zanString;
}


-(void)headerClick:(UITapGestureRecognizer *)sender
{
    FBCirclePraiseModel * model = [data_array objectAtIndex:sender.view.tag-100];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickHeaderShowInfomationWith:)])
    {
        [_delegate clickHeaderShowInfomationWith:model.praise_uid];
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
