//
//  MessageModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


-(MessageModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.date_now = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date_now"]];
        
        self.from_message = [ZSNApi ddecodeSpecialCharactersStringWith:[NSString stringWithFormat:@"%@",[dic objectForKey:@"from_message"]]];
        
        self.from_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"from_uid"]];
        
        self.from_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"from_username"]];
        
        self.fromunread = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fromunread"]];
        
        self.idtype = [NSString stringWithFormat:@"%@",[dic objectForKey:@"idtype"]];
        
        self.is_del = [NSString stringWithFormat:@"%@",[dic objectForKey:@"is_del"]];
        
        self.to_message = [ZSNApi ddecodeSpecialCharactersStringWith:[NSString stringWithFormat:@"%@",[dic objectForKey:@"to_message"]]];
        
        self.to_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"to_uid"]];
        
        self.to_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"to_username"]];
        
        self.tounread = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tounread"]];
        
        self.zt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zt"]];
        
        self.news_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"new_id"]];
        
//        NSString *string_myuid=[NSString stringWithFormat:@"%@",@"967897"];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERID] isEqualToString:self.from_uid]) {
            self.othername=self.to_username;
        }else{
            self.othername=self.from_username;
        }
        
//        NSString *string_uid=[NSString stringWithFormat:@"%@",@"967897"];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERID] isEqualToString:self.from_uid]) {
            self.selfunread=self.fromunread;
            self.otheruid=self.to_uid;
            
        }else{
            self.selfunread=self.tounread;
            self.otheruid=self.from_uid;
        }
    }
    
    return self;
}



-(void)loadInfomationWithBlock:(MessageModelBlock)theBlock
{
    NSString * url = [NSString stringWithFormat:MESSAGE_LIST_URL,[SzkAPI getAuthkeyGBK]];
    
    NSLog(@"私信首页接口-----%@",url);
    
    messageModelBlock = theBlock;
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = requestOperation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        @try {
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
            
            NSLog(@"私信首页-----%@",allDic);
            
            NSDictionary * infoDic = [allDic objectForKey:@"info"];
            
            if ([infoDic count] != 0) {
                
                NSMutableArray * tempArray = [NSMutableArray array];
                
                for (NSDictionary * dic in infoDic) {
                    MessageModel * model = [[MessageModel alloc] initWithDictionary:dic];
                    
                    [tempArray addObject:model];
                }
            
                if (messageModelBlock) {
                    messageModelBlock(tempArray);
                }
                
            }else
            {
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (messageModelBlock) {
            messageModelBlock([NSMutableArray array]);
        }
    }];
    
    [requestOperation start];
}




-(void)dealloc
{
    [requestOperation cancel];
    
    requestOperation = nil;
}



@end

























