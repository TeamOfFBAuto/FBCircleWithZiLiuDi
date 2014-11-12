//
//  GmyErweimaViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GmyErweimaViewController.h"
#import "GmPrepareNetData.h"//网络请求类



@interface GmyErweimaViewController ()

@end

@implementation GmyErweimaViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = RGBCOLOR(246, 247, 249);
    
    self.titleLabel.text = @"我的二维码";
    
    //底层view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(20, iPhone5?57:15, 320-40, 384)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    //头像view
    self.userFaceImv= [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 64, 64)];
    [backView addSubview:self.userFaceImv];
    
    
    //名字
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+11, CGRectGetMinY(self.userFaceImv.frame)+9, 170, 17)];
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.userNameLabel.textColor = [UIColor blackColor];
    [backView addSubview:self.userNameLabel];
    
    //地区
    self.userDiquLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+11, 170, 12)];
    self.userDiquLabel.font = [UIFont systemFontOfSize:11];
    self.userDiquLabel.textColor = RGBCOLOR(102, 102, 102);
    [backView addSubview:self.userDiquLabel];
    
    
    
    //二维码图片
    self.erweimaImageV= [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userFaceImv.frame)+16, CGRectGetMaxY(self.userFaceImv.frame)+33, 200, 200)];
    self.erweimaImageV.backgroundColor = [UIColor grayColor];
    [backView addSubview:self.erweimaImageV];
    
    //文字描述
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(self.erweimaImageV.frame)+35, 180, 13)];
    tishiLabel.font = [UIFont systemFontOfSize:10.5];
    tishiLabel.textColor = RGBCOLOR(148, 148, 148);
    tishiLabel.text = @"扫一扫上面的二维码图案，加我为好友";
    [backView addSubview:tishiLabel];
    
    
    
    
    
    [self erweimaNetData];
    [self userInfoNetData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)erweimaNetData{
    NSString *api = [NSString stringWithFormat:FBFOUND_MYERWEIMA,[SzkAPI getUid]];
    NSLog(@"%@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *str = [dataDic objectForKey:@"codesrc"];
            [self.erweimaImageV sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.erweimaImageV setImage:image];
            }];
        }
       
    }];
    
}


//请求用户信息
-(void)userInfoNetData{
    //请求用户信息
    self.personModel = [[FBCirclePersonalModel alloc]init];
    
    __weak typeof (self)bself =self;
    [self.personModel loadPersonWithUid:[SzkAPI getUid] WithBlock:^(FBCirclePersonalModel *model) {
        bself.personModel = model;
        
        NSLog(@"%@",model.person_face);
        [bself.userFaceImv sd_setImageWithURL:[NSURL URLWithString:model.person_face] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        bself.userNameLabel.text = model.person_username;
        
        bself.userDiquLabel.text = [NSString stringWithFormat:@"%@%@",model.person_province,model.person_city];
    
    } WithFailedBlcok:^(NSString *string) {
        
    }];
}

@end
