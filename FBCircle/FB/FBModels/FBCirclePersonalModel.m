//
//  FBCirclePersonalModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirclePersonalModel.h"

@implementation FBCirclePersonalModel
@synthesize person_buddynum = _person_buddynum;
@synthesize person_city = _person_city;
@synthesize person_dateline = _person_dateline;
@synthesize person_email = _person_email;
@synthesize person_face = _person_face;
@synthesize person_frontpic = _person_frontpic;
@synthesize person_imagenum = _person_imagenum;
@synthesize person_password = _person_password;
@synthesize person_phone = _person_phone;
@synthesize person_province = _person_province;
@synthesize person_status = _person_status;
@synthesize person_token = _person_token;
@synthesize person_topicnum = _person_topicnum;
@synthesize person_uid = _person_uid;
@synthesize person_uptime = _person_uptime;
@synthesize person_username = _person_username;
@synthesize person_words = _person_words;
@synthesize person_gender = _person_gender;



-(FBCirclePersonalModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];

    if (self)
    {
        self.person_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        self.person_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        self.person_password = [NSString stringWithFormat:@"%@",[dic objectForKey:@"password"]];
        self.person_phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]];
        self.person_email = [NSString stringWithFormat:@"%@",[dic objectForKey:@"email"]];
        self.person_province = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
        self.person_city = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
        self.person_face = [NSString stringWithFormat:@"%@",[dic objectForKey:@"face"]];
        self.person_words = [NSString stringWithFormat:@"%@",[dic objectForKey:@"words"]];
        self.person_buddynum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buddynum"]];
        self.person_topicnum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"topicnum"]];
        self.person_imagenum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imagenum"]];
        self.person_frontpic = [NSString stringWithFormat:@"%@",[dic objectForKey:@"frontpic"]];
        self.person_token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
        self.person_status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        self.person_uptime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uptime"]];
        self.person_dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        self.person_gender = [NSString stringWithFormat:@"%@",[dic objectForKey:@"gender"]];
    }
    return self;
}



-(void)loadPersonWithUid:(NSString *)theUid WithBlock:(FBCirclePersonalModelCompletionBlock)theBlock WithFailedBlcok:(FBCirclePersonalModelFailedBlock)FailedBlock;
{
    personalModelCompletionBlock = theBlock;
    
    personalModelFailedBlock = FailedBlock;
    
    
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_PERSONAL_INFO_URL,theUid];
    
    NSLog(@"请求个人数据接口-----%@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * fbCircleRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = fbCircleRequest;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            NSArray * array = [allDic objectForKey:@"datainfo"];
            
            FBCirclePersonalModel * model = [[FBCirclePersonalModel alloc] initWithDictionary:[array objectAtIndex:0]];
            
            if (personalModelCompletionBlock) {
                personalModelCompletionBlock(model);
            }
        }else
        {
            
            
            
            if (personalModelFailedBlock) {
                personalModelFailedBlock([allDic objectForKey:@"errinfo"]);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (personalModelFailedBlock) {
            personalModelFailedBlock(@"获取个人信息失败，请检查您当前网络");
        }
    }];
    

    [fbCircleRequest start];
}




@end
















