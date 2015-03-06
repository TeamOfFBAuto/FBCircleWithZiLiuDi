//
//  FbRegistCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//
//101代表button传过去的，102代表数值改变
#import "FbRegistCell.h"

@implementation FbRegistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _imgLogo=[[UIImageView alloc]init];
        [self addSubview:_imgLogo];
        
        _imgLine=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, DEVICE_WIDTH - 10, 0.5)];
        [self addSubview:_imgLine];
        _imgLine.backgroundColor = RGBCOLOR(211, 211, 211);
        
        _inputField=[[UITextField alloc]init];
        _inputField.delegate=self;
        [self addSubview:_inputField];
        
        _sendVerficationButton=[[UIButton alloc]init];
        _sendVerficationButton.hidden=YES;//92,137,163
        
        //[_sendVerficationButton setImage:[UIImage imageNamed:@"yanzhengma-116_44.png"] forState:UIControlStateNormal];
        [_sendVerficationButton setBackgroundImage:[UIImage imageNamed:@"yanzhengma-116_44.png"] forState:UIControlStateNormal];
        [_sendVerficationButton setTitle:@"发验证码" forState:UIControlStateNormal];
        _sendVerficationButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_sendVerficationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_sendVerficationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_sendVerficationButton setTitleColor:RGBCOLOR(92, 137, 163) forState:UIControlStateNormal];
        [_sendVerficationButton addTarget:self action:@selector(setSendVerficationwith:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendVerficationButton];
       // _sendVerficationButton.backgroundColor=[UIColor whiteColor];

    }
    return self;
}


-(void)layoutSubviews{
    
    //    _imgLine.center=CGPointMake(25, 28);
    _inputField.frame=CGRectMake(50, (44-18)/2, DEVICE_WIDTH - 120, 18);
    _sendVerficationButton.frame=CGRectMake(DEVICE_WIDTH - 320 + 238, 11, 116/2, 22);
    
    
}

-(void)setFbRegistCellType:(FbRegistCellType)_type placeHolderText:(NSString *)_plcaeText str_img:(NSString *)_str_img fbregistbloc:(FbRegistCellBloc)_bloc row:(NSInteger )alarow
{
    if (alarow==3||alarow==4) {
        _inputField.keyboardType=UIKeyboardTypeDecimalPad;
    }else{
        _inputField.keyboardType=UIKeyboardTypeDefault;

    }
    
    _rowofindexpath=alarow;
    switch (_type) {
        case 0:
        {
            _sendVerficationButton.hidden=YES;
        }
            break;
        case 1:
        {
            _sendVerficationButton.hidden=NO;
            
        }
            break;
        case 2:
        {
            _sendVerficationButton.hidden=YES;
            _inputField.secureTextEntry=YES;
            
        }
            break;

        default:
            break;
    }
    _inputField.placeholder=_plcaeText;
    _imgLogo.image=[UIImage imageNamed:_str_img];
    _imgLogo.frame=CGRectMake(10, 15, 30, _imgLogo.image.size.height);
    _imgLogo.contentMode = UIViewContentModeCenter;
    _mybloc=_bloc;
    
}

#pragma mark--发送验证码

-(void)setSendVerficationwith:(UIButton *)sender{
    
    if (_inputField.text.length==0) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码为空" delegate:nil cancelButtonTitle:@"请重新输入" otherButtonTitles:nil, nil];
        [alertV show];
        return;
        
    }
    
    _sendVerficationButton.userInteractionEnabled=NO;
    _mybloc(101,_rowofindexpath,_inputField.text);
    sender.userInteractionEnabled=NO;
    secondsCountDown=60;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod{
    
    [_sendVerficationButton setTitle:[NSString stringWithFormat:@"重发%d",secondsCountDown] forState:UIControlStateNormal];
    [_sendVerficationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    secondsCountDown--;
    
    if(secondsCountDown==-1){
        [countDownTimer invalidate];
        [_sendVerficationButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];

        [_sendVerficationButton setTitleColor:RGBCOLOR(92, 137, 163) forState:UIControlStateNormal];
        
        [_sendVerficationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        _sendVerficationButton.userInteractionEnabled=YES;

    }
    
}

-(void)sendtextfieldtext{
    
}


#pragma mark--uitextfield的代理

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //编辑完传过值去
}

-(BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    _mybloc(102,_rowofindexpath,[NSString stringWithFormat:@"%@%@",field.text,string]);
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //   _mybloc(102,_rowofindexpath,textField.text);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
