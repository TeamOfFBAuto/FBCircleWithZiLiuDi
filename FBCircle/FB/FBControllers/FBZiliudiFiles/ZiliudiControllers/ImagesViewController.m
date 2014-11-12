//
//  ImagesViewController.m
//  FbLife
//
//  Created by soulnear on 13-3-25.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import "ImagesViewController.h"
#import "ShowImagesViewController.h"

@interface ImagesViewController ()
{
    NSString * _name;
    ///根据屏幕尺寸获得图片大小
    float imageW;
}

@end

@implementation ImagesViewController
@synthesize myTableView = _myTableView;
@synthesize dataArray = _dataArray;
@synthesize photos = _photos;
@synthesize tid = _tid;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backH
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(void)initHttpRequest
{
    
    
    NSString *authkey=[[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD];
    NSString* fullURL = [NSString stringWithFormat:URL_HUALANG,authkey,self.tid];
    NSLog(@"请求的url -=-=  %@",fullURL);
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fullURL]];
    __block ASIHTTPRequest * _requset = request;
    request.delegate = self;
    
    MBProgressHUD * hud = [ZSNApi showMBProgressWithText:@"正在加载..." addToView:self.view];
    
    [request setFailedBlock:^{
        
    }];
    
    
    [request setCompletionBlock:^{
        @try {
            [hud hide:YES];
            NSDictionary * dictionary = [_requset.responseData objectFromJSONData];
            NSLog(@"图片信息 -=-=-  %@",dictionary);
            NSString *errcode = [dictionary objectForKey:@"errcode"];
            if ([@"0" isEqualToString:errcode])
            {
                NSDictionary* albuminfo = [dictionary objectForKey:@"albuminfo"];
                
                NSDictionary* albuminfo2 = [albuminfo objectForKey:@"albuminfo"];
                
                _name= [albuminfo2 objectForKey:@"name"];
                
                NSArray* userinfo = [albuminfo objectForKey:@"picinfo"];
                
                if ([userinfo isEqual:[NSNull null]])
                {
                    //如果没有微博的话
                    NSLog(@"------------本画廊没有图片---------------");
                }else
                {
                    NSInteger count = [userinfo count];
                    for(int i = 0;i<count;i++)
                    {
                        if([userinfo objectAtIndex:i])
                        {
                            [self.photos addObject:[[userinfo objectAtIndex:i] objectForKey:@"bigphoto"]];//大图
                            [self.dataArray addObject:[[userinfo objectAtIndex:i] objectForKey:@"photo"]];//小图
                        }
                    }
                    [_myTableView reloadData];
                    //                NavTitle.title = _name;
                    self.title = _name;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request startAsynchronous];
}



-(void)backto
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageW = (DEVICE_WIDTH-360)>0?90:76;
    
    self.view.backgroundColor = RGBCOLOR(242,242,242);
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.photos = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    
    [self initHttpRequest];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = (DEVICE_WIDTH-imageW*4)/5+imageW;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = RGBCOLOR(242,242,242);
    [self.view addSubview:_myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = self.dataArray.count%4?self.dataArray.count/4+1:self.dataArray.count/4;
    return num;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    
    ImagesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[ImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.delegate = self;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell setAllView];
    
    
    if (indexPath.row*4 < self.dataArray.count)
    {
        [cell.imageView1 loadImageFromURL:[self.dataArray objectAtIndex:indexPath.row*4] withPlaceholdImage:[ZSNApi getImageWithName:@"photo_default"]];
    }
    
    if (indexPath.row*4+1 < self.dataArray.count)
    {
        [cell.imageView2 loadImageFromURL:[self.dataArray objectAtIndex:indexPath.row*4+1] withPlaceholdImage:[ZSNApi getImageWithName:@"photo_default"]];
    }
    
    if (indexPath.row*4+2 < self.dataArray.count)
    {
        [cell.imageView3 loadImageFromURL:[self.dataArray objectAtIndex:indexPath.row*4+2] withPlaceholdImage:[ZSNApi getImageWithName:@"photo_default"]];
    }
    
    if (indexPath.row*4+3 < self.dataArray.count)
    {
        [cell.imageView4 loadImageFromURL:[self.dataArray objectAtIndex:indexPath.row*4+3] withPlaceholdImage:[ZSNApi getImageWithName:@"photo_default"]];
    }
    return cell;
}

-(void)showDetailImage:(UITableViewCell *)cell imageTag:(int)image
{
    NSIndexPath * indexPath = [_myTableView indexPathForCell:cell];
    int num = indexPath.row*4+image-1;
    ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
    showBigVC.allImagesUrlArray=_photos;
    showBigVC.currentPage = num;
    [self PushToViewController:showBigVC WithAnimation:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end










