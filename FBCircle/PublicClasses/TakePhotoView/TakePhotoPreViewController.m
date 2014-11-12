//
//  TakePhotoPreViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "TakePhotoPreViewController.h"

@interface TakePhotoPreViewController ()

@end

@implementation TakePhotoPreViewController
@synthesize imageView = _imageView;
@synthesize theImage = _theImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


-(id)initWithBlock:(TakePhotoPreViewControllerBlock)theBlock
{
    self = [super init];
    
    if (self)
    {
        take_preView_block = theBlock;
    }
    
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    _imageView.image = _theImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView.center = self.view.center;
    
    [self.view addSubview:_imageView];
    
    
    
    UIView * bottom_view = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-53,320,53)];
    
    bottom_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:bottom_view];
    
    
    UIButton * cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancel_button.frame = CGRectMake(10,0,80,53);
    
    [cancel_button setTitle:@"重拍" forState:UIControlStateNormal];
    
    cancel_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [cancel_button addTarget:self action:@selector(cancelTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottom_view addSubview:cancel_button];
    
    
    
    UIButton * use_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    use_button.frame = CGRectMake(230,0,80,53);
    
    [use_button setTitle:@"使用照片" forState:UIControlStateNormal];
    
    use_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [use_button addTarget:self action:@selector(useTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottom_view addSubview:use_button];
    
}


#pragma mark - 取消按钮

-(void)cancelTap:(UIButton *)sender
{
//    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 使用照片


-(void)useTap:(UIButton *)sender
{
//    [self dismissViewControllerAnimated:YES completion:^{
        if (take_preView_block)
        {
            take_preView_block();
        }
//    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end










