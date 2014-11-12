//
//  FbRegistCell.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//




#import <UIKit/UIKit.h>


typedef enum{
    FbRegistCellTypeNormal=0,//不带发送验证码的按钮
    FbRegistCellTypeofButton=1,//发送按钮类型
    FbRegistCellTypePassWord=2,//password类型，小星星
    
}FbRegistCellType;

typedef void(^FbRegistCellBloc)(int tag ,NSInteger  indexpathofrow,NSString *stringtext);


@interface FbRegistCell : UITableViewCell<UITextFieldDelegate>{

    int   secondsCountDown ;//60秒倒计时
    NSTimer *countDownTimer;

}

@property(nonatomic,strong)UIImageView *imgLogo;

@property(nonatomic,strong)UITextField *inputField;

@property(nonatomic,strong)UIButton *sendVerficationButton;

@property(nonatomic,strong)UIImageView *imgLine;

@property(nonatomic,copy)FbRegistCellBloc mybloc;

@property(nonatomic,assign)NSInteger  rowofindexpath;



-(void)setFbRegistCellType:(FbRegistCellType)_type placeHolderText:(NSString *)_plcaeText str_img:(NSString *)_str_img fbregistbloc:(FbRegistCellBloc)_bloc row:(NSInteger )alarow;

-(void)sendtextfieldtext;

@end
