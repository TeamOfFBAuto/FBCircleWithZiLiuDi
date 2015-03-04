//
//  CreateBBSChooseIconViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CreateBBSChooseIconViewController.h"
#import "CreateBBSChooseIconCell.h"

@interface CreateBBSChooseIconViewController ()
{
    ///记录上次选中的是哪个
    int currentSelectedPage;
    
    NSMutableArray * data_array;
}

@end

@implementation CreateBBSChooseIconViewController
@synthesize myTableView = _myTableView;
@synthesize delegate = _delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = @"选择图标";
    
    self.rightString = @"完成";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    
    data_array = [NSMutableArray array];
    
    for (int i = 0;i < 120;i++)
    {
        [data_array addObject:@"brid"];
    }
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = RGBCOLOR(240,241,243);
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}


#pragma mark - 右边点击方法--完成

-(void)submitData:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(completeChooseIconWithImageName:)])
    {
        [_delegate completeChooseIconWithImageName:[data_array objectAtIndex:currentSelectedPage]];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    CreateBBSChooseIconCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[CreateBBSChooseIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.contentView.backgroundColor = RGBCOLOR(240,241,243);
    
    cell.backgroundColor = RGBCOLOR(240,241,243);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0;i<6;i++)
    {
        int index = indexPath.row*6;
        [array addObject:[data_array objectAtIndex:index+i]];
    }
    
    __weak typeof(self)bself = self;
    [cell setAllImagesWithArray:array WithRow:indexPath.row WithSelectedIndex:currentSelectedPage WithBlock:^(int index) {
        [bself reloadTabWithIndexPath:indexPath WithIndex:index];
    }];
    
    return cell;
}

-(void)reloadTabWithIndexPath:(NSIndexPath *)indexPath WithIndex:(int)index
{
    currentSelectedPage = indexPath.row*6+index;
    [self.myTableView reloadData];
}


#pragma mark - dealloc

-(void)dealloc
{
    data_array = nil;
    
    _myTableView = nil;
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
