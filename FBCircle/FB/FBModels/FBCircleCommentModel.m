//
//  FBCircleCommentModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleCommentModel.h"

@implementation FBCircleCommentModel
@synthesize comment_content = _comment_content;
@synthesize comment_dateline = _comment_dateline;
@synthesize comment_uid = _comment_uid;
@synthesize comment_username = _comment_username;
@synthesize comment_face = _comment_face;
@synthesize comment_tid = _comment_tid;
@synthesize requestOperation = _requestOperation;
@synthesize data_array = _data_array;



-(FBCircleCommentModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        self.comment_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        self.comment_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        self.comment_content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        self.comment_dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        self.comment_face = [NSString stringWithFormat:@"%@",[dic objectForKey:@"face_small"]];
    }
    
    return self;
}


-(void)loadCommentsWithTid:(NSString *)theTid Page:(int)page WithCommentBlock:(FBCircleCommentModelCompletionBlock)completionBlock WithFailedBlock:(FBCircleCommentModelFailedBlock)failedBlock
{
    fbCircleCommentModelCompletionBlock = completionBlock;
    fbCircleCommentModelFailedBlock = failedBlock;
    NSString * fullUrl = [NSString stringWithFormat:FB_WEIBO_DETAIL_COMMENTS,theTid,[SzkAPI getAuthkeyGBK],page];
    NSLog(@"请求评论接口 ----  %@",fullUrl);
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    _requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    __block AFHTTPRequestOperation * request = _requestOperation;
    __weak typeof(self) bself = self;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = [operation.responseString objectFromJSONString];
        
        NSLog(@"评论数据-----%@",dic);
        if ([[dic objectForKey:@"weibomain"] isEqual:[NSNull null]] || [[dic objectForKey:@"weibomain"] isEqual:@"<null>"])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该篇微博不存在" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
            [alert show];
            return;
        }
        
        if (!bself.data_array) {
            bself.data_array = [NSMutableArray array];
        }else
        {
            if (page == 1)
            {
                [bself.data_array removeAllObjects];
            }
        }
        
        NSDictionary * value = [dic objectForKey:@"weiboinfo"];
        if (![value isEqual:[NSNull null]] && ![value isEqual:@"<null>"])
        {
            NSArray * temp = [ZSNApi sortArrayWith:[value allKeys]];
            
            for (NSString * key in temp)
            {
                NSDictionary * aDic = [value objectForKey:[NSString stringWithFormat:@"%@",key]];
                FBCircleCommentModel * model = [[FBCircleCommentModel alloc] initWithDictionary:aDic];
                [bself.data_array addObject:model];
            }
        }
        
        if (fbCircleCommentModelCompletionBlock) {
            fbCircleCommentModelCompletionBlock(bself.data_array);
        }
        
        /*
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            if (!bself.data_array) {
                bself.data_array = [NSMutableArray array];
            }else
            {
                if (page == 1)
                {
                    [bself.data_array removeAllObjects];
                }
            }
            
            NSArray * array = [allDic objectForKey:@"datainfo"];
            
            for (NSDictionary * dic in array)
            {
                FBCircleCommentModel * model = [[FBCircleCommentModel alloc] initWithDictionary:dic];
                
                [bself.data_array addObject:model];
            }
            
            if (fbCircleCommentModelCompletionBlock) {
                fbCircleCommentModelCompletionBlock(bself.data_array);
            }
        }
        */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fbCircleCommentModelFailedBlock) {
            fbCircleCommentModelFailedBlock(operation);
        }
    }];
    
    
    [_requestOperation start];
}



@end

















