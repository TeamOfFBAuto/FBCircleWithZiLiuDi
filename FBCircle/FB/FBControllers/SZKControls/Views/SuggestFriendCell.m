//
//  SuggestFriendCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.

#import "SuggestFriendCell.h"

@implementation SuggestFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageV=[[UIImageView alloc]init];
        _headImageV.backgroundColor=[UIColor whiteColor];
        CALayer *l = [_headImageV layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:3.0f];
        
        
        
        [self addSubview:_headImageV];
        
        _namelabel=[[UILabel alloc]init];
        [self addSubview:_namelabel];
        _namelabel.font=[UIFont systemFontOfSize:15];
        _namelabel.textAlignment=NSTextAlignmentLeft;
        _namelabel.textColor=[UIColor blackColor];
        
        _resourceLabel=[[UILabel alloc]init];
        [self addSubview:_resourceLabel];
        _resourceLabel.textColor=RGBCOLOR(155, 155, 155);
        _resourceLabel.font=[UIFont systemFontOfSize:12];
        _resourceLabel.textAlignment=NSTextAlignmentLeft;
        
        _resourceLabel.textColor=[UIColor darkGrayColor];
        
        _typeButton=[[UIButton alloc]init];
        _typeButton.tag=1000;
        [_typeButton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_typeButton];
        
        _model=[[FriendAttribute alloc]init];
        
    }
    return self;
}
//addfriend100_60@2x
-(void)layoutSubviews{

    [super layoutSubviews];
    
    _headImageV.frame=CGRectMake(12, 12, 47, 47);
    
    _namelabel.frame=CGRectMake(71, 15, 140, 17);
    
    _resourceLabel.frame=CGRectMake(71, 40, 200, 15);
    
    _typeButton.frame=CGRectMake(256, 20, 50, 30);
    

}

-(void)setindexpathrow:(NSInteger)row suggestmodel:(FriendAttribute *)themodel  mybloc:(SuggestFriendCellbloc)thebloc{

    _model=themodel;
    
    _mybloc=thebloc;
    
    
    

    NSLog(@"face===%@",themodel.face);

    [_headImageV setImageWithURL:[NSURL URLWithString:themodel.face] placeholderImage:[UIImage imageNamed:@"headimg150_150.png"]
 ];
    
    _namelabel.text=themodel.username;
    
  //  _resourceLabel.text=themodel.usertype;
    
    NSString *str_alaname=[NSString stringWithFormat:@"%@",themodel.rname];
    
    if (str_alaname.length>15) {
        
        
        str_alaname=[str_alaname substringToIndex:14];
    }
    
    
    _resourceLabel.text=[NSString stringWithFormat:@"%@",str_alaname];

    
    
    switch ([themodel.optype integerValue]) {
 //opttype:1.接受，2添加，3，邀请4，验证中，5，已添加 6,自己

        case 1:
        {
            _typeButton.tag=101;
            
            [_typeButton setBackgroundImage:[UIImage imageNamed:@"jieshou_button-100_60.png"] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"接受" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];

            
        }
            break;
        case 2:
        {
            
            
            _typeButton.tag=102;
            
            [_typeButton setBackgroundImage:[UIImage imageNamed:@"tianjia_button-100_60.png"] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"添加" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            
            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];

        }
            break;
        case 3:
        {
            
            _typeButton.tag=103;
            
            [_typeButton setBackgroundImage:[UIImage imageNamed:@"yaoqing_button-100_60.png"] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"邀请" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];
            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];


        }
            break;
        case 4:
        {
            
            _typeButton.tag=104;
            
            _typeButton.userInteractionEnabled=NO;

            [_typeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"验证中" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];

            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];

        }
            break;
            
        case 5:
        {
            _typeButton.tag=105;
            
            _typeButton.userInteractionEnabled=NO;
            
            [_typeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"已添加" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_typeButton setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];
            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];


        }
        
            
            break;
        case 6:
        {
            _typeButton.tag=106;
            
            _typeButton.userInteractionEnabled=NO;
            
            [_typeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [_typeButton setTitle:@"" forState:UIControlStateNormal];
            
            [_typeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_typeButton setTitleColor:RGBCOLOR(95, 95, 95) forState:UIControlStateNormal];
            _typeButton.titleLabel.font=[UIFont systemFontOfSize:13];
            
            
        }
            
            
            break;
        default:
            break;
    }


}


-(void)dobutton:(UIButton *)sender{

    _mybloc(_model,sender.tag);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
