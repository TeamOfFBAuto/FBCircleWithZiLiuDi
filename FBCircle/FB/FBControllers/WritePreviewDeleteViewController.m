//
//  WritePreviewDeleteViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "WritePreviewDeleteViewController.h"

@interface WritePreviewDeleteViewController ()

@end

@implementation WritePreviewDeleteViewController
@synthesize myScrollView = _myScrollView;
@synthesize AllImagesArray = _AllImagesArray;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)back
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,20,44,44)];
    
    [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [button_back setImage:FBCIRCLE_BACK_IMAGE forState:UIControlStateNormal];
    
    button_back.center = CGPointMake(20,42);
    
    [daohangView addSubview:button_back];
    
    title_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,64)];
    
    title_label.text = [NSString stringWithFormat:@"选中%d张中的%d张",self.AllImagesArray.count,_currentPage+1];
    
    title_label.font = TITLEFONT;
    
    title_label.textAlignment = NSTextAlignmentCenter;
    
    title_label.textColor = [UIColor whiteColor];//RGBCOLOR(91,138,59);
    
    title_label.center = CGPointMake(DEVICE_WIDTH/2,42);
    
    [daohangView addSubview:title_label];
    
    
    
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    chooseButton.frame = CGRectMake(0,0,50,30);
    
    [chooseButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [chooseButton addTarget:self action:@selector(PreviewChooseTap:) forControlEvents:UIControlEventTouchUpInside];
    
    chooseButton.center = CGPointMake(DEVICE_WIDTH-30,42);
    
    [daohangView addSubview:chooseButton];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = RGBCOLOR(229,229,229);
    
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH+20,DEVICE_HEIGHT)];
    
    _myScrollView.delegate = self;
    
    _myScrollView.pagingEnabled = YES;
    
    _myScrollView.backgroundColor = RGBCOLOR(242,242,242);
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
    _myScrollView.contentSize = CGSizeMake(340*self.AllImagesArray.count,0);
    
    [self.view addSubview:_myScrollView];
    
    _myScrollView.contentOffset = CGPointMake((DEVICE_WIDTH+20)*_currentPage,0);
    
    
    [self loadAllViews];
    
    
    [self setNavgationBar];
}



-(void)loadAllViews
{
    for (UIView * view in _myScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0;i < self.AllImagesArray.count;i++)
    {
        QBShowImagesScrollView * ScrollView = [[QBShowImagesScrollView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH+20)*i,0,DEVICE_WIDTH,_myScrollView.frame.size.height) WithLocation:[self.AllImagesArray objectAtIndex:i]];
        ScrollView.aDelegate = self;
        ScrollView.tag = 1000+i;
        ScrollView.backgroundColor = RGBCOLOR(242,242,242);
        [_myScrollView addSubview:ScrollView];
    }
}




-(void)PreviewChooseTap:(UIButton *)sender
{
    
    ///图片预览完成
    
    
//    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil,nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark-UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    title_label.text = [NSString stringWithFormat:@"选中%d张中的%d张",self.AllImagesArray.count,_currentPage+1];
}




#pragma mark-QBShowImagesScrollViewDelegate

-(void)singleClicked
{
    UIApplication * app = [UIApplication sharedApplication];
    
    [self hiddenToolBar:!app.statusBarHidden];
}



-(void)hiddenToolBar:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    
    CGRect frame = navImageView.frame;
    
    frame.origin.y = frame.origin.y + (isHidden?-frame.size.height:frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        navImageView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark-UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
//            [self singleClicked];
            
            if (preViewBlock) {
                preViewBlock(_currentPage);
            }
            
            if (self.AllImagesArray.count ==  0)
            {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            
            
            if (_currentPage>0)
            {
                _currentPage--;
            }
            
            title_label.text = [NSString stringWithFormat:@"选中%d张中的%d张",self.AllImagesArray.count,_currentPage+1];
            _myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*_AllImagesArray.count,0);
            _myScrollView.contentOffset = CGPointMake((DEVICE_WIDTH+20)*_currentPage,0);
            [self loadAllViews];
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)deleteSomeImagesWithBlock:(PreViewDeleteBlock)theBlock
{
    preViewBlock = theBlock;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
