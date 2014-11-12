//
//  AboutFBQuanViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//
//app当前版本

#define NOW_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#import "AboutFBQuanViewController.h"

@interface AboutFBQuanViewController ()

@end

@implementation AboutFBQuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text=@"关于fb圈";
     [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeDelete];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iPhone5?@"":@""]];
    imageView.frame = CGRectMake(0,0,320,iPhone5?1008/2:832/2);
    //    imageView.center = CGPointMake(160,iPhone5?252:208);
    imageView.backgroundColor = [UIColor clearColor];
    
    if (iPhone5) {
        [imageView setImage:[UIImage imageNamed:@"guanyu_640_1008.png"]];
    }else{
        [imageView setImage:[UIImage imageNamed:@"guanyu_640_832.png"]];
    }
    
    
    [self.view addSubview:imageView];
    
    
    UILabel * version_label = [[UILabel alloc] initWithFrame:CGRectMake(0,iPhone5?413:325,320,30)];
    
    version_label.text = [NSString stringWithFormat:@"版本:%@",NOW_VERSION];
    
    version_label.textColor = RGBCOLOR(255,255,255);
    
    version_label.font = [UIFont systemFontOfSize:15];
    
    version_label.textAlignment = NSTextAlignmentCenter;
    
    version_label.backgroundColor = [UIColor clearColor];
    
    
    
    [self.view addSubview:version_label];

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
