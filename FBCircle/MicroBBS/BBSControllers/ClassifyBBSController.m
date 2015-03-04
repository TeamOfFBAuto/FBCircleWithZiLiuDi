//
//  ClassifyBBSController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ClassifyBBSController.h"
#import "ClassifyBBSController_Sub.h"
#import "CreateNewBBSViewController.h"
#import "BBSSearchController.h"
#import "BBSModel.h"

#define CACHE_BBS_CLSSIFY @"classfiy" //论坛分类缓存
#define CACHE_BBS_TIME @"classTime" //论坛分类缓存时间

@interface ClassifyBBSController ()<UISearchBarDelegate>
{
    NSArray *_tuijian_Arr;//第一部分 推荐
    NSArray *_normal_Array;//第二部分 正常
    UIView *search_bgview;
    UIScrollView *bgScroll;
    
    UIView *second_bgView;//第二部分背景view
    
    BOOL finish;//判断两个接口完成数
}

@end

@implementation ClassifyBBSController

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
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"分类论坛";
    self.title = @"分类论坛";
    
    self.rightImageName = @"+";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索
    [self createSearchView];
    
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, search_bgview.bottom, DEVICE_WIDTH, self.view.height - 44 - 20 - search_bgview.height)];
    bgScroll.backgroundColor = [UIColor clearColor];
    bgScroll.showsHorizontalScrollIndicator = NO;
    bgScroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:bgScroll];
    

    NSDictionary *dataInfo = [LTools cacheForKey:CACHE_BBS_CLSSIFY];
    if ([dataInfo isKindOfClass:[NSDictionary class]]) {
        
        [self parseBBSClass:dataInfo];
        
        BOOL need = [LTools needUpdateForHours:1.0 recordDate:[LTools cacheForKey:CACHE_BBS_TIME]];
    
        if (need) {
            [self getBBSClass];
        }
        
    }else
    {
        [self getBBSClass];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _tuijian_Arr = nil;//第一部分 推荐
    _normal_Array = nil;//第二部分 正常
    search_bgview = nil;
    bgScroll = nil;
    second_bgView = nil;//第二部分背景view
}

#pragma mark - 事件处理

/**
 *  进入分类论坛 -- 二级页面
 */

- (void)clickToSubClassifyBBS:(UIButton *)sender
{
    NSString *title = nil;
    NSString *class_id = nil;
    if (sender.tag < 1000) {
        //上部分 100开始
        
        BBSModel *aModel = [_tuijian_Arr objectAtIndex:sender.tag - 100];
        title = aModel.classname;
        class_id = aModel.id;
        
    }else
    {
        //下部分 1000开始
        BBSModel *aModel = [_normal_Array objectAtIndex:sender.tag - 1000];
        title = aModel.classname;
        class_id = aModel.id;
        
    }
    ClassifyBBSController_Sub *sub = [[ClassifyBBSController_Sub alloc]init];
    sub.navigationTitle = title;
    sub.class_id = class_id;
    [self PushToViewController:sub WithAnimation:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    CreateNewBBSViewController * sendPostVC = [[CreateNewBBSViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
    BBSSearchController *search = [[BBSSearchController alloc]init];
    [self PushToViewController:search WithAnimation:YES];
}

#pragma mark - 数据解析


- (void)parseBBSClass:(NSDictionary *)dataInfo
{
    NSArray *tuijian = [dataInfo objectForKey:@"tuijian"];
    NSArray *normal = [dataInfo objectForKey:@"nomal"];
    
    NSMutableArray *arr_tuijian = [NSMutableArray arrayWithCapacity:dataInfo.count];
    NSMutableArray *arr_normal = [NSMutableArray arrayWithCapacity:dataInfo.count];
    for (NSDictionary *aDic in tuijian) {
        
        [arr_tuijian addObject:[[BBSModel alloc]initWithDictionary:aDic]];
    }
    
    for (NSDictionary *aDic in normal) {
        
        [arr_normal addObject:[[BBSModel alloc]initWithDictionary:aDic]];
        
    }
    
    [self createFirstViewWithTitles:arr_tuijian];
    [self createSecondViewWithDataArray:arr_normal];

}

#pragma mark - 网络请求
/**
 *  官方论坛分类
 */
- (void)getBBSClass
{
    __weak typeof(self)weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:FBCIRCLE_MICROBBS_BBSCLASS isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            [LTools cache:dataInfo ForKey:CACHE_BBS_CLSSIFY];
            [LTools cache:[NSDate date] ForKey:CACHE_BBS_TIME];
            
            
            for (int i = 0; i < bgScroll.subviews.count; i ++) {
                UIView *aView = [bgScroll.subviews objectAtIndex:i];
                [aView removeFromSuperview];
                aView = nil;
                NSLog(@"aview %@",aView);
            }
            
            [weakSelf parseBBSClass:dataInfo];
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
    }];
}

#pragma mark - 视图创建

/**
 *  搜索view
 */
- (void)createSearchView
{
    search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 45)];
    bar.placeholder = @"搜索";
    bar.layer.borderWidth = 2.f;
    bar.layer.borderColor = COLOR_SEARCHBAR.CGColor;
    bar.barTintColor = COLOR_SEARCHBAR;
    bar.delegate = self;
    [search_bgview addSubview:bar];
}

- (void)createFirstViewWithTitles:(NSArray *)titles
{
    _tuijian_Arr = titles;
    
    int k = 0;
    int line = 0;
    for (int i = 0 ; i < titles.count; i ++) {
        NSString *title = ((BBSModel *)[titles objectAtIndex:i]).classname;
        
        NSRange range = [title rangeOfString:@"（"];
        if (range.location > 0) {
            
            NSArray *arr = [title componentsSeparatedByString:@"（"];
            
            if (arr.count > 0) {
                title = [arr objectAtIndex:0];
            }
        }
        
//        NSMutableString *tt = [NSMutableString stringWithString:title];
//        [tt replaceOccurrencesOfString:@"）" withString:@")" options:0 range:NSMakeRange(0, tt.length)];
//        [tt replaceOccurrencesOfString:@"（" withString:@"(" options:0 range:NSMakeRange(0, tt.length)];
        NSString *imageUrl = ((BBSModel *)[titles objectAtIndex:i]).id;
        
        k = i % 4;
        line = i / 4;
        
        CGFloat dis_h = (DEVICE_WIDTH - 72 * 4 - 20)/3.f;
        
        LButtonView *lBtn = [[LButtonView alloc]initWithFrame:CGRectMake(10 + (dis_h + 72) * k,15 + (15 + 72) * line, 72, 67) imageUrl:nil placeHolderImage:nil title:title target:self action:@selector(clickToSubClassifyBBS:)];
        lBtn.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"classification_big%@",imageUrl]];
        lBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL];
        lBtn.tag = 100 + i;
        
        [bgScroll addSubview:lBtn];
    }

}

- (void)createSecondViewWithDataArray:(NSArray *)array
{
    _normal_Array = array;
    CGFloat aY = [bgScroll viewWithTag:(_tuijian_Arr.count + 100 - 1)].bottom + 15;
    int k = 0;
    int line = 0;
    for (int i = 0; i < array.count; i ++) {
        
        NSString *title = ((BBSModel *)[array objectAtIndex:i]).classname;
        
        k = i % 4;
        line = i / 4;
        
        if (i % 4 == 0) {
            UIView *line_bg = [[UIView alloc]initWithFrame:CGRectMake(0, aY + 45 * (i / 4), DEVICE_WIDTH, 45)];
            line_bg.backgroundColor = [UIColor colorWithHexString:@"f0f1f3"];
            [bgScroll addSubview:line_bg];
        }
        
        CGFloat aWidth = DEVICE_WIDTH / 4.f;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(aWidth * k, aY + 45 * line, aWidth, 45);
        [btn setTitleColor:[UIColor colorWithHexString:@"6a7180"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithHexString:@"f0f1f3"];
        btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_13];
        [btn addTarget:self action:@selector(clickToSubClassifyBBS:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [bgScroll addSubview:btn];
        
        if ((i + 1) % 4 != 0) {
            UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(btn.width - 1, 7.5, 0.5, 30)];
            hLineView.backgroundColor = [UIColor colorWithHexString:@"d8d9db"];
            [btn addSubview:hLineView];
        }else
        {
            UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom - 1, DEVICE_WIDTH, 0.5)];
            hLineView.backgroundColor = [UIColor colorWithHexString:@"bbbec3"];
            [bgScroll addSubview:hLineView];
        }
        
    }
    
    bgScroll.contentSize = CGSizeMake(DEVICE_WIDTH, [bgScroll viewWithTag:(array.count + 1000 - 1)].bottom);
}

#pragma mark - delegate

#pragma - mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clickToSearch:nil];
    return NO;
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4) {
        
        return 16;
        
    }else if (indexPath.row == 1 || indexPath.row == 5)
    {
        return 40;
    }
    return 75;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
}


@end
