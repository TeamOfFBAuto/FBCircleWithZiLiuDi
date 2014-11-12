//
//  ConnectofMineView.h
//  FBCircle
//
//  Created by 史忠坤 on 14-6-5.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ConnectofMineViewBloc)();


@interface ConnectofMineView : UIView{

    UILabel *  _connecttomeLabel;

}

@property (nonatomic,strong)UIImageView *imgVBG;//底部的背景

@property (nonatomic,strong)UIImageView *imgVRight;//右箭头

@property (nonatomic,strong)UIImageView *redCircle;//红色的圆圈

@property (nonatomic,strong)UIImageView *headimgV;//头像


//@property (nonatomic,strong)UILabel *connecttomeLabel;//固定写死，“与我相关”

@property (nonatomic,strong)UILabel *numberLabel;//显示的数字

@property(nonatomic,copy)ConnectofMineViewBloc myBloc;

-(void)setNoticeNumber:(NSString *)str_Number Hearimg:(NSString *)str_imghead;

- (id)initWithFrame:(CGRect)frame Thebloc:(ConnectofMineViewBloc )bloc;

@end
