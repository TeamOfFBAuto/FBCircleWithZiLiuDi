//
//  ChooseCountryViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ChooseCountryViewController.h"

@interface ChooseCountryViewController ()

@end

@implementation ChooseCountryViewController
@synthesize myTableView = _myTableView;
@synthesize dataArray = _dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)loadCityData
{
    
    __weak typeof(self) bself = self;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.dataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [bself.myTableView reloadData];
        });
    });
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCityData];
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)) style:UITableViewStylePlain];
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];
}


#pragma mark-UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"country"]];
    
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"states"] count] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCitiesViewController * chooseCities = [[ChooseCitiesViewController alloc] init];
    
    chooseCities.myCountry = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"country"]];
    
    chooseCities.myCities = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"states"];
    
    [self.navigationController pushViewController:chooseCities animated:YES];
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
