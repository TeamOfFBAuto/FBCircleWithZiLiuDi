//
//  SMSInvitationViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SMSInvitationViewController.h"
#import "FriendAttribute.h"//cell的model
#import "FbSMSIVCell.h"


@interface SMSInvitationViewController (){

}

@end

@implementation SMSInvitationViewController

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
    self.titleLabel.text=@"通过短信邀请";

    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.view.backgroundColor=[UIColor whiteColor];

    _arraySelect=[NSMutableArray array];
    //1
    _mainTabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-60-64)];
    [self.view addSubview:_mainTabV];
    _mainTabV.delegate=self;
    _mainTabV.separatorColor=RGBCOLOR(225, 225, 225);
    _mainTabV.dataSource=self;

    //2
    _bigNextButton=[[UIButton alloc]initWithFrame:CGRectMake(10, _mainTabV.frame.size.height+7, DEVICE_WIDTH - 20, 44)];
    [self.view addSubview:_bigNextButton];
    //    _bigNextButton.backgroundColor=[UIColor blueColor];
    [_bigNextButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    [_bigNextButton setBackgroundImage:[UIImage imageNamed:@"xiayibu-kedian-up-568_88.png"] forState:UIControlStateNormal];
    [_bigNextButton addTarget:self action:@selector(commitBiaodan) forControlEvents:UIControlEventTouchUpInside];

    
    
  
    
	// Do any additional setup after loading the view.
    __weak typeof(self) _weakself=self;
    __weak typeof(_mainTabV) _weakmaintabv=_mainTabV;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_weakself testwhat];
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
            
            [_weakmaintabv reloadData];
                           
        });
        
    });
    
}


#pragma mark---处理测试数据

-(void)testwhat{
   
    _selectindexes=[NSMutableArray array];
    
    arrayOfCharacters=[NSMutableArray array];
    
    for (char c='A'; c<'Z'; c++) {
        [arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
    }
    [arrayOfCharacters addObject:[NSString stringWithFormat:@"%@",@"#"]];
    
    arrayname=[NSMutableArray array];
    NSMutableArray *AddressbookArr   = [SzkAPI AccesstoAddressBookAndGetDetail];
    
    
    NSLog(@"WWWWWWW====%@",AddressbookArr);
    for (NSDictionary *dicinfo in AddressbookArr) {
        
        FriendAttribute *_model=[[FriendAttribute alloc]init];
        [_model setFriendAttributeDic:dicinfo];
        
        [arrayname addObject:_model];
    }
    
    
    NSLog(@"arrarname===%@",arrayname);
    
    arrayinfoaddress=[NSArray array];
    
    arrayinfoaddress=[SzkAPI exChangeFriendListByOrder:arrayname];
    
    
    
    NSLog(@"arrayinfo===%@",arrayinfoaddress);
    
    
}

#pragma mark--tableviewdelegateAndDatesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
        return 27;
        
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        NSInteger count=[[arrayinfoaddress objectAtIndex:section] count];
        return count;
        
      
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *stridentifier=@"identifier";
    
    
    
    FbSMSIVCell *cell=[tableView dequeueReusableCellWithIdentifier:stridentifier];
    
    if (!cell) {
        
        
        NSLog(@"khjasfhk===%ld row===%ld",(long)indexPath.section,(long)indexPath.row);
        cell=[[FbSMSIVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stridentifier];
    }
 
    
    FriendAttribute *_model=[[arrayinfoaddress objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
//    __weak typeof(self) _weak_self=self;
    [cell setNameStr:_model.fbuname row:indexPath.row FriendAttributes:_model  fbsmsbloc:^(NSInteger therow, BOOL theisSelect, FriendAttribute *_theFbSMSIVCellModel) {
      // [_weak_self giveMetheBool:theisSelect andnodel:_theFbSMSIVCellModel];

        
      }];
  //  cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectimV.image=[UIImage imageNamed:@"jieshoukuang-38_38.png"];

    for (NSIndexPath *ip in self.selectindexes) {
        if (ip.row == indexPath.row && ip.section == indexPath.section) {
            
            
            cell.selectimV.image=[UIImage imageNamed:@"jieshoukuang-duihao38_38.png"];

            break;
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
   FbSMSIVCell * cell2=(FbSMSIVCell *)cell;
    
    cell2.selectimV.image=[UIImage imageNamed:@"jieshoukuang-38_38.png"];

    FriendAttribute *_model=[[arrayinfoaddress objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    BOOL isHave = NO;
    for (NSIndexPath *ip in self.selectindexes) {
        if (ip.row == indexPath.row && ip.section == indexPath.section) {
            [self.selectindexes removeObject:ip];
            cell2.selectimV.image=[UIImage imageNamed:@"jieshoukuang-38_38.png"];
            [_arraySelect removeObject:_model];
            
            isHave = YES;
            break;
        }
    }
    
    if (!isHave) {
        [self.selectindexes addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        cell2.selectimV.image=[UIImage imageNamed:@"jieshoukuang-duihao38_38.png"];
        [_arraySelect addObject:_model];
    }
}



#pragma mark--处理选择的电话号码数据
-(void)giveMetheBool:(BOOL)thebool andnodel:(FriendAttribute*)_theFbSMSIVCellModels{
    
    if (!thebool) {
        
        
        //如果是这个就要删除其中的重复数据
        for (FriendAttribute *sstempModel in _arraySelect) {
            
            
            NSString *str_temp=[NSString stringWithFormat:@"%@",sstempModel.fbuname];
            if ([str_temp isEqualToString:_theFbSMSIVCellModels.fbuname]) {
                
                
                
                [_arraySelect removeObject:sstempModel];
                NSLog(@"asljflk===%@",_arraySelect);
                
                
                
            }
        }
        
    }else{
        
        //果断的加上
        [_arraySelect addObject:_theFbSMSIVCellModels];
        
    }
    

}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==_mainTabV) {
        NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
        for(char c = 'A';c<='Z';c++)
            [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
        return toBeReturned;
        
    }else{
        return nil;
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *aview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 25)];
    
        aview.backgroundColor=[UIColor whiteColor];
        
        UIView *lingV=[[UIView alloc]initWithFrame:CGRectMake(12, 24.5, DEVICE_WIDTH-24, 0.5)];
        lingV.backgroundColor=RGBCOLOR(225, 225, 225);
        [aview addSubview:lingV];
    
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, DEVICE_WIDTH-24, 24.5)];
        
        _label.text=[NSString stringWithFormat:@"   %c",'A'+(int)section];
        
        _label.backgroundColor=[UIColor grayColor];
        
        _label.backgroundColor=RGBCOLOR(250, 250, 250);
        
        [aview addSubview:_label];
      
    return aview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return [[arrayinfoaddress objectAtIndex:section] count]==0?0:25;
        
   }

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
        NSInteger count = 0;
        for(NSString *character in arrayOfCharacters)
        {
            if([character isEqualToString:title])
            {
                return count;
            }
            count ++;
        }
        return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}

#pragma mark--开始发短信

-(void)commitBiaodan{
    
    NSLog(@"%@",_arraySelect);
    
    NSMutableArray *arrtemp=[NSMutableArray array];
    
    for (FriendAttribute *_model in _arraySelect) {
        [arrtemp addObject:_model.telePhoneNumber];
        
    }
    
    [self sendSMS:[NSString stringWithFormat:@"你越野e族的朋友%@邀请你加入FB圈,https://quan.fb.cn/download",[SzkAPI getUsername]] recipientList:arrtemp];
  
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *    controller = [[MFMessageComposeViewController alloc] init] ;

    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self  dismissViewControllerAnimated:YES completion:NULL];
    
//    if (result == MessageComposeResultCancelled)
//        NSLog(@"Message cancelled");
//        else if (result == MessageComposeResultSent)
//            NSLog(@"Message sent") ;
//            else 
//                NSLog(@"Message failed") ;
                }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
