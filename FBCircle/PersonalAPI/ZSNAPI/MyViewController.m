//
//  MyViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController
@synthesize leftButtonType = _leftButtonType;
@synthesize rightString = _rightString;
@synthesize leftImageName = _leftImageName;
@synthesize rightImageName = _rightImageName;
@synthesize leftString = _leftString;

@synthesize my_right_button = _my_right_button;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [self.navigationController.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
//    FBCircleNavBackGroundImage@2x
    
    [self.navigationController.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//返回按钮颜色

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    UIColor * cc = [UIColor clearColor];//RGBCOLOR(91,138,59);
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:18],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.title = self.titleLabel.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.view.backgroundColor = RGBCOLOR(214,214,214);//深色
    
    self.view.backgroundColor = COLOR_VIEW_BACKGROUND_SHEJITU;//设计图颜色
    
//    self.view.backgroundColor = [UIColor colorWithHexString:@""];
    
    
    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];//[UIFont fontWithName:@"Arial Hebrew" size:17];//[UIFont systemFontOfSize:18];
    self.navigationItem.titleView = _titleLabel;
   
}

-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType
{
    
    if (theType == MyViewControllerLeftbuttonTypeBack)
    {
        UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,8,40,44)];
        [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [button_back setImage:FBCIRCLE_BACK_IMAGE forState:UIControlStateNormal];
        button_back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
        self.navigationItem.leftBarButtonItems=@[spaceButton,back_item];
    }else if (theType == MyViewControllerLeftbuttonTypelogo)
    {
        UIImageView * leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7logo"]];
        leftImageView.center = CGPointMake(MY_MACRO_NAME? 18:30,22);
        UIView *lefttttview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [lefttttview addSubview:leftImageView];
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:lefttttview];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftButton];
    }else if(theType == MyViewControllerLeftbuttonTypeOther)
    {
        UIImage * leftImage = [UIImage imageNamed:_leftImageName];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftButton addTarget:self action:@selector(otherTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftButton setImage:[UIImage imageNamed:self.leftImageName] forState:UIControlStateNormal];
        
        leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
        
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];;
        
    }else if (theType == MyViewControllerLeftbuttonTypeText)
    {
        self.left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _left_button.frame = CGRectMake(0,0,60,44);
        
        _left_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_left_button setTitle:_leftString forState:UIControlStateNormal];
        
        _left_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_left_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_left_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_left_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_left_button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_left_button]];
    }else
    {
        
    }
    
    
    
    if (rightType == MyViewControllerRightbuttonTypeRefresh)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_refresh4139.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,41/2,39/2);
        _my_right_button.center = CGPointMake(300,20);
        [_my_right_button addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems= @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeSearch)
    {
        UIButton *rightview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 37, 37/2)];
        rightview.backgroundColor=[UIColor clearColor];
        [rightview addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_newssearch.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(MY_MACRO_NAME? 25:10, 0, 37/2, 37/2);
        //    refreshButton.center = CGPointMake(300,20);
        [rightview addSubview:_my_right_button];
        [_my_right_button addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *_rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=_rightitem;
        
    }else if(rightType == MyViewControllerRightbuttonTypeText)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,60,44);
        
        _my_right_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_my_right_button setTitle:_rightString forState:UIControlStateNormal];
        
        _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_my_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_my_right_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [_my_right_button addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeDelete)
    {
        
    }else if (rightType == MyViewControllerRightbuttonTypePerson)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,36/2,33/2);
        
        [_my_right_button setImage:[UIImage imageNamed:@"chat_people.png"] forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(PeopleView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * People_button = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,People_button];
        
        
    }else if(rightType == MyViewControllerRightbuttonTypeOther)
    {
        UIImage * rightImage = [UIImage imageNamed:_rightImageName];
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_my_right_button addTarget:self action:@selector(otherRightTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_my_right_button setImage:[UIImage imageNamed:self.rightImageName] forState:UIControlStateNormal];
        
        _my_right_button.frame = CGRectMake(0,0,rightImage.size.width,rightImage.size.height);
        
        UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
//        _my_right_button.backgroundColor = [UIColor orangeColor];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,rightBarButton];
        
    }else
    {
        
    }
}

-(void)otherTypeButton:(UIButton *)sender
{
    
}

-(void)otherRightTypeButton:(UIButton *)sender
{
    
}

-(void)leftButtonClick:(UIButton *)sender
{
    
}

-(void)PeopleView:(UIButton *)sender
{
    [self nextResponder];
}


-(void)submitData:(UIButton *)sender
{
    
}


-(void)refresh:(UIButton *)sender
{
    
}

-(void)refreshData:(UIButton *)sender
{
    //    [self nextResponder];
}


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)PushToViewController:(UIViewController *)controller WithAnimation:(BOOL)animation
{
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:animation];
}

/**
 *  延迟返回
 */
- (void)popViewControllerDelay:(CGFloat)seconds
{
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(back) userInfo:nil repeats:NO];
}

-(void)dealloc
{
    NSLog(@"-----%@",self);
}


@end
