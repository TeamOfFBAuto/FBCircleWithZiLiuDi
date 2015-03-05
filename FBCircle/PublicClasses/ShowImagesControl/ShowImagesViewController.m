//
//  ShowImagesViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ShowImagesViewController.h"

@interface ShowImagesViewController ()

@end

@implementation ShowImagesViewController
@synthesize allImagesUrlArray = _allImagesUrlArray;
@synthesize myScrollView = _myScrollView;
@synthesize currentPage = _currentPage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)back
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
}


-(void)setNavgationBar
{
    
    navImageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    navImageView.backgroundColor = RGBCOLOR(229,229,229);
    [self.view addSubview:navImageView];
    
    
    UIImageView * daohangView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    daohangView.image = FBCIRCLE_NAVIGATION_IMAGE;
    daohangView.userInteractionEnabled = YES;
    [navImageView addSubview:daohangView];
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,20,50,44)];
    [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:FBCIRCLE_BACK_IMAGE forState:UIControlStateNormal];
    button_back.center = CGPointMake(20,42);
    [daohangView addSubview:button_back];
    
    
    
    title_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,64)];
    title_label.text = [NSString stringWithFormat:@"%d/%d",_currentPage+1,self.allImagesUrlArray.count];
    title_label.font = TITLEFONT;
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.textColor = [UIColor whiteColor];//RGBCOLOR(91,138,59);
    title_label.center = CGPointMake(DEVICE_WIDTH/2,42);
    [daohangView addSubview:title_label];
    
    
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(0,0,30,30);
    [chooseButton setImage:[UIImage imageNamed:@"baocun40_48.png"] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(SavePicturesClick:) forControlEvents:UIControlEventTouchUpInside];
    chooseButton.center = CGPointMake(DEVICE_WIDTH-25,42);
    [daohangView addSubview:chooseButton];
    
}


-(void)SavePicturesClick:(UIButton *)sender
{
    QBShowImagesScrollView * scrollView = (QBShowImagesScrollView *)[_myScrollView viewWithTag:_currentPage+1000];
    
    if (scrollView.locationImageView.image)
    {
        UIImageWriteToSavedPhotosAlbum(scrollView.locationImageView.image,self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    myAlertView = [[FBQuanAlertView alloc] initWithFrame:CGRectMake(0,0,138,50)];
    
    [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"保存图片成功"];
    
    myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-20);
    
    [self.view addSubview:myAlertView];

    [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
}

-(void)dismissPromptView
{
    [myAlertView removeFromSuperview];
    
    myAlertView = nil;
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;

    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = RGBCOLOR(229,229,229);
    
    self.title = [NSString stringWithFormat:@"%d/%d",_currentPage+1,self.allImagesUrlArray.count];
    
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH+20,DEVICE_HEIGHT)];
    _myScrollView.delegate = self;
    _myScrollView.pagingEnabled = YES;
    _myScrollView.backgroundColor = RGBCOLOR(242,242,242);
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*self.allImagesUrlArray.count,0);
    [self.view addSubview:_myScrollView];
    
    _myScrollView.contentOffset = CGPointMake((DEVICE_WIDTH+20)*_currentPage,0);
    
    if ([[self.allImagesUrlArray objectAtIndex:0] isKindOfClass:[UIImage class]])
    {
        for (int i = 0;i < self.allImagesUrlArray.count;i++)
        {
            QBShowImagesScrollView * scrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH+20)*i,0,DEVICE_WIDTH,_myScrollView.frame.size.height) WithUrl:@""];
            scrollView.aDelegate = self;
            scrollView.tag = 1000+i;
            scrollView.locationImageView.image = [self.allImagesUrlArray objectAtIndex:i];
            scrollView.backgroundColor = RGBCOLOR(242,242,242);
            [_myScrollView addSubview:scrollView];
        }
        
    }else
    {
        for (int i = 0;i < self.allImagesUrlArray.count;i++)
        {
            NSString * string = [self.allImagesUrlArray objectAtIndex:i];
            
            while ([string rangeOfString:@"small"].length) {
                string=[string stringByReplacingOccurrencesOfString:@"small" withString:@"ori"];
            }
            
            QBShowImagesScrollView * scrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH+20)*i,0,DEVICE_WIDTH,_myScrollView.frame.size.height) WithUrl:string];
            scrollView.aDelegate = self;
            scrollView.tag = 1000+i;
            scrollView.backgroundColor = RGBCOLOR(242,242,242);
            [_myScrollView addSubview:scrollView];
        }
    }
    
    [self setNavgationBar];
}


#pragma mark-UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    title_label.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)self.allImagesUrlArray.count];
}



#pragma mark- QBShowImagesScrollViewDelegate


-(void)singleClicked
{
    UIApplication * app = [UIApplication sharedApplication];
    
    BOOL isHidden = !app.statusBarHidden;
    
    [app setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    
    CGRect frame = navImageView.frame;
    
    frame.origin.y = frame.origin.y + (isHidden?-frame.size.height:frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        navImageView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)dealloc
{
    myAlertView = nil;
    
    
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
