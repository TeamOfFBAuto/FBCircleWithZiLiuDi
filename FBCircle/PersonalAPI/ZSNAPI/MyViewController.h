//
//  MyViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MyViewControllerLeftbuttonTypeBack=0,
    MyViewControllerLeftbuttonTypelogo=1,
    MyViewControllerLeftbuttonTypeOther=2,
    MyViewControllerLeftbuttonTypeNull=3,
    MyViewControllerLeftbuttonTypeText = 4
}MyViewControllerLeftbuttonType;


typedef enum
{
    MyViewControllerRightbuttonTypeRefresh=0,
    MyViewControllerRightbuttonTypeSearch=1,
    MyViewControllerRightbuttonTypeText=2,
    MyViewControllerRightbuttonTypePerson=3,
    MyViewControllerRightbuttonTypeDelete=4,
    MyViewControllerRightbuttonTypeNull=5,
    MyViewControllerRightbuttonTypeOther
}MyViewControllerRightbuttonType;


@interface MyViewController : UIViewController
{
    UIBarButtonItem * spaceButton;
}

@property(nonatomic,assign)MyViewControllerLeftbuttonType * leftButtonType;

@property(nonatomic,strong)NSString * rightString;

@property(nonatomic,strong)NSString * leftString;

@property(nonatomic,strong)NSString * leftImageName;

@property(nonatomic,strong)NSString * rightImageName;


//右上角按钮
@property(nonatomic,strong)UIButton * my_right_button;

//左上角按钮
@property(nonatomic,strong)UIButton * left_button;

@property(nonatomic,retain)UILabel *titleLabel;


-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType;


///push到下一界面,包含隐藏tabbar
-(void)PushToViewController:(UIViewController *)controller WithAnimation:(BOOL)animation;

//pop回上一页,可设置延迟时间
- (void)popViewControllerDelay:(CGFloat)seconds;

@end
