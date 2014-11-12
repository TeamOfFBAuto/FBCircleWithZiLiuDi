//
//  ChatModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
@synthesize msg_id = _msg_id;
@synthesize from_uid = _from_uid;
@synthesize to_uid = _to_uid;
@synthesize fuid_tuid = _fuid_tuid;
@synthesize date_now = _date_now;
@synthesize is_del = _is_del;
@synthesize from_username = _from_username;
@synthesize to_username = _to_username;
@synthesize zt = _zt;
@synthesize msg_message = _msg_message;

@synthesize data_array = _data_array;



-(ChatModel *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.msg_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_id"]];
        
        self.from_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"from_uid"]];
        
        self.to_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"to_uid"]];
        
        self.fuid_tuid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fuid_tuid"]];
        
        self.date_now = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date_now"]];
        
        
        self.from_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"from_username"]];
        
        self.to_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"to_username"]];
        
        self.zt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zt"]];
        
        self.is_del = [NSString stringWithFormat:@"%@",[dic objectForKey:@"is_del"]];
        
        self.msg_message = [ZSNApi ddecodeSpecialCharactersStringWith:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_message"]]];
    }
    
    return self;
    
}



-(void)initHttpWithPage:(int)page WithMaxId:(NSString *)maxId WithToUid:(NSString *)toUid WithBlock:(ChatModelBlock)theBlock;
{
    chatModelBlock = theBlock;
    
    NSString * fullUrl = [NSString stringWithFormat:MESSAGE_CHAT_URL,toUid,maxId,page,[SzkAPI getAuthkeyGBK]];
    
    NSLog(@"对话界面接口-----%@",fullUrl);
    
    NSURLRequest * URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    chatRequest = [[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
    
    __block AFHTTPRequestOperation * request = chatRequest;
    
    __weak typeof(self) bself = self;
    
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
                        
            if (!bself.data_array) {
                bself.data_array = [NSMutableArray array];
            }else
            {
                if (page ==1) {
                    [bself.data_array removeAllObjects];
                }
            }
            
            int allCount = [[allDic objectForKey:@"number"] intValue];
            
            NSArray * array = [allDic objectForKey:@"info"];
            
            for (NSDictionary * dic in array)
            {
                ChatModel * model = [[ChatModel alloc] initWithDic:dic];
                
                [bself.data_array insertObject:model atIndex:0];
            }
            
            
            if (chatModelBlock) {
                chatModelBlock(bself.data_array,allCount);
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    [chatRequest start];
}




-(void)sendMessageWith:(ChatModel *)model WithCompletionBlock:(SendMessageCompletionBlock)theCompletionBlock WithFaildBlock:(SendMessageFailBlock)theFaildBlock
{
    sendMessageFaildBlock = theFaildBlock;
    sendMessageCompletionBlock = theCompletionBlock;
    
//    NSString * fullUrl = [NSString stringWithFormat:MESSAGE_CHAT_SEND_MESSAGE_URL,[model.to_username stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding],[[model.msg_message stringByReplacingEmojiUnicodeWithCheatCodes]stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding],[[NSUserDefaults standardUserDefaults] objectForKey:@"autherkey"]];
    
    
    NSString * fullUrl = @"http://msg.fblife.com/api.php?c=send&isfbring=1";
    
    NSLog(@"发送消息接口---%@",fullUrl);
    
    sendRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    [sendRequest setPostValue:model.to_uid forKey:@"touid"];
    [sendRequest setPostValue:model.msg_message forKey:@"content"];
    [sendRequest setPostValue:[SzkAPI getAuthkeyGBK] forKey:@"authcode"];
    
    __weak typeof(sendRequest)wrequest = sendRequest;
    
    [wrequest setCompletionBlock:^{
        
        @try {
            NSDictionary * allDic = [sendRequest.responseString objectFromJSONString];
            
            NSLog(@"发送消息----%@",allDic);
            
            if ([[allDic objectForKey:@"errcode"] intValue]==0)
            {
                if (sendMessageCompletionBlock) {
                    sendMessageCompletionBlock(sendRequest);
                }
            }else
            {
                if (sendMessageFaildBlock) {
                    sendMessageFaildBlock(sendRequest,[allDic objectForKey:@"bbsinfo"]);
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
    }];
    
    [wrequest setFailedBlock:^{
        if (sendMessageFaildBlock) {
            sendMessageFaildBlock(sendRequest,@"发送失败，请检查当前网络");
        }
    }];
    
    [sendRequest startAsynchronous];
    
    
    /*
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    sendRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    __block AFHTTPRequestOperation * request = sendRequest;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSLog(@"发送消息----%@",allDic);
        
        if ([[allDic objectForKey:@"errcode"] intValue]==0)
        {
            if (sendMessageCompletionBlock) {
                sendMessageCompletionBlock(operation);
            }
        }else
        {
            if (sendMessageFaildBlock) {
                sendMessageFaildBlock(operation,[allDic objectForKey:@"bbsinfo"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (sendMessageFaildBlock) {
            sendMessageFaildBlock(operation,@"发送失败，请检查当前网络");
        }
    }];
    
    
    [sendRequest start];
     */
}








@end

















