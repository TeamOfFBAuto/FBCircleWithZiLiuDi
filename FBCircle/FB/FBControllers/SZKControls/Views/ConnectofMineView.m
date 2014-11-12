//
//  ConnectofMineView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-6-5.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ConnectofMineView.h"

@implementation ConnectofMineView

- (id)initWithFrame:(CGRect)frame Thebloc:(ConnectofMineViewBloc )bloc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _myBloc=bloc;
        UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dotheTap)];
        [self addGestureRecognizer:oneTap];
        
        _imgVBG=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxiyixing-bg-270_60.png"]];
        _imgVBG.frame=CGRectMake(0, 0, 270/2, 30);
        _imgVBG.userInteractionEnabled=YES;
        [_imgVBG addGestureRecognizer:oneTap];
        
        _imgVRight=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tixiang-jiantou-16_26.png"]];
        _imgVRight.center=CGPointMake(120, 15);
        [_imgVBG addSubview:_imgVRight];
        
        _headimgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _headimgV.center=CGPointMake(25, 15);
        [_imgVBG addSubview:_headimgV];
        
        _redCircle=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuliang-bg-30_30.png"]];
        _redCircle.center=CGPointMake(103, 15);
        [_imgVBG addSubview:_redCircle];
        
        _connecttomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 70, 30)];
        _connecttomeLabel.font=[UIFont systemFontOfSize:13];
        _connecttomeLabel.textAlignment = NSTextAlignmentLeft;
        _connecttomeLabel.textColor=RGBCOLOR(114, 114, 114);
        _connecttomeLabel.backgroundColor = [UIColor clearColor];
        _connecttomeLabel.text=@"与我相关";
        [_imgVBG addSubview:_connecttomeLabel];
        
        
//   UILabel  *    _connecttomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,0,70,30)];
//        
//        _connecttomeLabel.text = @"与我相关";
//        
//        _connecttomeLabel.textAlignment = NSTextAlignmentLeft;
//        
//        _connecttomeLabel.textColor = [UIColor greenColor];
//        
//       //   _connecttomeLabel.font=[UIFont systemFontOfSize:12];
//
//        
//        [_imgVBG addSubview:_connecttomeLabel];
//        
        
        
        _numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [_redCircle addSubview:_numberLabel];
        _numberLabel.textAlignment=NSTextAlignmentCenter;
        _numberLabel.textColor=[UIColor whiteColor];
        _numberLabel.font=[UIFont systemFontOfSize:11];
        
        
//        [self addSubview:_imgVRight];
        [self addSubview:_imgVBG];
//        [self addSubview:_redCircle];
//        [self addSubview:_connecttomeLabel];
        
        
        

        
    }
    return self;
}

-(void)setNoticeNumber:(NSString *)str_Number Hearimg:(NSString *)str_imghead{

    
    NSLog(@"num sss---  %@ -- %@",str_imghead,str_Number);
  _numberLabel.text=[NSString stringWithFormat:@"%@",str_Number];
    
  //  [_headimgV loadImageFromURL:str_imghead withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
    
    [_headimgV setImageWithURL:[NSURL URLWithString:str_imghead] placeholderImage:PERSONAL_DEFAULTS_IMAGE];

}
//点击后到消息界面

-(void)dotheTap{

    _myBloc();
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
