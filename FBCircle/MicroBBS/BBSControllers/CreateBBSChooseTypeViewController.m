//
//  CreateBBSChooseTypeViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CreateBBSChooseTypeViewController.h"

@interface CreateBBSChooseTypeViewController ()
{
    int currentPage;///当前选中的类型
}

@end

@implementation CreateBBSChooseTypeViewController
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;
@synthesize name_Label = _name_Label;
@synthesize icon_num = _icon_num;


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
    
    self.titleLabel.text = @"微论坛分类";
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    _data_array = [NSMutableArray array];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)-64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(185,190,207);
    _myTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_myTableView];
    
    
    [self getBBSClass];
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
        if ([dataInfo isKindOfClass:[NSDictionary class]])
        {
                NSArray *tuijian = [dataInfo objectForKey:@"tuijian"];
                NSArray *normal = [dataInfo objectForKey:@"nomal"];
                
                for (NSDictionary *aDic in tuijian) {
                    
                    [weakSelf.data_array addObject:[[BBSModel alloc]initWithDictionary:aDic]];
                }
                
                for (NSDictionary *aDic in normal) {
                    
                    [weakSelf.data_array addObject:[[BBSModel alloc]initWithDictionary:aDic]];
                }
                [weakSelf.myTableView reloadData];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        [ZSNApi showAutoHiddenMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
    }];
}

#pragma mark - 完成时的回调
-(void)chooseTypeBlock:(CreateBBSChooseTypeBlock)theType
{
    chooseType_block = theType;
}

#pragma mark - 完成

-(void)submitData:(UIButton *)sender
{
    if (chooseType_block)
    {
        chooseType_block([_data_array objectAtIndex:currentPage]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BBSModel * model = [_data_array objectAtIndex:indexPath.row];
    
    if (currentPage == indexPath.row)
    {
        _name_Label.text = model.classname;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.textColor = RGBCOLOR(139,146,156);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = model.classname;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == currentPage) {
        return;
    }
    
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell * last_cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    last_cell.accessoryType = UITableViewCellAccessoryNone;
    
    currentPage = indexPath.row;
}


-(void)dealloc
{
    _name_Label = nil;
    _data_array = nil;
    
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


























