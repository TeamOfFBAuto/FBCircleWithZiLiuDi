//
//  ZkingSearchView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮

#import "ZkingSearchView.h"

#define HEIGHT  self.frame.size.height


@implementation ZkingSearchView

- (id)initWithFrame:(CGRect)frame imgBG:(UIImage *) bgimg shortimgbg:(UIImage*)theimgShort imgLogo:(UIImage *)logoimg  placeholder:(NSString *)_placeholder ZkingSearchViewBlocs:(ZkingSearchViewBloc)_bloc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgshortbg=[[UIImage alloc]init];
        _imgshortbg=theimgShort;
        
        _imglongbg=[[UIImage alloc]init];
        _imglongbg=bgimg;
        
        
        _mybloc=_bloc;
        
        _searchBG=[[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 288, _imglongbg.size.height)];
//        _searchBG.layer.borderColor = [UIColor blackColor].CGColor;
//        _searchBG.layer.borderWidth = 1.0;
        _searchBG.image=_imglongbg;
        _searchBG.userInteractionEnabled=YES;
        [self addSubview:_searchBG];
        
        
        
        
        _aSearchField=[[UITextField alloc]init];
        _aSearchField.delegate=self;
        _aSearchField.returnKeyType=UIReturnKeySearch;
        _aSearchField.placeholder=_placeholder;
        _aSearchField.font=[UIFont systemFontOfSize:14];
        [_searchBG addSubview:_aSearchField];
        
        
        UITapGestureRecognizer *onTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testBegain)];
        [_aSearchField addGestureRecognizer:onTap];

        
        _searchLogo=[[UIImageView alloc]initWithImage:logoimg];
        [_searchBG addSubview:_searchLogo];
        
        _cancelButton =[[UIButton alloc]init];
        [_cancelButton addTarget:self action:@selector(doCancelButton) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.hidden=YES;
        _cancelButton.backgroundColor=[UIColor clearColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_cancelButton];
        

        _aSearchField.frame=CGRectMake(40, (HEIGHT-15)/2, 260, 16);
        
        _searchLogo.center=CGPointMake(8+_searchLogo.image.size.width/2, HEIGHT/2);
        
        _cancelButton.frame=CGRectMake(264, 0, 40, 30);

        
       
    }
    return self;
}

-(void)testBegain{
    
    
    

    [_aSearchField becomeFirstResponder];
}
-(void)doCancelButton{
//取消
    
    _cancelButton.hidden=YES;
    _searchBG.image=_imglongbg;
    _searchBG.frame=CGRectMake(12, 0, 288, 30);
    
    _aSearchField.text=@"";
    [_aSearchField resignFirstResponder];
    
    _mybloc(@"",1);

}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{

    if (textView.text.length>=30) {
        return NO;
    }else{
        return YES;
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    _cancelButton.hidden=NO;
    
    
    _searchBG.image=_imgshortbg;
    
    
    NSLog(@"www===%f==height==%f",_imgshortbg.size.width,_imgshortbg.size.height);
    
    
    
    _searchBG.frame=CGRectMake(12, 0,_imgshortbg.size.width, 30);
    
    NSLog(@"mm===%f==nn==%f",_searchBG.frame.size.width,_searchBG.frame.size.height);


    
    _mybloc(@"",2);
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _mybloc(textField.text,3);
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
