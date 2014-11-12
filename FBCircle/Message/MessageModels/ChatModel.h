//
//  ChatModel.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ChatModelBlock)(NSMutableArray * array,int count);

typedef void(^SendMessageCompletionBlock)(ASIFormDataRequest * operation);

typedef void(^SendMessageFailBlock)(ASIFormDataRequest * operation,NSString * error);



@interface ChatModel : NSObject
{
    ChatModelBlock chatModelBlock;
    
    SendMessageCompletionBlock sendMessageCompletionBlock;
    
    SendMessageFailBlock sendMessageFaildBlock;
    
    AFHTTPRequestOperation * chatRequest;
    
    ASIFormDataRequest * sendRequest;
}


@property(nonatomic,strong)NSString * msg_id;
@property(nonatomic,strong)NSString * from_uid;
@property(nonatomic,strong)NSString * to_uid;
@property(nonatomic,strong)NSString * fuid_tuid;
@property(nonatomic,strong)NSString * date_now;
@property(nonatomic,strong)NSString * is_del;
@property(nonatomic,strong)NSString * from_username;
@property(nonatomic,strong)NSString * to_username;
@property(nonatomic,strong)NSString * zt;
@property(nonatomic,strong)NSString * msg_message;

@property(nonatomic,strong)NSMutableArray * data_array;




-(ChatModel *)initWithDic:(NSDictionary *)dic;


-(void)initHttpWithPage:(int)page WithMaxId:(NSString *)maxId WithToUid:(NSString *)toUid WithBlock:(ChatModelBlock)theBlock;


-(void)sendMessageWith:(ChatModel *)model WithCompletionBlock:(SendMessageCompletionBlock)theCompletionBlock WithFaildBlock:(SendMessageFailBlock)theFaildBlock;



@end

















