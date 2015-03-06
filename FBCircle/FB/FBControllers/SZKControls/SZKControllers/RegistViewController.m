//
//  RegistViewController.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "RegistViewController.h"
#import "FbRegistCell.h"
#import "MatchingAddressBookViewController.h"
@interface RegistViewController (){
    FbRegistCell *cell;
}

@end

@implementation RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.navigationController.navigationBarHidden=NO;
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  五个属性
     */
    
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    
    
    _userNameStr=[NSString string];
    _passWordStr=[NSString string];
    _phoneNumberStr=[NSString string];
    _vertificatinNumberStr=[NSString string];
    _emailStr=[NSString string];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _mmainTabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,44*5)];//一共五个cell
//    _mmainTabV.separatorColor=RGBCOLOR(211, 211, 211);
    
    _mmainTabV.separatorColor = [UIColor redColor];
    _mmainTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mmainTabV.dataSource=self;
    _mmainTabV.delegate=self;
    _mmainTabV.contentOffset=CGPointMake(0, 0);
    _mmainTabV.scrollEnabled=NO;
    _mmainTabV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _mmainTabV.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    [self.view addSubview:_mmainTabV];
    
    _imgArr=[NSArray arrayWithObjects:@"yonghuming-icon-32_30.png",@"mima-icon-30_34.png",@"youxiang-34-34.png",@"shouji-26_38.png",@"xinfeng36_24.png" ,nil];
    
    _placHolderTextArr=[NSArray arrayWithObjects:@"请输入您的用户名",@"请输入密码",@"请输入邮箱",@"请输入您的手机号",@"请输入验证码", nil];
    
    CGFloat aWidth = DEVICE_WIDTH - 320 + 250;
    
    _bigNextButton=[[UIButton alloc]initWithFrame:CGRectMake((DEVICE_WIDTH - aWidth)/2, 44*5+20,aWidth, 44)];
    [self.view addSubview:_bigNextButton];

    [_bigNextButton setTitle:@"提交" forState:UIControlStateNormal];
    [_bigNextButton setBackgroundImage:[UIImage imageNamed:@"xiayibu-kedian-up-568_88.png"] forState:UIControlStateNormal];
    [_bigNextButton addTarget:self action:@selector(commitBiaodan) forControlEvents:UIControlEventTouchUpInside];
    
    //下面的服务条款,不先要了
//    UIImageView *imgduihaoloV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accept38_38.png"]];
//    imgduihaoloV.center=CGPointMake(20, 380);
//    imgduihaoloV.backgroundColor=[UIColor redColor];
//    [self.view addSubview:imgduihaoloV];
    
//    UILabel *labelagree=[[UILabel alloc]initWithFrame:CGRectMake(50, 370, 200, 15)];
//    labelagree.text=@"我阅读并同意相关条款";
//    labelagree.textAlignment=NSTextAlignmentLeft;
//    labelagree.font=[UIFont systemFontOfSize:14];
//    labelagree.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:labelagree];
//    
//    
    
    
    
    
    
	// Do any additional setup after loading the view.
}

#pragma mark--tableviewDelegate&&Datesource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _placHolderTextArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"identifier";
    
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FbRegistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    __weak typeof(self) _weakself=self;

    __weak typeof(_mmainTabV)weaktabv=_mmainTabV;
    
    __weak typeof (_bigNextButton)weakbigbutton=_bigNextButton;
    
    
//    cell.imgLine.backgroundColor = RGBCOLOR(211, 211, 211);


    if (indexPath.row==3) {
        
        [cell setFbRegistCellType:FbRegistCellTypeofButton placeHolderText:[_placHolderTextArr objectAtIndex:indexPath.row] str_img:[_imgArr objectAtIndex:indexPath.row]  fbregistbloc:^(int tag, NSInteger indexpathofrow, NSString *stringtext) {
            weaktabv.frame=CGRectMake(0, 0, DEVICE_WIDTH,44*5);

            NSLog(@"phonenumber==%@",stringtext);
            if (tag==101) {
                //发送验证码的按钮
                
                [_weakself sendVertification];
                
            }
            
            [_weakself changewordwithstr:stringtext indexpathrow:indexpathofrow];
            
        } row:indexPath.row];
    }else if(indexPath.row==1) {
        
       [cell setFbRegistCellType:FbRegistCellTypePassWord placeHolderText:[_placHolderTextArr objectAtIndex:indexPath.row] str_img:[_imgArr objectAtIndex:indexPath.row]  fbregistbloc:^(int tag, NSInteger indexpathofrow, NSString *stringtext) {
            
            [_weakself changewordwithstr:stringtext indexpathrow:indexpathofrow];
           weaktabv.frame=CGRectMake(0, 0, DEVICE_WIDTH,44*5);
           weakbigbutton.frame=CGRectMake((DEVICE_WIDTH-250)/2, 44*5+20, 250, 44);
           weakbigbutton.backgroundColor = [UIColor orangeColor];
           
        } row:indexPath.row];
        
    }else{
        
        [cell setFbRegistCellType:FbRegistCellTypeNormal placeHolderText:[_placHolderTextArr objectAtIndex:indexPath.row] str_img:[_imgArr objectAtIndex:indexPath.row]  fbregistbloc:^(int tag, NSInteger indexpathofrow, NSString *stringtext) {
            
            [_weakself changewordwithstr:stringtext indexpathrow:indexpathofrow];
            if (indexpathofrow==4) {
//                weaktabv.frame=CGRectMake(0, -80, 320,44*5);
//                weakbigbutton.frame=CGRectMake((320-250)/2, 44*5-60, 250, 44);

            }else{
                weaktabv.frame=CGRectMake(0, 0, DEVICE_WIDTH,44*5);
                weakbigbutton.frame=CGRectMake((DEVICE_WIDTH-250)/2, 44*5+20, 250, 44);
                
                weakbigbutton.backgroundColor = [UIColor orangeColor];


            }
            
            
        } row:indexPath.row];

    }
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
    
}

#pragma mark--赋值

-(void)changewordwithstr:(NSString *)str indexpathrow:(NSInteger)rowww{
    
    
    switch (rowww) {
        case 0:
        {
            
            _userNameStr=str;
            
        }
            break;
        case 1:
        {
            _passWordStr=str;
            
        }
            break;
        case 2:
        {
            _emailStr=str;
        }
            
            break;
        case 3:
        {
            _phoneNumberStr=str;
        }
            
            break;
            
        case 4:
        {
            
            _vertificatinNumberStr=str;
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark--提交注册的东西

-(void)commitBiaodan{
    
    
    //    [cell.inputField resignFirstResponder];
    //    [cell sendtextfieldtext];
    /**
     *  #define REGISTAPI @"http://quan.fblife.com/index.php?c=interface&a=register&uname=%@&upass=%@&phone=%@&pcode=%@&email=%@&token=%@&fbtype=json"
     
     */
    
    _userNameStr=[_userNameStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _passWordStr=[_passWordStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _emailStr=[_emailStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _phoneNumberStr=[_phoneNumberStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _vertificatinNumberStr=[_vertificatinNumberStr  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    

    
    __weak typeof(self) weakself=self;
    SzkLoadData *_loadRegist=[[SzkLoadData alloc]init];
    UIAlertView *theAlertV;
    
    
    

    if (_userNameStr.length==0) {
        
          theAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertV show];
        return;
    }else if (_passWordStr.length==0){
        theAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertV show];
        return;

    }else if (_emailStr.length==0){
        theAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertV show];
        return;
        
    }
    else if (_phoneNumberStr.length==0){
        theAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertV show];
        return;
        
    }else if (_vertificatinNumberStr.length==0){
        theAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertV show];
        return;
        
    }
    
    
    
    
    [_loadRegist SeturlStr:[NSString stringWithFormat:REGISTAPI,[_userNameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_passWordStr,_phoneNumberStr,_vertificatinNumberStr,[_emailStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"token"] block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
        
        if (errcode==0) {
            
            /**
             *  {
             {
             authkey = "AzdQNF46A2QBNlU4VS4LdlslVSsOIgc0VSpQc19+AXQ=";
             avatar = "";
             isnew = 1;
             uid = 362517;
             }
             
             */
            [weakself dotheSuccessWitharray:arrayinfo];

            
            
            
            
            
        }else{
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }
        
        
    }];
    
    
    
    NSString *str_url=[NSString stringWithFormat:REGISTAPI,[_userNameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_passWordStr,_phoneNumberStr,_vertificatinNumberStr,[_emailStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"token"] ;
    
    NSLog(@"注册的接口为==%@",str_url);
    
    
    
}

#pragma mark-如果注册成功了，走这个方法

-(void)dotheSuccessWitharray:(NSArray *)theinfoArr{
    
    @try {
        NSLog(@"sxs%@",theinfoArr);
        NSDictionary *dic=[NSDictionary dictionary];
        dic=(NSDictionary *)theinfoArr;
        NSLog(@"dicofRegist===%@",dic);
        NSUserDefaults *standardUser=[NSUserDefaults standardUserDefaults];
        NSString *authkey=[NSString stringWithFormat:@"%@",[dic objectForKey:@"authkey"]];
        NSString *uid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        NSString *strname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        [standardUser setObject:authkey forKey:AUTHERKEY];
        [standardUser setObject:uid forKey:USERID];
        [standardUser setObject:strname forKey:USERNAME];

        
        [standardUser synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"successRegist" object:nil];
        
        [ self.navigationController popViewControllerAnimated:YES];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark--发送验证码

-(void)sendVertification{
    
    SzkLoadData *loaddata = [[SzkLoadData alloc]init];
    [loaddata SeturlStr:[NSString stringWithFormat:MSDSENDAPI,_phoneNumberStr] block:^(NSArray *arrayinfo, NSString *errorindo, int errcode) {
        if (errcode==0) {
            UIAlertView *_alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送验证码成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [_alertV show];
        }else{
            UIAlertView *_alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:errorindo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [_alertV show];
        
        }
        
    }];
    
    NSLog(@"phoneNumber====%@",_phoneNumberStr);
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"ss%f",scrollView.contentOffset.y);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
