//
//  MatchingAddressBookViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MatchingAddressBookViewController.h"



@interface MatchingAddressBookViewController (){

    NSString *str_phonenumber;
    NSString *str_name;
    


}

@end

@implementation MatchingAddressBookViewController

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
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    self.titleLabel.text=self.str_title;
    
    _arrayInfo=[NSMutableArray array];
    
    __weak typeof(self) _weakself=self;
    __weak typeof(_mainTabV) _weakmaintabv=_mainTabV;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        [_weakself getDataFromDocument];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [_weakmaintabv reloadData];
            
            
            [_weakself dotheMatchingAndPostAddressBook];
            
            
        });
        
    });

    
    
   // [self dotheMatchingAndPostAddressBook];
 
    
//    [self matchingPostWithnumber:@"" strname:@""];

    
	// Do any additional setup after loading the view.
}


#pragma mark--获取通讯录后传上去

-(void)dotheMatchingAndPostAddressBook{

    __weak typeof(self) _weakself=self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_weakself changAddressBook];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //  [_weakself matchingAddressBookWithstrnumber:str_phonenumber strname:[str_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [_weakself matchingPostWithnumber:str_phonenumber strname:str_name];
            
        });
        
    });

}

-(void)loadView{
    
    [super loadView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //1
    _mainTabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    [self.view addSubview:_mainTabV];
    _mainTabV.delegate=self;
    _mainTabV.separatorColor=RGBCOLOR(225, 225, 225);
    _mainTabV.dataSource=self;
    //
    
    
    _theFbquanalertV=[[FBQuanAlertView alloc]initWithFrame:CGRectMake(0, 0, 140, 100)];
    _theFbquanalertV.center=CGPointMake(DEVICE_WIDTH/2.f, DEVICE_HEIGHT/2.f);
    [_theFbquanalertV setType:FBQuanAlertViewTypeHaveJuhua thetext:@"正在加载通讯录，请稍后..."];
    _theFbquanalertV.hidden=YES;
    [self.view addSubview:_theFbquanalertV];
    

    
    

    
 }
#pragma mark--加载缓存里面的通讯录

-(void)getDataFromDocument{
    
    NSUserDefaults *StadU=[NSUserDefaults standardUserDefaults];
    NSArray *thearray=[NSArray array];
    thearray=[StadU objectForKey:@"ADDRESSBOOKARRAY"];
    [self DealDocumentArray:thearray];
    
 }


#pragma mark--将通讯录放到一个数组里面

-(void)changAddressBook{

    str_phonenumber=[NSString string];
    str_name=[NSString string];

    NSMutableArray *AddressbookArr   = [SzkAPI AccesstoAddressBookAndGetDetail];
    
//    for (NSDictionary *dicinfo in AddressbookArr) {
//        
//        FriendAttribute *_model=[[FriendAttribute alloc]init];
//        [_model setFriendAttributeDic:dicinfo];
//        str_phonenumber=[NSString stringWithFormat:@"%@,%@",str_phonenumber,_model.telePhoneNumber];
//        str_name=[NSString stringWithFormat:@"%@,%@",str_name,_model.fbuname];
//
//    }
//    
    for (int i=0; i<AddressbookArr.count; i++) {
        NSDictionary *dicinfo=[AddressbookArr objectAtIndex:i];
        FriendAttribute *_model=[[FriendAttribute alloc]init];
        [_model setFriendAttributeDic:dicinfo];
        NSString *str_nameeee=[NSString stringWithFormat:@"%@",_model.fbuname];
        
        if (str_nameeee.length==0||[str_nameeee isEqualToString:@"(null)"]) {
            str_nameeee=@"noresault";
        }
        
        
        if (i==0) {
            str_phonenumber=[NSString stringWithFormat:@"%@",_model.telePhoneNumber];
            str_name=[NSString stringWithFormat:@"%@",str_nameeee];
        }else{
            str_phonenumber=[NSString stringWithFormat:@"%@,%@",str_phonenumber,_model.telePhoneNumber];
            str_name=[NSString stringWithFormat:@"%@,%@",str_name,str_nameeee];

        }
    
    }

}


#pragma mark-将联系人上传，获取到匹配消息

-(void)matchingAddressBookWithstrnumber:(NSString *)thenumber strname:(NSString *)thename{
    /**
     http://quan.fblife.com/index.php?c=interface&a=getphonemember&authkey=UGQBZgNgB2MDPFA8AnkKZFIgUSwPMVVpB2VTcVprAG9SPQ==&phone=18601901680,15552499996&rname=etsfs,sdfafa

     */
    __weak typeof(self) _weaself=self;
    
    SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
    
    NSString *str_url=[NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=getphonemember&authkey=%@==&phone=%@&rname=%@",[SzkAPI getAuthkey],thenumber,thename];
    
    [_loadRegist SeturlStr:str_url block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
        
        
        NSLog(@"errinfo==%@===code==%d===indo===%@",errorindo,errcode,arrayinfo);
        if (errcode==0) {
            
            [_weaself changeArrtoModel:arrayinfo];
            
        }
    }];
    
    NSLog(@"匹配通讯录的接口为==%@",str_url);
    
}

#pragma mark--使用post发送匹配通讯录的请求

-(void)matchingPostWithnumber:(NSString *)thenumber strname:(NSString *)thename{
    
    if (_arrayInfo.count==0) {
        _theFbquanalertV.hidden=NO;

    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=getphonemember&authkey=%@" ,[SzkAPI getAuthkey]]]];
        //    [request setPostValue:@"UGQBZgNgB2MDPFA8AnkKZFIgUSwPMVVpB2VTcVprAG9SPQ==" forKey:@"authkey"];
        [request setPostValue:thenumber forKey:@"phone"];
        [request setPostValue:thename forKey:@"rname"];
        [request setTimeOutSeconds:200];
        [request setDidFailSelector:@selector(testfailed:)];
        [request setDidFinishSelector:@selector(testfinished:)];
        request.delegate=self;
        [request startAsynchronous];
        
        
//    }) ;
    
}
-(void)testfailed:(ASIHTTPRequest*)request{

    UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:nil message:@"提示" delegate:nil cancelButtonTitle:@"通讯录匹配失败" otherButtonTitles:nil, nil];
    [alertV show];
    
    
    
}

-(void)testfinished:(ASIHTTPRequest*)reques{
    _theFbquanalertV.hidden=YES;

    
    NSData *data=[reques responseData];
    

    NSDictionary *dic=[data objectFromJSONData];
    
    
    
    
    
    NSLog(@"zzzzdic===%@",dic);
    
    
    
    
    NSArray *arrayinfo=[dic objectForKey:@"datainfo"];
    
    
    NSUserDefaults *standUser=[NSUserDefaults standardUserDefaults];
    [standUser setObject:arrayinfo forKey:@"ADDRESSBOOKARRAY"];
    [standUser synchronize];
    
    
    
    
    if (arrayinfo.count>0) {
        [self changeArrtoModel:arrayinfo];
    }
    
    
//    UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:nil message:[[[dic objectForKey:@"datainfo"] objectAtIndex:0] objectForKey:@"rname"] delegate:nil cancelButtonTitle:@"s" otherButtonTitles:nil, nil];
//    [alertV show];
//
    
}



-(void)changeArrtoModel:(NSArray *)theArr{
    
    [_arrayInfo removeAllObjects];
    
    for (NSDictionary *dic in theArr) {
        
        
        
        NSLog(@"dic-===%@",dic);
        FriendAttribute *_model=[[FriendAttribute alloc]init];
        
        [_model setFriendAttributeDic:dic];
        [_arrayInfo addObject:_model];
        
    }
    
    
    
    NSLog(@"_arrinfo=%@_",_arrayInfo);
    [_mainTabV reloadData];
    
    
    
}
#pragma mark-把数组放到缓存里面

-(void)DealDocumentArray:(NSArray*)_array{
    [_arrayInfo removeAllObjects];
    
    for (NSDictionary *dic in _array) {
        
        
        
        NSLog(@"dic-===%@",dic);
        FriendAttribute *_model=[[FriendAttribute alloc]init];
        
        [_model setFriendAttributeDic:dic];
        [_arrayInfo addObject:_model];
        
    }
    
    
    
    NSLog(@"缓存的数据=%@_",_arrayInfo);

}

#pragma mark--tableviewdelegateAndDatesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayInfo.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *stridentifier=@"identifier";
    
    SuggestFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:stridentifier];
    
    if (!cell) {
        
        cell=[[SuggestFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stridentifier];
    }
    FriendAttribute *_model=[_arrayInfo objectAtIndex:indexPath.row];
    
    NSLog(@"%@===%@",_model.rname,_model.username);
    
    __weak typeof(self)_weakself=self;
    
    [cell setindexpathrow:indexPath.row suggestmodel:_model mybloc:^(FriendAttribute *suggestmodel,int tag) {
        
        [_weakself doActionofriendatt:suggestmodel Three:tag theindexpathrow:indexPath.row];
        
    }];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 71;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark--处理动作，101，接受，2添加，3，邀请4，验证中，5，已添加

-(void)doActionofriendatt:(FriendAttribute *)thefriendmodel  Three:(int)thetag theindexpathrow:(NSInteger )_indexpathrow{
//    __weak typeof(self) _weakself=self;

    switch (thetag) {
        case 101:
        {
            /**
             *  这个是直接刷新cell
             */
            FriendAttribute *_model=[_arrayInfo objectAtIndex:_indexpathrow];
            _model.optype=[NSString stringWithFormat:@"5"];
            
            [_arrayInfo replaceObjectAtIndex:_indexpathrow withObject:_model];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_indexpathrow inSection:0];
            [_mainTabV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];



            
            SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
            NSString *str_url=[NSString stringWithFormat:ACCEPTAPI,[SzkAPI getAuthkey],thefriendmodel.uid];
            
            [_loadRegist SeturlStr:str_url block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
                
                NSLog(@"errinfo==%@===code==%d===indo===%@",errorindo,errcode,arrayinfo);
                if (errcode==0) {
                    
                     //  [_weakself dotheMatchingAndPostAddressBook];
                    //接受成功，通知到
                    [[NSNotificationCenter defaultCenter] postNotificationName:GETFRIENDLIST object:nil];
                
                }
            }];
            
            NSLog(@"接受的接口==%@",str_url);
            
        }
            break;
        case 102:
        {
            FriendAttribute *_model=[_arrayInfo objectAtIndex:_indexpathrow];
            _model.optype=[NSString stringWithFormat:@"4"];
            
            [_arrayInfo replaceObjectAtIndex:_indexpathrow withObject:_model];
            
          
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_indexpathrow inSection:0];
            [_mainTabV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            
            SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
            NSString *str_url=[NSString stringWithFormat:ADDFRIENDAPI,[SzkAPI getAuthkey],thefriendmodel.uid,thefriendmodel.username];
            
            [_loadRegist SeturlStr:str_url block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
                
                
                NSLog(@"errinfo==%@===code==%d===indo===%@",errorindo,errcode,arrayinfo);
                if (errcode==0) {
                    
               
                    
                }else{
                
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                
                
                }
            }];
            
            NSLog(@"添加的接口==%@",str_url);
            
        }
            break;
        case 103:
        {
            
            NSLog(@"kongde???%@",thefriendmodel.telePhoneNumber);
            
            [self commitBiaodanWithphoneNumber:thefriendmodel.telphone];
            NSLog(@"邀请");
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark--开始发短信

-(void)commitBiaodanWithphoneNumber:(NSString *)thephonenumber{
    NSLog(@"xx%s",__FUNCTION__);
    /**
     *      [self sendSMS:@"我在FB圈 发现了巨多玩车牛人，吃喝腐败自驾游，还有福利可以共享，上来找我一起玩车吧,https://itunes.apple.com/us/app/yue-yee-zu/id605673005?l=zh&ls=1&mt=8" recipientList:arrtemp];

     */
    
    [self sendSMS:[NSString stringWithFormat:@"你越野e族的朋友%@邀请你加入FB圈,https://quan.fb.cn/download",[SzkAPI getUsername]] sr_number:thephonenumber];
    
}
- (void)sendSMS:(NSString *)bodyOfMessage sr_number:(NSString *)thestrphoneNumber
{
    MFMessageComposeViewController *    controller = [[MFMessageComposeViewController alloc] init] ;
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;
        
        NSLog(@"alskfjll==%@",thestrphoneNumber);

        if (thestrphoneNumber.length==0) {
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该号码为空，请尝试其他号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertV show];
            return;
        }
        
        controller.recipients = [NSArray arrayWithObject:thestrphoneNumber];
        
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
//    else if (result == MessageComposeResultSent)
//        NSLog(@"Message sent") ;
//    else
//        NSLog(@"Message failed") ;
}


-(void)dealloc{

    
    [request cancel];
    request.delegate=nil;
    request=nil;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
