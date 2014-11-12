//
//  ZSNAlertView.h
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"


typedef void(^ZSNAlertViewBlock)(NSString * theString);


@interface ZSNAlertView : UIView<UITextFieldDelegate>
{
    ZSNAlertViewBlock zsnAlertViewBlock;
}


@property(nonatomic,strong)UIImageView * backgroundImageView;

@property(nonatomic,strong)UILabel * forward_label;

@property(nonatomic,strong)AsyncImageView * imageView;

@property(nonatomic,strong)UILabel * userName_label;

@property(nonatomic,strong)OHAttributedLabel * content_label;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIButton * cancel_button;

@property(nonatomic,strong)UIButton * done_button;



-(void)setInformationWithUrl:(NSString *)url WithUserName:(NSString *)userName WithContent:(NSString *)content WithBlock:(ZSNAlertViewBlock)theBlock;

-(void)show;


@end
